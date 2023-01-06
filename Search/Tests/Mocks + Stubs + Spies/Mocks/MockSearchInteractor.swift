//
//  MockSearchInteractor.swift
//  Search-Unit-Tests
//
//  Created by Егор Бадмаев on 06.01.2023.
//

@testable import Search
@testable import Models

class MockSearchInteractor: SearchInteractorInput {
    
    func provideSearchRequestsHistory() {
    }
    
    func clearSearchRequestsHistory() {
    }
    
    func isFilteringOn() {
    }
    
    func requestRandomData(by category: Cuisine) {
    }
    
    func requestData(by keyword: String) {
    }
    
    func turnOnSelectedFilters(data: [[FilterProtocol]]) {
    }
    
    func provideRandomData() {
    }
    
    func provideData(urlString: String?) {
    }
}
