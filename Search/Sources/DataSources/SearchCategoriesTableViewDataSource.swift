//
//  SearchCategoriesTableViewDataSource.swift
//  Search
//
//  Created by Егор Бадмаев on 17.11.2022.
//

import UIKit
import Models

/// Delegate protocol for ``SearchCategoriesTableViewDataSource``.
protocol SearchCategoriesTableViewDataSourceDelegate: AnyObject {
    /// Method to provide data to the view controller.
    /// 
    /// - Parameter category: data to provide.
    func didSelectRowWith(category: Cuisine)
}

/// Class implementing `UITableViewDelegate` and `UITableViewDataSource` protocols.
///
/// We need to use them, because we have 2 table view on the view controller. So not to handle what table view is, this class responsible for all table view working.
final class SearchCategoriesTableViewDataSource: NSObject {
    
    /// Link to the view controller to provide delegate methods.
    weak var delegate: SearchCategoriesTableViewDataSourceDelegate?
    
    // MARK: - Private Properties
    
    /// Data for this data source.
    private var categories = [Cuisine]()
    
    // MARK: - Public Methods
    
    /// Fulfills data for this data source.
    ///
    /// - Parameter categories: data to fill in.
    public func fillInData(categories: [Cuisine]) {
        self.categories = categories
    }
    
    /// Clears all data by setting empty array for data.
    public func clearData() {
        categories = []
    }
    
    /// Checks whether data is empty or not.
    ///
    /// - Returns: A boolean value indicating whether the collection is empty.
    public func isEmpty() -> Bool {
        categories.isEmpty
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchCategoriesTableViewDataSource: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else {
            fatalError("Could not cast table view cell to `CategoryTableViewCell` for indexPath: \(indexPath)")
        }
        cell.configure(category: categories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.didSelectRowWith(category: categories[indexPath.row])
    }
}
