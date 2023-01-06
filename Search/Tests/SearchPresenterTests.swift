//
//  SearchPresenterTests.swift
//  Search-Unit-Tests
//
//  Created by Егор Бадмаев on 05.01.2023.
//

import XCTest
@testable import Search
@testable import Models

class SearchPresenterTests: XCTestCase {
    
    var spyInteractor: SpySearchInteractor!
    let mockInteractor = MockSearchInteractor()
    var spyView: SpySearchView!
    let mockRouter = MockSearchRouter()
    /// SUT.
    var presenter: SearchPresenter!
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
        presenter = nil
        spyInteractor = nil
        spyView = nil
    }
    
    func testFetchSearchRequestsHistory() throws {
        spyInteractor = SpySearchInteractor()
        let expectation = expectation(description: "testFetchSearchRequestsHistory")
        spyInteractor.expectation = expectation
        presenter = SearchPresenter(router: mockRouter, interactor: spyInteractor)
        
        presenter.fetchSearchRequestsHistory()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(spyInteractor.didProvideSearchRequestsHistory)
    }
    
    func testClearSearchRequestsHistory() throws {
        spyInteractor = SpySearchInteractor()
        presenter = SearchPresenter(router: mockRouter, interactor: spyInteractor)
        
        presenter.clearSearchRequestsHistory()
        
        XCTAssertTrue(spyInteractor.didClearSearchRequestsHistory)
    }
    
    func testDefineWhetherFilteringIsOn() throws {
        spyInteractor = SpySearchInteractor()
        presenter = SearchPresenter(router: mockRouter, interactor: spyInteractor)
        
        presenter.defineWhetherFilteringIsOn()
        
        XCTAssertTrue(spyInteractor.isFilteringOnFlagChecked)
    }
    
    func testCategoryDidTappedMethod() throws {
        spyInteractor = SpySearchInteractor()
        let expectation = expectation(description: "testCategoryDidTappedMethod")
        spyInteractor.expectation = expectation
        presenter = SearchPresenter(router: mockRouter, interactor: spyInteractor)
        let cuisine = Cuisine.italian
        
        presenter.categoryDidTapped(cuisine)
        
        wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(spyInteractor.categoryRequestRandomDataWith, cuisine)
    }
    
    func testRequestDataByKeywordMethod() throws {
        spyInteractor = SpySearchInteractor()
        let expectation = expectation(description: "testFetchingSearchRequestsHistory")
        spyInteractor.expectation = expectation
        presenter = SearchPresenter(router: mockRouter, interactor: spyInteractor)
        let keyword = "Chicken"
        
        presenter.requestData(by: keyword)
        
        wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(spyInteractor.keywordRequestDataWith, keyword)
    }
    
    func testProvideEmptyFiltersMethod() throws {
        spyInteractor = SpySearchInteractor()
        presenter = SearchPresenter(router: mockRouter, interactor: spyInteractor)
        let data = [[FilterProtocol]]()
        
        presenter.provideSelectedFilters(data: data)
        
        XCTAssertTrue(spyInteractor.selectedFilters.isEmpty)
    }
    
    func testProvideSelectedFiltersMethod() throws {
        spyInteractor = SpySearchInteractor()
        presenter = SearchPresenter(router: mockRouter, interactor: spyInteractor)
        let data: [[FilterProtocol]] = [[Cuisine.american], [Diet.balanced], []]
        
        presenter.provideSelectedFilters(data: data)
        
        XCTAssertNotNil(spyInteractor.selectedFilters)
    }
    
    func test_didProvideSearchRequestsHistory_withEmptyHistory() throws {
        presenter = SearchPresenter(router: mockRouter, interactor: mockInteractor)
        spyView = SpySearchView()
        presenter.view = spyView
        let expectation = expectation(description: "testProvidingRecipes")
        spyView.expectation = expectation
        let emptyHistory = [String]()
        
        presenter.didProvideSearchRequestsHistory(emptyHistory)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(spyView.filledInSearchRequestsHistory)
        XCTAssertEqual(spyView.filledInSearchRequestsHistory, [String]())
    }
    
    func test_didProvideSearchRequestsHistory_withSomeHistory() throws {
        presenter = SearchPresenter(router: mockRouter, interactor: mockInteractor)
        spyView = SpySearchView()
        presenter.view = spyView
        let expectation = expectation(description: "testProvidingRecipes")
        spyView.expectation = expectation
        let someHistory = ["Test 1", "Test 2"]
        
        presenter.didProvideSearchRequestsHistory(someHistory)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(spyView.filledInSearchRequestsHistory)
        XCTAssertEqual(spyView.filledInSearchRequestsHistory, someHistory)
    }
    
    func testDidClearSearchRequestsHistory() throws {
        presenter = SearchPresenter(router: mockRouter, interactor: mockInteractor)
        spyView = SpySearchView()
        presenter.view = spyView
        let expectation = expectation(description: "testProvidingRecipes")
        spyView.expectation = expectation
        
        presenter.didClearSearchRequestsHistory()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(spyView.didClearSearchRequestsHistoryFlag)
    }
    
    func testDidProvideIsFilteringOnTrue() throws {
        presenter = SearchPresenter(router: mockRouter, interactor: mockInteractor)
        spyView = SpySearchView()
        presenter.view = spyView
        let result = true
        
        presenter.didProvideIsFilteringOn(result)
        
        XCTAssertEqual(spyView.changeFilterIconFlag, result)
    }
    
    func testDidProvideIsFilteringOnFalse() throws {
        presenter = SearchPresenter(router: mockRouter, interactor: mockInteractor)
        spyView = SpySearchView()
        presenter.view = spyView
        let result = false
        
        presenter.didProvideIsFilteringOn(result)
        
        XCTAssertEqual(spyView.changeFilterIconFlag, result)
    }
}
