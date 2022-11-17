//
//  SearchRequestsTableViewDataSource.swift
//  Search
//
//  Created by Егор Бадмаев on 17.11.2022.
//

import UIKit
import Models

protocol SearchRequestsTableViewDataSourceDelegate: AnyObject {
    /// Method to provide data to the view controller.
    /// - Parameter keyword: data to provide.
    func didSelectRowWith(keyword: String)
}

final class SearchRequestsTableViewDataSource: NSObject {
    
    /// Link to the view controller to provide delegate methods.
    weak var view: SearchRequestsTableViewDataSourceDelegate?
    
    // MARK: - Private Properties
    
    /// History of search user's search requests provided from the UserDefaults.
    private var searchRequestsHistory = [String]()
    
    // MARK: - Public Methods
    
    public func fillInData(searchRequestsHistory: [String]) {
        self.searchRequestsHistory = searchRequestsHistory
    }
    
    /// Clears all data.
    public func clearData() {
        searchRequestsHistory = []
    }
}

extension SearchRequestsTableViewDataSource: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchRequestsHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as? HistoryTableViewCell else {
            fatalError("Could not cast table view cell to `CategoryTableViewCell` for indexPath: \(indexPath)")
        }
        cell.configure(title: searchRequestsHistory[indexPath.row])
        return cell
    }
}
