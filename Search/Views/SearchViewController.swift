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
        searchController.hidesNavigationBarDuringPresentation = true
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
        let tableView = NonScrollableTableView()
        tableView.delegate = categoriesTableViewDataSource
        tableView.dataSource = categoriesTableViewDataSource
        tableView.estimatedRowHeight = 44
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
        let tableView = NonScrollableTableView()
        tableView.delegate = searchRequestsTableViewDataSource
        tableView.dataSource = searchRequestsTableViewDataSource
        tableView.estimatedRowHeight = 44
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        tableView.register(TitleTableViewHeader.self, forHeaderFooterViewReuseIdentifier: TitleTableViewHeader.identifier)
        return tableView
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
        // TODO: Implement offline mode
    }
    
    // MARK: - Private Methods
    
    /// When user tapps on a category or searching something, we need to display activity indicator and hide table view with all titles.
    private func handleViewOnSearching() {
        activityIndicator.startAnimating()
        
        categoriesTitleLabel.text = nil
        recommendedTitleLabel.text = nil
        
        categoriesTableViewDataSource.clearData()
        categoriesTableView.reloadData()
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.transitionFlipFromBottom, .curveEaseOut], animations: { [unowned self] in
            categoriesTableViewTopAnchor.constant = 0
            recommendedTitleLabelTopAnchor.constant = 0
            recipesCollectionViewTopAnchor.constant = 0
            view.layoutIfNeeded()
        })
    }
    
    private func setupView() {
        navigationItem.searchController = searchController
        // removes text from back button's title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        title = Texts.Search.title
        view.backgroundColor = Colors.systemBackground
        
        searchRequestsTableViewDataSource.view = self
        categoriesTableViewDataSource.view = self
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
}

// MARK: - SearchViewInput

extension SearchViewController: SearchViewInput {
    
    /// Provides search requests history to the data source.
    /// - Parameter searchRequestsHistory: search requests history from UserDefaults.
    func fillInSearchRequestsHistory(_ searchRequestsHistory: [String]) {
        searchRequestsTableViewDataSource.fillInData(searchRequestsHistory: searchRequestsHistory)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // TODO: Implement opening table view with `searchRequestsHistory`
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let presenter = presenter as? SearchViewOutput,
              let keyword = searchBar.text
        else { return }
        
        presenter.searchBarButtonClicked(with: keyword)
        presenter.fetchSearchRequestsHistory()
        handleViewOnSearching()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        // TODO: Open filter view controller
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
            /// Because it is _event handling_, we need to use `userInteractive` quality of service.
            DispatchQueue.global(qos: .userInteractive).async {
                self.presenter.requestData(urlString: nextPageUrl)
            }
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
    /// - Parameter data: provided data from tapped row.
    func didSelectRowWith(category: Cuisine) {
        guard let presenter = presenter as? SearchViewOutput else { return }
        presenter.categoryDidTapped(category)
        
        handleViewOnSearching()
    }
    
    /// Delegate method from ``SearchRequestsTableViewDataSourceDelegate`` to handle tapping on a keyword from requests history.
    /// - Parameter keyword: keyword to search.
    func didSelectRowWith(keyword: String) {
        guard let presenter = presenter as? SearchViewOutput else { return }
        presenter.searchBarButtonClicked(with: keyword)
        
        handleViewOnSearching()
    }
}

extension SearchViewController {
    /// Keywords to show in placeholder of search bar.
    var keywords: [String] {
        ["chicken", "beef", "mushroom", "cheese", "pepperoni", "pepper", "garlic", "basil", "onion", "salami", "bacon", "shrimps", "fish", "anchovies", "pepper", "olives", "meat", "veal", "lamb", "meatballs", "turkey"]
    }
}
