//
//  SearchViewController.swift
//  Search
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import UIKit
import Common
import CommonUI
import Resources

final class SearchViewController: BaseRecipesViewController {
    
    // MARK: - Private Properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.preservesSuperviewLayoutMargins = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var categoriesTableView: UITableView = {
        let tableView = NonScrollableTableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.register(TitleTableViewHeader.self, forHeaderFooterViewReuseIdentifier: TitleTableViewHeader.identifier)
        return tableView
    }()
    
    private let titleRecommendedLabel = TitleLabel(text: Texts.Search.recommended)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        output.requestRandomData()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        title = Texts.Search.title
        view.backgroundColor = Colors.systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(categoriesTableView)
        contentView.addSubview(titleRecommendedLabel)
        
        contentView.addSubview(recipesCollectionView)
        recipesCollectionView.isScrollEnabled = false
        contentView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            categoriesTableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoriesTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoriesTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleRecommendedLabel.topAnchor.constraint(equalTo: categoriesTableView.bottomAnchor),
            titleRecommendedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleRecommendedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            recipesCollectionView.topAnchor.constraint(equalTo: titleRecommendedLabel.bottomAnchor, constant: 12),
            recipesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            activityIndicator.topAnchor.constraint(equalTo: categoriesTableView.bottomAnchor, constant: 60),
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
}

extension SearchViewController: SearchViewInput {
}

// MARK: - Collection View

extension SearchViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// We need to check that it is not a setup (first launch, when collection view's content size height equals 0) and make usual check for the end of the collection (scroll) view.
        if (recipesCollectionView.contentSize.height != 0 &&
            scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height)) {
            /// Fetcing should not be in progress and there should be valid next page url.
            guard !isFetchingInProgress,
                  let nextPageUrl = nextPageUrl else { return }
            
            isFetchingInProgress = true
            /// Because it is _event handling_, we need to use `userInteractive` quality of service.
            DispatchQueue.global(qos: .userInteractive).async {
                self.output.requestData(urlString: nextPageUrl)
            }
        }
    }
}

// MARK: - Table View

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else {
            fatalError("Could not cast table view cell to `CategoryTableViewCell` for indexPath: \(indexPath)")
        }
//        cell.configure(category: <#T##Dish#>)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleTableViewHeader.identifier) as? TitleTableViewHeader else {
            fatalError("Could not cast table view cell to `TitleTableViewHeader` in section: \(section)")
        }
        header.configure(title: Texts.Search.categories)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        36
    }
}
