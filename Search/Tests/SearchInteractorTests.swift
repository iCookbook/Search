//
//  SearchInteractorTests.swift
//  SearchTests
//
//  Created by Егор Бадмаев on 24.12.2022.
//

import Foundation
import XCTest
@testable import Search
@testable import Common

class SearchInteractorTests: XCTestCase {
    
    var presenter: StubSearchPresenter!
    /// SUT.
    var interactor: SearchInteractor!
    
    private let networkManager = MockNetworkManager()
    
    override func setUpWithError() throws {
        interactor = SearchInteractor(networkManager: networkManager)
        presenter = StubSearchPresenter(interactor: interactor)
        interactor.presenter = presenter
    }
    
    override func tearDownWithError() throws {
        interactor = nil
        presenter = nil
    }
    
    func testProvideSearchRequestsHistoryMethods() throws {
        interactor.provideSearchRequestsHistory()
        
        XCTAssertNotNil(presenter.didProvidedSearchRequestsHistoryBool, "Search requests history flag should not be `nil`")
        XCTAssertTrue(presenter.didProvidedSearchRequestsHistoryBool, "Search requests history flag should not be `false`")
    }
    
    func testClearSearchRequestsHistory() throws {
        interactor.clearSearchRequestsHistory()
        
        XCTAssertNotNil(presenter.didClearedSearchRequestsHistoryBool, "Search requests history flag should not be `nil`")
        XCTAssertTrue(presenter.didClearedSearchRequestsHistoryBool, "Search requests history flag should not be `false`")
        XCTAssertEqual(UserDefaults.searchRequestsHistory, [String]())
    }
    
    func testRequestRandomDataByCuisine() throws {
        interactor.requestRandomData(by: .american)
        
        XCTAssertNotNil(presenter.providedResponse, "Provided response should not be `nil`")
        XCTAssertNotNil(presenter.withOverridingCurrentDataBool)
        XCTAssertFalse(presenter.withOverridingCurrentDataBool)
    }
    
    func testRequestRandomDataByKeyword() throws {
        interactor.requestData(by: "some keyword")
        
        XCTAssertNotNil(presenter.providedResponse, "Provided response should not be `nil`")
        XCTAssertNotNil(presenter.withOverridingCurrentDataBool)
        XCTAssertTrue(presenter.withOverridingCurrentDataBool)
    }
}
