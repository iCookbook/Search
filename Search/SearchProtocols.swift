//
//  SearchProtocols.swift
//  Search
//
//  Created by Егор Бадмаев on 27.10.2022.
//  
//

import Foundation

public protocol SearchModuleInput {
    var moduleOutput: SearchModuleOutput? { get }
}

public protocol SearchModuleOutput: AnyObject {
}

protocol SearchViewInput: AnyObject {
}

protocol SearchViewOutput: AnyObject {
}

protocol SearchInteractorInput: AnyObject {
}

protocol SearchInteractorOutput: AnyObject {
}

protocol SearchRouterInput: AnyObject {
}

protocol SearchRouterOutput: AnyObject {
}
