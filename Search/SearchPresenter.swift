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
        
        DispatchQueue.global(qos: .userInteractive).async {
            interactor.provideSearchRequestsHistory()
        }
    }
    
    func categoryDidTapped(_ category: Cuisine) {
        guard let interactor = interactor as? SearchInteractorInput else { return }
        
        DispatchQueue.global(qos: .userInteractive).async {
            interactor.requestRandomData(by: category)
        }
    }
    
    func searchBarButtonClicked(with text: String) {
        guard let interactor = interactor as? SearchInteractorInput else { return }
        
        DispatchQueue.global(qos: .userInteractive).async {
            interactor.requestData(by: text)
        }
    }
}

extension SearchPresenter: SearchInteractorOutput {
    func didProvidedSearchRequestsHistory(_ searchRequestsHistory: [String]) {
        guard let view = view as? SearchViewInput else { return }
        view.fillInSearchRequestsHistory(searchRequestsHistory)
    }
}
