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
    
    /// Asks interactor to fetch search requests history.
    func fetchSearchRequestsHistory() {
        guard let interactor = interactor as? SearchInteractorInput else { return }
        
        DispatchQueue.global(qos: .utility).async {
            interactor.provideSearchRequestsHistory()
        }
    }
    
    /// Asks interactor to clear search requests history.
    func clearSearchRequestsHistory() {
        guard let interactor = interactor as? SearchInteractorInput else { return }
        interactor.clearSearchRequestsHistory()
    }
    
    /// Finds out from interactor whether filtering is on or off.
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
    
    /// Requests data from the interactor by the transmitted keyword.
    ///
    /// - Parameter keyword: Keyword to request data with.
    func requestData(by keyword: String) {
        guard let interactor = interactor as? SearchInteractorInput else { return }
        
        DispatchQueue.global(qos: .userInteractive).async {
            interactor.requestData(by: keyword)
        }
    }
    
    /// Provides user's selected filters from view to interactor to save them.
    ///
    /// - Parameter data: Selected filters.
    func provideSelectedFilters(data: [[FilterProtocol]]) {
        guard let interactor = interactor as? SearchInteractorInput else { return }
        interactor.turnOnSelectedFilters(data: data)
    }
}

extension SearchPresenter: SearchInteractorOutput {
    
    /// Provides search requests history from interactor to view.
    ///
    /// - Parameter searchRequestsHistory: Search requests history as an array of strings.
    func didProvideSearchRequestsHistory(_ searchRequestsHistory: [String]) {
        guard let view = view as? SearchViewInput else { return }
        
        DispatchQueue.main.async {
            view.fillInSearchRequestsHistory(searchRequestsHistory)
        }
    }
    
    /// Tells view that search requests history was cleared.
    func didClearSearchRequestsHistory() {
        guard let view = view as? SearchViewInput else { return }
        
        DispatchQueue.main.async {
            view.didClearSearchRequestsHistory()
        }
    }
    
    /// Makes it clear to view whether filtering is on or off.
    ///
    /// - Parameter result: Defines filtering on or off.
    func didProvideIsFilteringOn(_ result: Bool) {
        guard let view = view as? SearchViewInput else { return }
        view.changeFilterIcon(by: result)
    }
}
