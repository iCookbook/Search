//
//  SearchAssembly.swift
//  Search
//
//  Created by Егор Бадмаев on 27.10.2022.
//  

import UIKit
import Networking

public final class SearchAssembly {
    
    // MARK: - Public Properties
    
    public let input: SearchModuleInput
    public let viewController: UIViewController
    
    // MARK: - Private Properties
    
    private(set) weak var router: SearchRouterInput!
    
    // MARK: - Public Methods
    
    public static func assemble(with context: SearchContext) -> SearchAssembly {
        let router = SearchRouter()
        let interactor = SearchInteractor(networkManager: context.moduleDependency)
        let presenter = SearchPresenter(router: router, interactor: interactor)
        let viewController = SearchViewController(output: presenter)
        
        presenter.view = viewController
        presenter.moduleOutput = context.moduleOutput
        
        interactor.output = presenter
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

public struct SearchContext {
    weak var moduleOutput: SearchModuleOutput?
    let moduleDependency: NetworkManagerProtocol
    
    public init(moduleOutput: SearchModuleOutput? = nil, moduleDependency: NetworkManagerProtocol) {
        self.moduleOutput = moduleOutput
        self.moduleDependency = moduleDependency
    }
}
