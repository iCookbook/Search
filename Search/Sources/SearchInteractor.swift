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
    
    /// Provides search requests history from UserDefaults.
    func provideSearchRequestsHistory() {
        guard let presenter = presenter as? SearchInteractorOutput else { return }
        presenter.didProvidedSearchRequestsHistory(UserDefaults.searchRequestsHistory)
    }
    
    /// Clears search requests history in UserDefaults.
    func clearSearchRequestsHistory() {
        UserDefaults.searchRequestsHistory = []
        guard let presenter = presenter as? SearchInteractorOutput else { return }
        presenter.didClearedSearchRequestsHistory()
    }
    
    /// Provides `Response` from the server with random recipes by a specific category.
    ///
    /// - Parameter category: category to request data by.
    func requestRandomData(by category: Cuisine) {
        let endpoint = Endpoint.random(by: category)
        let request = NetworkRequest(endpoint: endpoint)
        
        networkManager.perform(request: request) { [unowned self] (result: Result<Response, NetworkManagerError>) in
            switch result {
            case .success(let response):
                setImageData(for: response, withOverridingCurrentData: true)
            case .failure(let error):
                presenter?.handleError(error)
            }
        }
    }
    
    /// Provides `Response` from the server by a specific key.
    ///
    /// - Parameter keyword: keyword user typed in search bar.
    func requestData(by keyword: String) {
        /// Adds new keyword to the search history only if it is not in the array already.
        if !UserDefaults.searchRequestsHistory.contains(keyword) {
            UserDefaults.searchRequestsHistory.append(keyword)
        }
        
        guard let presenter = presenter as? SearchInteractorOutput else { return }
        presenter.didProvidedSearchRequestsHistory(UserDefaults.searchRequestsHistory)
        
        let endpoint = Endpoint.create(by: keyword)
        let request = NetworkRequest(endpoint: endpoint)
        
        networkManager.perform(request: request) { [unowned self] (result: Result<Response, NetworkManagerError>) in
            switch result {
            case .success(let response):
                setImageData(for: response, withOverridingCurrentData: true)
            case .failure(let error):
                presenter.handleError(error)
            }
        }
    }
    
    func isFilteringOn() {
        let result = !UserDefaults.dietsFilters.isEmpty ||
                     !UserDefaults.mealsFilters.isEmpty ||
                     !UserDefaults.dishesFilters.isEmpty ||
                     !UserDefaults.cuisinesFilters.isEmpty
        
        guard let presenter = presenter as? SearchInteractorOutput else { return }
        presenter.didProvidedIsFilteringOn(result)
    }
}
