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
    
    func categoryDidTapped(_ category: Cuisine)
    func requestData(by keyword: String)
}

protocol SearchInteractorInput: BaseRecipesInteractorInput {
    func provideSearchRequestsHistory()
    func clearSearchRequestsHistory()
    
    func requestRandomData(by category: Cuisine)
    func requestData(by keyword: String)
}

protocol SearchInteractorOutput: BaseRecipesInteractorOutput {
    func didProvidedSearchRequestsHistory(_ searchRequestsHistory: [String])
    func didClearedSearchRequestsHistory()
}

protocol SearchRouterInput: BaseRecipesRouterInput {
}

protocol SearchRouterOutput: BaseRecipesModuleOutput {
}
