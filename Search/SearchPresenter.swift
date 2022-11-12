//
//  SearchPresenter.swift
//  Search
//
//  Created by Егор Бадмаев on 27.10.2022.
//

import Common

final class SearchPresenter: BaseRecipesPresenter {
    
    // MARK: - Init
    
    init(router: SearchRouterInput, interactor: SearchInteractorInput) {
        super.init(router: router, interactor: interactor)
    }
}

extension SearchPresenter: SearchModuleInput {
}

extension SearchPresenter: SearchViewOutput {
}

extension SearchPresenter: SearchInteractorOutput {
}
