//
//  SearchInteractor.swift
//  Search
//
//  Created by Егор Бадмаев on 27.10.2022.
//  

import Networking
import Common

final class SearchInteractor: BaseRecipesInteractor {
    weak var output: SearchInteractorOutput?
}

extension SearchInteractor: SearchInteractorInput {
}
