//
//  SearchProtocols.swift
//  Search
//
//  Created by Егор Бадмаев on 27.10.2022.
//  

import Common

public protocol SearchModuleInput: BaseRecipesModuleInput {
}

public protocol SearchModuleOutput: BaseRecipesModuleOutput {
}

protocol SearchViewInput: BaseRecipesViewInput {
    func fillInSearchRequestsHistory(_ searchRequestsHistory: [String])
}

protocol SearchViewOutput: BaseRecipesViewOutput {
    func fetchSearchRequestsHistory()
}

protocol SearchInteractorInput: BaseRecipesInteractorInput {
    func provideSearchRequestsHistory()
}

protocol SearchInteractorOutput: BaseRecipesInteractorOutput {
    func didProvidedSearchRequestsHistory(_ searchRequestsHistory: [String])
}

protocol SearchRouterInput: BaseRecipesRouterInput {
}

protocol SearchRouterOutput: BaseRecipesModuleOutput {
}
