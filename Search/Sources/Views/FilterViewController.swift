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
}

final class FilterViewController: UIViewController {
    
    /// Delegate to provide data from this view controller.
    weak var delegate: FilterDelegateProtocol?
    
    private let data: [[FilterProtocol]] = [
        Cuisine.cuisines, Diet.allCases, Dish.allCases, Meal.allCases
    ]
    
    /// Collection view with filters.
    private lazy var filtersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.size.width - 32) / 2, height: view.frame.size.height * 0.38)
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
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
        dismiss(animated: true)
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
//        cell.configure
        cell.backgroundColor = .red
        return cell
    }
}
