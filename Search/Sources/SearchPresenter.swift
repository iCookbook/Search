//
//  SearchPresenter.swift
//  Search
//
//  Created by Егор Бадмаев on 27.10.2022.
//

import Common
import Models

final class SearchPresenter: BaseRecipesPresenter {
}

extension SearchPresenter: SearchModuleInput {
}

extension SearchPresenter: SearchViewOutput {
    
    func fetchSearchRequestsHistory() {
        guard let interactor = interactor as? SearchInteractorInput else { return }
        
        DispatchQueue.global(qos: .utility).async {
            interactor.provideSearchRequestsHistory()
        }
    }
    
    func clearSearchRequestsHistory() {
        guard let interactor = interactor as? SearchInteractorInput else { return }
        interactor.clearSearchRequestsHistory()
    }
    
    func defineWhetherFilteringIsOn() {
        guard let interactor = interactor as? SearchInteractorInput else { return }
        interactor.isFilteringOn()
    }
    
    /// Handles tapping on a category in `categoriesTableView`.
    ///
    /// - Parameter category: the `Сategory` that the user has selected.
    func categoryDidTapped(_ category: Cuisine) {
        guard let interactor = interactor as? SearchInteractorInput else { return }
        
        DispatchQueue.global(qos: .userInteractive).async {
            interactor.requestRandomData(by: category)
        }
    }
    
    func requestData(by keyword: String) {
        guard let interactor = interactor as? SearchInteractorInput else { return }
        
        DispatchQueue.global(qos: .userInteractive).async {
            interactor.requestData(by: keyword)
        }
    }
}

extension SearchPresenter: SearchInteractorOutput {
    
    func didProvidedSearchRequestsHistory(_ searchRequestsHistory: [String]) {
        guard let view = view as? SearchViewInput else { return }
        view.fillInSearchRequestsHistory(searchRequestsHistory)
    }
    
    func didClearedSearchRequestsHistory() {
        guard let view = view as? SearchViewInput else { return }
        view.didClearedSearchRequestsHistory()
    }
    
    func didProvidedIsFilteringOn(_ result: Bool) {
        guard let view = view as? SearchViewInput else { return }
//        view.didClearedSearchRequestsHistory()
    }
}
