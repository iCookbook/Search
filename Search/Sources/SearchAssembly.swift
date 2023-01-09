//
//  SearchAssembly.swift
//  Search
//
//  Created by Егор Бадмаев on 27.10.2022.
//  

import UIKit
import Common

public final class SearchAssembly {
    
    // MARK: - Public Properties
    
    public let input: SearchModuleInput
    public let viewController: UIViewController
    
    // MARK: - Private Properties
    
    private(set) weak var router: SearchRouterInput!
    
    // MARK: - Public Methods
    
    public static func assemble(with context: BaseRecipesDependenciesProtocol) -> SearchAssembly {
        let router = SearchRouter()
        let interactor = SearchInteractor(networkManager: context.networkManager)
        let presenter = SearchPresenter(router: router, interactor: interactor)
        let viewController = SearchViewController(presenter: presenter)
        
        presenter.view = viewController
        presenter.moduleOutput = context.moduleOutput
        
        interactor.presenter = presenter
        router.viewController = viewController
        
        return SearchAssembly(view: viewController, input: presenter, router: router)
    }
    
    // MARK: - Init
    
    private init(view: UIViewController, input: SearchModuleInput, router: SearchRouterInput) {
        self.viewController = view
        self.input = input
        self.router = router
    }
}
