//
//  SearchInteractor.swift
//  Search
//
//  Created by Егор Бадмаев on 27.10.2022.
//  

import Common
import Networking
import Persistence
import Models

final class SearchInteractor: BaseRecipesInteractor {
}

extension SearchInteractor: SearchInteractorInput {
    
    func provideSearchRequestsHistory() {
        guard let presenter = presenter as? SearchInteractorOutput else { return }
        presenter.didProvidedSearchRequestsHistory(UserDefaults.searchRequestsHistory)
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
