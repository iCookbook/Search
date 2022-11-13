//
//  HistoryViewController.swift
//  Search
//
//  Created by Егор Бадмаев on 13.11.2022.
//

import UIKit
import Resources

final class HistoryViewController: UITableViewController {
    
    // MARK: - Private Properties
    
    private var searchRequestsHistory = [String]()
    
    // MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - Public Methods
    
    public func fillSearchRequestsHistory(with data: [String]) {
        searchRequestsHistory = data
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = Colors.systemBackground
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
    }
    
    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchRequestsHistory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as? HistoryTableViewCell
        else {
            fatalError("Could not cast cell at indexPath \(indexPath) to 'HistoryTableViewCell' in 'Search' module")
        }
        cell.configure(title: searchRequestsHistory[indexPath.row])
        return cell
    }
}
