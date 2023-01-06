//
//  SearchAssemblyTests.swift
//  Search-Unit-Tests
//
//  Created by Егор Бадмаев on 05.01.2023.
//

import XCTest
@testable import Search

class SearchAssemblyTests: XCTestCase {
    
    let mockNetworkManager = MockNetworkManager()
    /// SUT.
    var assembly: SearchAssembly!
    var context: SearchContext!
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    /**
     In the next tests we will check that the module consists of the correct parts and all dependencies are filled in.
     The tests will differ by creating different contexts
     */
    
    func testAssemblingWithModuleOutput() throws {
        let moduleOutput = MockSearchPresenter()
        context = SearchContext(moduleOutput: moduleOutput, moduleDependency: mockNetworkManager)
        assembly = SearchAssembly.assemble(with: context)
        
        XCTAssertNotNil(assembly.input)
        XCTAssertNotNil(assembly.router, "Module router should not be nil")
        XCTAssertNotNil(assembly.viewController)
        
        guard let _ = assembly.viewController as? SearchViewController,
              let presenter = assembly.input as? SearchPresenter,
              let _ = assembly.router as? SearchRouter
        else {
            XCTFail("Module was assebled with wrong components")
            return
        }
        XCTAssertIdentical(moduleOutput, presenter.moduleOutput, "All injected dependencies should be identical")
        /// Unfortunately, it is impossible to access Core Data manager, that is why it is impossible to test its' injecting. DI was tested in `Cookbook/ServiceLocatorTests.swift`.
    }
    
    func testAssemblingWithoutModuleOutput() throws {
        context = SearchContext(moduleOutput: nil, moduleDependency: mockNetworkManager)
        assembly = SearchAssembly.assemble(with: context)
        
        XCTAssertNotNil(assembly.input)
        XCTAssertNotNil(assembly.router)
        XCTAssertNotNil(assembly.viewController)
        
        guard let _ = assembly.viewController as? SearchViewController,
              let presenter = assembly.input as? SearchPresenter,
              let _ = assembly.router as? SearchRouter
        else {
            XCTFail("Module was assebled with wrong components")
            return
        }
        XCTAssertNil(presenter.moduleOutput, "Module output was not provided and should be nil")
    }
}
