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
        if !UserDefaults.cuisinesFilters.contains(category) {
            UserDefaults.cuisinesFilters.append(category)
        }
        
        let endpoint = Endpoint.random(by: category.rawValue)
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
        
        let endpoint = Endpoint.create(by: keyword,
                                       meals: convertMealFilters(from: UserDefaults.mealsFilters),
                                       diets: convertDietFilters(from: UserDefaults.dietsFilters),
                                       cuisines: convertCuisineFilters(from: UserDefaults.cuisinesFilters),
                                       dishes: convertDishFilters(from: UserDefaults.dishesFilters))
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
    
    func turnOnSelectedFilters(data: [[FilterProtocol]]) {
        UserDefaults.dietsFilters = data[Filters.diet.rawValue] as? [Diet] ?? []
        UserDefaults.cuisinesFilters = data[Filters.cuisine.rawValue] as? [Cuisine] ?? []
        UserDefaults.dishesFilters = data[Filters.dish.rawValue] as? [Dish] ?? []
        UserDefaults.mealsFilters = data[Filters.meal.rawValue] as? [Meal] ?? []
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

// MARK: - Helper methods

extension SearchInteractor {
    func convertCuisineFilters(from data: [Cuisine]) -> [(String, String)] {
        data.map { ("cuisineType", $0.rawValue) }
    }
    
    func convertDietFilters(from data: [Diet]) -> [(String, String)] {
        data.map { ("diet", $0.rawValue.lowercased()) }
    }
    
    func convertDishFilters(from data: [Dish]) -> [(String, String)] {
        data.map { ("dishType", $0.rawValue) }
    }
    
    func convertMealFilters(from data: [Meal]) -> [(String, String)] {
        data.map { ("mealType", $0.rawValue) }
    }
}
