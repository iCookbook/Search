//
//  SearchInteractor.swift
//  Search
//
//  Created by Егор Бадмаев on 27.10.2022.
//  

import Common
import Networking
import Models

final class SearchInteractor: BaseRecipesInteractor {
}

extension SearchInteractor: SearchInteractorInput {
    
    func provideSearchRequestsHistory() {
        guard let presenter = presenter as? SearchInteractorOutput else { return }
        presenter.didProvidedSearchRequestsHistory(UserDefaults.searchRequestsHistory)
    }
    
    func clearSearchRequestsHistory() {
        UserDefaults.searchRequestsHistory = []
        guard let presenter = presenter as? SearchInteractorOutput else { return }
        presenter.didClearedSearchRequestsHistory()
    }
    
    func requestRandomData(by category: Cuisine) {
        let endpoint = Endpoint.random(by: category)
        let request = NetworkRequest(endpoint: endpoint)
        networkManager.getResponse(request: request) { [unowned self] (result) in
            switch result {
            case .success(let response):
                presenter?.didProvidedResponse(response, withOverridingCurrentData: true)
            case .failure(let error):
                presenter?.handleError(error)
            }
        }
    }
    
    func requestData(by keyword: String) {
        /// Adds new keyword to the search history only if it is not in the array already.
        if !UserDefaults.searchRequestsHistory.contains(keyword) {
            UserDefaults.searchRequestsHistory.append(keyword)
        }
        
        let endpoint = Endpoint.create(by: keyword)
        let request = NetworkRequest(endpoint: endpoint)
        networkManager.getResponse(request: request) { [unowned self] (result) in
            switch result {
            case .success(let response):
                presenter?.didProvidedResponse(response, withOverridingCurrentData: true)
            case .failure(let error):
                presenter?.handleError(error)
            }
        }
    }
}
