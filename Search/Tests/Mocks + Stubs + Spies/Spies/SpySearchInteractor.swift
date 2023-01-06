//
//  SpySearchInteractor.swift
//  Search-Unit-Tests
//
//  Created by Егор Бадмаев on 06.01.2023.
//

import XCTest
@testable import Search
@testable import Models

class SpySearchInteractor: SearchInteractorInput {
    
    var didProvideSearchRequestsHistory: Bool!
    var didClearSearchRequestsHistory: Bool!
    var isFilteringOnFlagChecked: Bool!
    var categoryRequestRandomDataWith: Cuisine!
    var keywordRequestDataWith: String!
    var selectedFilters: [[FilterProtocol]]!
    var didProvideRandomData: Bool!
    var urlStringProvideDataWith: String!
    
    var expectation: XCTestExpectation!
    
    func provideSearchRequestsHistory() {
        didProvideSearchRequestsHistory = true
        
        if let expectation = expectation {
            expectation.fulfill()
        }
    }
    
    func clearSearchRequestsHistory() {
        didClearSearchRequestsHistory = true
    }
    
    func isFilteringOn() {
        isFilteringOnFlagChecked = true
    }
    
    func requestRandomData(by category: Cuisine) {
        categoryRequestRandomDataWith = category
        
        if let expectation = expectation {
            expectation.fulfill()
        }
    }
    
    func requestData(by keyword: String) {
        keywordRequestDataWith = keyword
        
        if let expectation = expectation {
            expectation.fulfill()
        }
    }
    
    func turnOnSelectedFilters(data: [[FilterProtocol]]) {
        selectedFilters = data
    }
    
    func provideRandomData() {
        didProvideRandomData = true
    }
    
    func provideData(urlString: String?) {
        urlStringProvideDataWith = urlString
    }
}
