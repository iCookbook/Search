//
//  SpySearchPresenter.swift
//  Search-Unit-Tests
//
//  Created by Егор Бадмаев on 24.12.2022.
//

@testable import Search
@testable import Networking
@testable import Models

class SpySearchPresenter: SearchInteractorOutput {
    
    var handledError: NetworkManagerError!
    var didProvidedSearchRequestsHistoryBool: Bool!
    var didClearedSearchRequestsHistoryBool: Bool!
    var providedResponse: Response!
    var withOverridingCurrentDataBool: Bool!
    var didProvidedIsFilteringOnBool: Bool!
    
    private let interactor: SearchInteractor!
    
    init(interactor: SearchInteractor) {
        self.interactor = interactor
    }
    
    func didProvideSearchRequestsHistory(_ searchRequestsHistory: [String]) {
        didProvidedSearchRequestsHistoryBool = true
    }
    
    func didClearSearchRequestsHistory() {
        didClearedSearchRequestsHistoryBool = true
    }
    
    func didProvideResponse(_ response: Response, withOverridingCurrentData: Bool) {
        providedResponse = response
        withOverridingCurrentDataBool = withOverridingCurrentData
    }
    
    func handleError(_ error: NetworkManagerError) {
        handledError = error
    }
    
    func didProvideIsFilteringOn(_ result: Bool) {
        didProvidedIsFilteringOnBool = result
    }
}
