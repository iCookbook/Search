//
//  MockNetworkManager.swift
//  Search-Unit-Tests
//
//  Created by Егор Бадмаев on 24.12.2022.
//

import Networking
import Models

class MockNetworkManager: NetworkManagerProtocol {
    func perform<Model>(request: NetworkRequest, completion: @escaping (Result<Model, NetworkManagerError>) -> Void) where Model : Decodable, Model : Encodable {
        let result = Response(from: nil, to: nil, count: nil, links: nil, hits: nil)
        completion(.success(result as! Model))
    }
    
    func obtainData(request: NetworkRequest, completion: @escaping (Result<Data, NetworkManagerError>) -> Void) {
        let data = Data([1, 2, 3])
        completion(.success(data))
    }
}
