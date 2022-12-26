//
//  SearchProtocols.swift
//  Search
//
//  Created by Егор Бадмаев on 27.10.2022.
//  

import Common
import Models

public protocol SearchModuleInput: BaseRecipesModuleInput {
}

public protocol SearchModuleOutput: BaseRecipesModuleOutput {
}

protocol SearchViewInput: BaseRecipesViewInput {
    func fillInSearchRequestsHistory(_ searchRequestsHistory: [String])
    func didClearedSearchRequestsHistory()
}

protocol SearchViewOutput: BaseRecipesViewOutput {
    func fetchSearchRequestsHistory()
    func clearSearchRequestsHistory()
    func defineWhetherFilteringIsOn()
    
    func categoryDidTapped(_ category: Cuisine)
    func requestData(by keyword: String)
}

protocol SearchInteractorInput: BaseRecipesInteractorInput {
    func provideSearchRequestsHistory()
    func clearSearchRequestsHistory()
    func isFilteringOn()
    
    func requestRandomData(by category: Cuisine)
    func requestData(by keyword: String)
}

protocol SearchInteractorOutput: BaseRecipesInteractorOutput {
    func didProvidedSearchRequestsHistory(_ searchRequestsHistory: [String])
    func didClearedSearchRequestsHistory()
    func didProvidedIsFilteringOn(_ result: Bool)
}

protocol SearchRouterInput: BaseRecipesRouterInput {
}

protocol SearchRouterOutput: BaseRecipesModuleOutput {
}
