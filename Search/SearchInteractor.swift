//
//  SearchInteractor.swift
//  Search
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import Foundation

final class SearchInteractor {
    weak var output: SearchInteractorOutput?
}

extension SearchInteractor: SearchInteractorInput {
}
