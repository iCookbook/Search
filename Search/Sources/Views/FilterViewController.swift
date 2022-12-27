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

protocol FilterDelegateProtocol: AnyObject {
    func provideSelectedFilters(data: [[FilterProtocol]])
}

final class FilterViewController: UIViewController {
    
    /// Delegate to provide data from this view controller.
    weak var delegate: FilterDelegateProtocol?
    
    private let data: [[FilterProtocol]] = [
        Diet.allCases, Cuisine.cuisines, Dish.allCases, Meal.allCases
    ]
    
    /// Collection view with filters.
    private lazy var filtersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.size.width - 32) / 2, height: view.frame.size.height * 0.38)
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
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
    
    private func selectOnFilters() {
        UserDefaults.dietsFilters.forEach { diet in
            let index = data[0].firstIndex {
                guard let item = $0 as? Diet else { return false }
                return item == diet
            } ?? 0
            filtersCollectionView.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
        }
        UserDefaults.cuisinesFilters.forEach { cuisine in
            let index = data[1].firstIndex {
                guard let item = $0 as? Cuisine else { return false }
                return item == cuisine
            } ?? 0
            filtersCollectionView.selectItem(at: IndexPath(row: index, section: 1), animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
        }
        UserDefaults.dishesFilters.forEach { dish in
            let index = data[2].firstIndex {
                guard let item = $0 as? Dish else { return false }
                return item == dish
            } ?? 0
            filtersCollectionView.selectItem(at: IndexPath(row: index, section: 2), animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
        }
        UserDefaults.mealsFilters.forEach { meal in
            let index = data[3].firstIndex {
                guard let item = $0 as? Meal else { return false }
                return item == meal
            } ?? 0
            filtersCollectionView.selectItem(at: IndexPath(row: index, section: 3), animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
        }
    }
}

extension FilterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell else {
            fatalError("Could not cast to `FilterCollectionViewCell` for indexPath \(indexPath) in cellForItemAt")
        }
        cell.configure(with: data[indexPath.section][indexPath.row])
        return cell
    }
}
