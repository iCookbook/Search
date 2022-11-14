//
//  SearchInteractor.swift
//  Search
//
//  Created by Егор Бадмаев on 27.10.2022.
//  

import Common
import Networking
import Persistence

final class SearchInteractor: BaseRecipesInteractor {
}

extension SearchInteractor: SearchInteractorInput {
    func provideSearchRequestsHistory() {
        guard let presenter = presenter as? SearchInteractorOutput else { return }
        presenter.didProvidedSearchRequestsHistory(UserDefaults.searchRequestsHistory)
    }
}
