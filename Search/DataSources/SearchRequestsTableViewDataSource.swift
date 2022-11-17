//
//  SearchRequestsTableViewDataSource.swift
//  Search
//
//  Created by Егор Бадмаев on 17.11.2022.
//

import UIKit
import Models
import CommonUI
import Resources

protocol SearchRequestsTableViewDataSourceDelegate: AnyObject {
    /// Method to provide data to the view controller.
    /// - Parameter keyword: data to provide.
    func didSelectRowWith(keyword: String)
    
    /// Handle clear history button tapping.
    func clearHistoryButtonTapped()
}

/// Class implementing `UITableViewDelegate` and `UITableViewDataSource` protocols.
///
/// We need to use them, because we have 2 table view on the view controller. So not to handle what table view is, this class responsible for all table view working.
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
    
    @objc public func clearHistoryButtonTapped() {
        view?.clearHistoryButtonTapped()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        view?.didSelectRowWith(keyword: searchRequestsHistory[indexPath.row])
    }
    
    // MARK: Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleTableViewHeader.identifier) as? TitleTableViewHeader else {
            fatalError("Could not cast table view header to `TitleTableViewHeader` for section: \(section)")
        }
        header.configure(title: Texts.Search.recent)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        36
    }
}
