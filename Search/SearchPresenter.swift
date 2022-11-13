//
//  SearchPresenter.swift
//  Search
//
//  Created by Егор Бадмаев on 27.10.2022.
//

import Common

final class SearchPresenter: BaseRecipesPresenter {
}

extension SearchPresenter: SearchModuleInput {
}

extension SearchPresenter: SearchViewOutput {
    func fetchSearchRequestsHistory() {
        guard let interactor = interactor as? SearchInteractorInput else { return }
        interactor.provideSearchRequestsHistory()
    }
}

extension SearchPresenter: SearchInteractorOutput {
    func didProvidedSearchRequestsHistory(_ searchRequestsHistory: [String]) {
        guard let view = view as? SearchViewInput else { return }
        view.fillInSearchRequestsHistory(searchRequestsHistory)
    }
}
