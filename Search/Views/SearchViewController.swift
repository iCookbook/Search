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
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
//        searchBar.showsCancelButton = true
        searchBar.showsBookmarkButton = true
        searchBar.setImage(Images.Search.filter, for: .bookmark, state: .normal)
        searchBar.setImage(Images.Search.filterFill, for: .bookmark, state: .selected) // .normal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var searchController: UISearchController = {
//        let searchController = UISearchController(searchResultsController: historyViewController)
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = keywords.randomElement()?.capitalized
        searchController.searchBar.sizeToFit()
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(Images.Search.filter, for: .bookmark, state: .normal)
        searchController.searchBar.setImage(Images.Search.filterFill, for: .bookmark, state: .highlighted) // .normal
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    
    private let historyViewController = HistoryViewController()
    
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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        guard let output = output as? SearchViewOutput else { return }
        output.requestRandomData()
        output.fetchSearchRequestsHistory()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        title = Texts.Search.title
        view.backgroundColor = Colors.systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(searchController.searchBar)
        contentView.addSubview(categoriesTableView)
        
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
            
            searchController.searchBar.topAnchor.constraint(equalTo: contentView.topAnchor),
            searchController.searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            searchController.searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            categoriesTableView.topAnchor.constraint(equalTo: searchController.searchBar.bottomAnchor),
            categoriesTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoriesTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            recipesCollectionView.topAnchor.constraint(equalTo: categoriesTableView.bottomAnchor),
            recipesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            activityIndicator.topAnchor.constraint(equalTo: categoriesTableView.bottomAnchor, constant: 60),
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
}

// MARK: - SearchViewInput

extension SearchViewController: SearchViewInput {
    
    func fillInSearchRequestsHistory(_ searchRequestsHistory: [String]) {
        historyViewController.fillSearchRequestsHistory(with: searchRequestsHistory)
    }
}

// MARK: - UISearchBarDelegate, UISearchControllerDelegate

extension SearchViewController: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        // TODO: Open filter view controller
        
    }
}

// MARK: - Collection View

extension SearchViewController {
    
    // MARK: Header
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionViewHeader.identifier, for: indexPath) as? TitleCollectionViewHeader else {
                fatalError("Could not cast to `TitleCollectionViewHeader` for indexPath \(indexPath) in viewForSupplementaryElementOfKind")
            }
            return header
        default:
            // empty view
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 36)
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
        44
    }
}

extension SearchViewController {
    /// Keywords to show in placeholder of search bar.
    var keywords: [String] {
        ["chicken", "beef", "mushroom", "cheese", "pepperoni", "pepper", "garlic", "basil", "onion", "salami", "bacon", "shrimps", "fish", "anchovies", "pepper", "olives", "meat", "veal", "lamb", "meatballs", "turkey"]
    }
}
