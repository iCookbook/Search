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
    func didClearSearchRequestsHistory()
    func changeFilterIcon(by flag: Bool)
}

protocol SearchViewOutput: BaseRecipesViewOutput {
    func fetchSearchRequestsHistory()
    func clearSearchRequestsHistory()
    func defineWhetherFilteringIsOn()
    
    func categoryDidTapped(_ category: Cuisine)
    func requestData(by keyword: String)
    func provideSelectedFilters(data: [[FilterProtocol]])
}

protocol SearchInteractorInput: BaseRecipesInteractorInput {
    func provideSearchRequestsHistory()
    func clearSearchRequestsHistory()
    func isFilteringOn()
    
    func requestRandomData(by category: Cuisine)
    func requestData(by keyword: String)
    func turnOnSelectedFilters(data: [[FilterProtocol]])
}

protocol SearchInteractorOutput: BaseRecipesInteractorOutput {
    func didProvideSearchRequestsHistory(_ searchRequestsHistory: [String])
    func didClearSearchRequestsHistory()
    func didProvideIsFilteringOn(_ result: Bool)
}

protocol SearchRouterInput: BaseRecipesRouterInput {
}

protocol SearchRouterOutput: BaseRecipesModuleOutput {
}
