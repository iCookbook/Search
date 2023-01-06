//
//  FilterViewController.swift
//  Search
//
//  Created by Егор Бадмаев on 17.11.2022.
//

import UIKit
import CommonUI
import Models
import Resources
import Logger

protocol FilterDelegateProtocol: AnyObject {
    func provideSelectedFilters(data: [[FilterProtocol]])
}

final class FilterViewController: UIViewController {
    
    /// Delegate to provide data from this view controller.
    weak var delegate: FilterDelegateProtocol?
    
    private let data: [[FilterProtocol]] = [
        Diet.allCases, Cuisine.cuisines, Dish.allCases, Meal.allCases
    ]
    
    /// Titles for headers.
    private let headerTitles = [Texts.Search.diets, Texts.Search.cuisines, Texts.Search.dishes, Texts.Search.meals]
    
    /// Collection view with filters.
    private lazy var filtersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 16)
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeader.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Init
    
    init(delegate: FilterDelegateProtocol?) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectOnFilters()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.Search.close, style: .plain, target: self, action: #selector(closeBarButtonTapped))
        
        view.backgroundColor = Colors.systemBackground
        view.addSubview(filtersCollectionView)
        
        NSLayoutConstraint.activate([
            filtersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            filtersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filtersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            filtersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Handles tapping on _"Close"_ bar button.
    @objc private func closeBarButtonTapped() {
        /// Gets all selected filters
        var activeFilters: [[FilterProtocol]] = [[], [], [], []]
        filtersCollectionView.indexPathsForSelectedItems?.forEach { indexPath in
            activeFilters[indexPath.section].append(data[indexPath.section][indexPath.row])
        }
        /// Provides them to the delegate
        delegate?.provideSelectedFilters(data: activeFilters)
        dismiss(animated: true)
    }
    
    /// Turns indicators on on each filter defines in UserDefaults.
    private func selectOnFilters() {
        UserDefaults.dietsFilters.forEach { diet in
            let index = data[Filters.diet.rawValue].firstIndex {
                guard let item = $0 as? Diet else { return false }
                return item == diet
            } ?? 0
            filtersCollectionView.selectItem(at: IndexPath(row: index, section: Filters.diet.rawValue), animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
        }
        UserDefaults.cuisinesFilters.forEach { cuisine in
            let index = data[Filters.cuisine.rawValue].firstIndex {
                guard let item = $0 as? Cuisine else { return false }
                return item == cuisine
            } ?? 0
            filtersCollectionView.selectItem(at: IndexPath(row: index, section: Filters.cuisine.rawValue), animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
        }
        UserDefaults.dishesFilters.forEach { dish in
            let index = data[Filters.dish.rawValue].firstIndex {
                guard let item = $0 as? Dish else { return false }
                return item == dish
            } ?? 0
            filtersCollectionView.selectItem(at: IndexPath(row: index, section: Filters.dish.rawValue), animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
        }
        UserDefaults.mealsFilters.forEach { meal in
            let index = data[Filters.meal.rawValue].firstIndex {
                guard let item = $0 as? Meal else { return false }
                return item == meal
            } ?? 0
            filtersCollectionView.selectItem(at: IndexPath(row: index, section: Filters.meal.rawValue), animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
        }
    }
}

extension FilterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell else {
            Logger.log("Could not cast to `FilterCollectionViewCell` for indexPath \(indexPath) in cellForItemAt", logType: .error)
            return UICollectionViewCell()
        }
        cell.configure(with: data[indexPath.section][indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewHeader.identifier, for: indexPath) as? CollectionViewHeader else {
                Logger.log("Could not cast to `CollectionViewHeader` for indexPath \(indexPath) in `viewForSupplementaryElementOfKind` method", logType: .error)
                return UICollectionViewCell()
            }
            header.configure(title: headerTitles[indexPath.section])
            return header
        default:
            Logger.log("Unhandled case for kind \(kind) and indexPath \(indexPath). Check description for details:", logType: .warning)
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.frame.size.width / 2 - 24, height: 40)
        default:
            return CGSize(width: collectionView.frame.size.width / 2 - 24, height: 80)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: filtersCollectionView.frame.size.width, height: 50)
    }
}
