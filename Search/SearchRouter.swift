//
//  SearchRouter.swift
//  Search
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import UIKit

final class SearchRouter {
    weak var output: SearchRouterOutput?
    weak var viewController: UIViewController?
}

extension SearchRouter: SearchRouterInput {
}
