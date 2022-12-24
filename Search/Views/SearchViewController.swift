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
import Models
import Resources

final class SearchViewController: BaseRecipesViewController {
    
    // MARK: - Private Properties
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = keywords.randomElement()?.capitalized
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(Images.Search.filter, for: .bookmark, state: .normal)
        searchController.searchBar.setImage(Images.Search.filterFill, for: .bookmark, state: .highlighted) // .normal
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    
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
    
    /// These labels were implemented here, not as headers, because it is much easier to hide them in view controller.
    private let categoriesTitleLabel = TitleLabel(text: Texts.Search.cuisines)
    private let recommendedTitleLabel = TitleLabel(text: Texts.Search.recommended)
    
    private let categoriesTableViewDataSource = SearchCategoriesTableViewDataSource()
    private lazy var categoriesTableView: UITableView = {
        let tableView = TableView()
        tableView.delegate = categoriesTableViewDataSource
        tableView.dataSource = categoriesTableViewDataSource
        tableView.estimatedRowHeight = 44
        tableView.layer.zPosition = 1
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.register(TitleTableViewHeader.self, forHeaderFooterViewReuseIdentifier: TitleTableViewHeader.identifier)
        return tableView
    }()
    
    /// Constraints, that were extracted here to change `constant` in `handleViewOnUpdatingData` method.
    private lazy var categoriesTableViewTopAnchor = NSLayoutConstraint(item: categoriesTableView, attribute: .top, relatedBy: .equal, toItem: categoriesTitleLabel, attribute: .bottom, multiplier: 1, constant: 4)
    private lazy var recommendedTitleLabelTopAnchor = NSLayoutConstraint(item: recommendedTitleLabel, attribute: .top, relatedBy: .equal, toItem: categoriesTableView, attribute: .bottom, multiplier: 1, constant: 12)
    private lazy var recipesCollectionViewTopAnchor = NSLayoutConstraint(item: recipesCollectionView, attribute: .top, relatedBy: .equal, toItem: recommendedTitleLabel, attribute: .bottom, multiplier: 1, constant: 8)
    
    private let searchRequestsTableViewDataSource = SearchRequestsTableViewDataSource()
    private lazy var searchRequestsHistoryTableView: UITableView = {
        let tableView = TableView()
        tableView.delegate = searchRequestsTableViewDataSource
        tableView.dataSource = searchRequestsTableViewDataSource
        tableView.rowHeight = 44
        tableView.isScrollEnabled = true
        tableView.bounces = false
        tableView.alpha = 0
        tableView.backgroundColor = Colors.systemBackground
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        tableView.register(TitleTableViewHeader.self, forHeaderFooterViewReuseIdentifier: TitleTableViewHeader.identifier)
        return tableView
    }()
    
    private let offlineTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.errorTitle()
        label.text = Texts.Search.offlineModeTitle
        return label
    }()
    
    private let offlineSubitleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.smallMedium()
        label.textColor = Colors.secondaryLabel
        label.text = Texts.Search.offlineModeDescription
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var offlineStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [offlineTitleLabel, offlineSubitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.layer.zPosition = 1
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        presenter.requestRandomData()
        guard let presenter = presenter as? SearchViewOutput else { return }
        presenter.fetchSearchRequestsHistory()
    }
    
    override func turnOnOfflineMode() {
        view.addSubview(offlineStackView)
        categoriesTableView.removeFromSuperview()
        categoriesTitleLabel.removeFromSuperview()
        recommendedTitleLabel.removeFromSuperview()
        
        NSLayoutConstraint.activate([
            offlineStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: view.layoutMargins.left),
            offlineStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -view.layoutMargins.right),
            offlineStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            offlineStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    // MARK: - Private Methods
    
    /// When user tapps on a category or searching something, we need to display activity indicator and hide table view with all titles.
    private func handleViewOnSearching() {
        activityIndicator.startAnimating()
        hideHistoryTableView()
        
        categoriesTitleLabel.text = nil
        recommendedTitleLabel.text = nil
        
        categoriesTableViewDataSource.clearData()
        categoriesTableView.reloadData()
        
        UIView.animate(withDuration: 1.4, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.5, options: .allowUserInteraction, animations: {
            self.categoriesTableViewTopAnchor.constant = 0
            self.recommendedTitleLabelTopAnchor.constant = 0
            self.recipesCollectionViewTopAnchor.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    private func setupView() {
        navigationItem.searchController = searchController
        // removes text from back button's title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        title = Texts.Search.title
        view.backgroundColor = Colors.systemBackground
        definesPresentationContext = true
        
        searchRequestsTableViewDataSource.delegate = self
        categoriesTableViewDataSource.delegate = self
        /// This code choose 5 categories randomly.
        let randomIndex = Int.random(in: 0..<Cuisine.cuisines.count - 5)
        let categories = Array(Cuisine.cuisines.shuffled()[randomIndex..<randomIndex + 5])
        categoriesTableViewDataSource.fillInData(categories: categories)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(categoriesTitleLabel)
        contentView.addSubview(categoriesTableView)
        
        contentView.addSubview(recommendedTitleLabel)
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
            
            categoriesTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoriesTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoriesTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            categoriesTableViewTopAnchor,
            categoriesTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoriesTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            recommendedTitleLabelTopAnchor,
            recommendedTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recommendedTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            recipesCollectionViewTopAnchor,
            recipesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 20),
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    private func showHistoryTableView() {
        view.addSubview(searchRequestsHistoryTableView)
        
        NSLayoutConstraint.activate([
            searchRequestsHistoryTableView.topAnchor.constraint(equalTo: searchController.searchBar.bottomAnchor),
            searchRequestsHistoryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchRequestsHistoryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchRequestsHistoryTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut]) {
            self.searchRequestsHistoryTableView.alpha = 1
        }
    }
    
    private func hideHistoryTableView() {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut]) {
            self.searchRequestsHistoryTableView.alpha = 0
        } completion: { isFinished in
            self.searchRequestsHistoryTableView.removeFromSuperview()
        }
    }
}

// MARK: - SearchViewInput

extension SearchViewController: SearchViewInput {
    
    /// Provides search requests history to the data source.
    ///
    /// - Parameter searchRequestsHistory: search requests history from UserDefaults.
    func fillInSearchRequestsHistory(_ searchRequestsHistory: [String]) {
        searchRequestsTableViewDataSource.fillInData(searchRequestsHistory: searchRequestsHistory)
        
        DispatchQueue.main.async {
            self.searchRequestsHistoryTableView.reloadData()
        }
    }
    
    /// Clears search requests history from data source.
    func didClearedSearchRequestsHistory() {
        searchRequestsTableViewDataSource.clearData()
        
        DispatchQueue.main.async {
            self.searchRequestsHistoryTableView.reloadData()
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showHistoryTableView()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        hideHistoryTableView()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let presenter = presenter as? SearchViewOutput,
              let keyword = searchBar.text, !keyword.isEmpty else { return }
        
        presenter.requestData(by: keyword)
        presenter.fetchSearchRequestsHistory()
        handleViewOnSearching()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let filterViewController = UINavigationController(rootViewController: FilterViewController(delegate: self))
        
        if #available(iOS 15.0, *),
           let sheet = filterViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(filterViewController, animated: true)
    }
}

// MARK: - Collection View

extension SearchViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// We need to check:
        /// 1. it is not a setup (first launch, when collection view's content size height equals 0);
        /// 2. Categories table view was hidden;
        /// 3. Check for the end of the collection (scroll) view.
        if (recipesCollectionView.contentSize.height != 0 &&
            categoriesTableViewDataSource.isEmpty() &&
            scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height)) {
            
            /// Fetcing should not be in progress and there should be valid next page url.
            guard !isFetchingInProgress,
                  let nextPageUrl = nextPageUrl else { return }
            
            isFetchingInProgress = true
            presenter.requestData(urlString: nextPageUrl)
        }
    }
    
    // MARK: Footer
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        switch elementKind {
        case UICollectionView.elementKindSectionFooter:
            guard let footer = view as? LoadingCollectionViewFooter else {
                fatalError("Could not cast to `LoadingCollectionViewFooter` for indexPath \(indexPath) in willDisplaySupplementaryView")
            }
            /// If there is link to the next page and there is no categories start loading.
            if nextPageUrl != nil && categoriesTableViewDataSource.isEmpty() {
                footer.startActivityIndicator()
            }
        default:
            break
        }
    }
}

// MARK: - Table View Data Sources delegates

extension SearchViewController: SearchCategoriesTableViewDataSourceDelegate, SearchRequestsTableViewDataSourceDelegate {
    
    /// Delegate method from ``SearchCategoriesTableViewDataSourceDelegate`` to handle tapping on a random category.
    ///
    /// - Parameter data: provided data from tapped row.
    func didSelectRowWith(category: Cuisine) {
        guard let presenter = presenter as? SearchViewOutput else { return }
        presenter.categoryDidTapped(category)
        
        handleViewOnSearching()
    }
    
    /// Delegate method from ``SearchRequestsTableViewDataSourceDelegate`` to handle tapping on a keyword from requests history.
    ///
    /// - Parameter keyword: keyword to search.
    func didSelectRowWith(keyword: String) {
        guard let presenter = presenter as? SearchViewOutput else { return }
        presenter.requestData(by: keyword)
        
        searchController.searchBar.text = keyword
        searchController.searchBar.resignFirstResponder()
        handleViewOnSearching()
    }
    
    /// Handles tapping on the clear history button.
    func clearHistoryButtonTapped() {
        guard let presenter = presenter as? SearchViewOutput else { return }
        presenter.clearSearchRequestsHistory()
    }
}

// MARK: - FilterDelegateProtocol

extension SearchViewController: FilterDelegateProtocol {
    
}

extension SearchViewController {
    /// Keywords to show in placeholder of search bar.
    var keywords: [String] {
        ["chicken", "beef", "mushroom", "cheese", "pepperoni", "garlic", "basil", "onion", "salami", "bacon", "shrimps", "fish", "anchovies", "pepper", "olives", "meat", "veal", "lamb", "meatballs", "turkey"]
    }
}
