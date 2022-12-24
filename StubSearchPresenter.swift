//
//  StubSearchPresenter.swift
//  Search-Unit-Tests
//
//  Created by Егор Бадмаев on 24.12.2022.
//

@testable import Search
@testable import Networking
@testable import Models

class StubSearchPresenter: SearchInteractorOutput {
    
    var handledError: NetworkManagerError!
    var didProvidedSearchRequestsHistoryBool: Bool!
    var didClearedSearchRequestsHistoryBool: Bool!
    var providedResponse: Response!
    var withOverridingCurrentDataBool: Bool!
    
    func didProvidedSearchRequestsHistory(_ searchRequestsHistory: [String]) {
        didProvidedSearchRequestsHistoryBool = true
    }
    
    func didClearedSearchRequestsHistory() {
        didClearedSearchRequestsHistoryBool = true
    }
    
    func didProvidedResponse(_ response: Response, withOverridingCurrentData: Bool) {
        providedResponse = response
        withOverridingCurrentDataBool = withOverridingCurrentData
    }
    
    func handleError(_ error: NetworkManagerError) {
        handledError = error
    }
}
