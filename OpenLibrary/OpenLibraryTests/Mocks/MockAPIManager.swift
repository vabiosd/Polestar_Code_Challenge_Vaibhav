//
//  APIManager Mock.swift
//  OpenLibraryTests
//
//  Created by vaibhav singh on 20/12/22.
//

import Foundation
@testable import OpenLibrary

/// A MockAPIManager that reads data from a local file to write unit tests around networking
final class MockAPIManager: APIManagerProtocol {
    
    func getData(fromEndpoint networkEndpoint: NetworkEndpointProtocol, completion: @escaping (Result<Data, NetworkError>) -> ()) {
        //// Try to fetch data from a local file
        if let data = try? Data(contentsOf: URL(fileURLWithPath: networkEndpoint.path)) {
            completion(.success(data))
        } else {
            /// Throw a generic bad response error if unable to fetch data from a local file
            completion(.failure(.badResponse))
        }
    }
}
