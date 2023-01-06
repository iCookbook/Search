//
//  SpySearchView.swift
//  Search-Unit-Tests
//
//  Created by Егор Бадмаев on 06.01.2023.
//

import XCTest
@testable import Search
@testable import Models

class SpySearchView: SearchViewInput {
    
    var filledInSearchRequestsHistory: [String]!
    var didClearSearchRequestsHistoryFlag: Bool!
    var changeFilterIconFlag: Bool!
    
    var expectation: XCTestExpectation!
    
    func fillInSearchRequestsHistory(_ searchRequestsHistory: [String]) {
        filledInSearchRequestsHistory = searchRequestsHistory
        
        if let expectation = expectation {
            expectation.fulfill()
        }
    }
    
    func didClearSearchRequestsHistory() {
        didClearSearchRequestsHistoryFlag = true
        
        if let expectation = expectation {
            expectation.fulfill()
        }
    }
    
    func changeFilterIcon(by flag: Bool) {
        changeFilterIconFlag = flag
    }
    
    func fillData(with data: [Recipe], withOverridingCurrentData: Bool) {
    }
    
    func displayError(title: String, message: String, image: UIImage?) {
    }
}
