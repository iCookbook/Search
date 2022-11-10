//
//  SearchRouter.swift
//  Search
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import UIKit
import Models
import RecipeDetails

final class SearchRouter {
    weak var output: SearchRouterOutput?
    weak var viewController: UIViewController?
}

extension SearchRouter: SearchRouterInput {
    /// Opens details module for provided recipe
    /// - Parameter recipe: ``Recipe`` instance open details with.
    func openRecipeDetailsModule(for recipe: Recipe) {
        let context = RecipeDetailsContext(moduleOutput: self, recipe: recipe)
        let assembly = RecipeDetailsAssembly.assemble(with: context)
        // hides tab bar
        assembly.viewController.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(assembly.viewController, animated: true)
    }
}

extension SearchRouter: RecipeDetailsModuleOutput {
}
