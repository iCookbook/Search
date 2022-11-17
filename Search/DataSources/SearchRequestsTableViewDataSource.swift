//
//  SearchRequestsTableViewDataSource.swift
//  Search
//
//  Created by Егор Бадмаев on 17.11.2022.
//

import UIKit
import Models

protocol SearchRequestsTableViewDataSourceDelegate: AnyObject {
    func didSelectRowWith(keyword: String)
}

final class SearchRequestsTableViewDataSource: NSObject {
    
    /// Link to the view controller to provide delegate methods.
    weak var view: SearchRequestsTableViewDataSourceDelegate?
    
    // MARK: - Private Properties
    
    private var searchRequestsHistory: [String]
    
    // MARK: - Init
    
    init(searchRequestsHistory: [String]) {
        self.searchRequestsHistory = searchRequestsHistory
    }
    
    // MARK: - Public Methods
    
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
