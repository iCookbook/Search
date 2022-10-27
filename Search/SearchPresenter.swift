//
//  SearchPresenter.swift
//  Search
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import Foundation

final class SearchPresenter {
    weak var view: SearchViewInput?
    weak var moduleOutput: SearchModuleOutput?
    
    // MARK: - Private Properties
    
    private let router: SearchRouterInput
    private let interactor: SearchInteractorInput
    
    // MARK: - Init
    
    init(router: SearchRouterInput, interactor: SearchInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension SearchPresenter: SearchModuleInput {
}

extension SearchPresenter: SearchViewOutput {
}

extension SearchPresenter: SearchInteractorOutput {
}
