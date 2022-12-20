//
//  NetworkManager.swift
//  OpenLibrary
//
//  Created by vaibhav singh on 16/12/22.
//

import Foundation

/// A concrete class used to fetch data from a generic endpoint and decode it into a generic data model
final class RequestManager {
    
    private let apiManager: APIManagerProtocol
    private let jsonDecoder: JSONDecoder
    
    init(apiManager: APIManagerProtocol, jsonDecoder: JSONDecoder) {
        self.apiManager = apiManager
        self.jsonDecoder = jsonDecoder
    }
    
    func getDataModel<T>(endpoint: NetworkEndpointProtocol, completion: @escaping (Result<T, NetworkError>) -> ()) where T : Decodable {
        
        /// Using APIManager to fetch data
        apiManager.getData(fromEndpoint: endpoint) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
                /// If successful, decode data into models
            case .success(let data):
                do {
                    let model = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(model))
                } catch {
                    completion(.failure(.badResponse))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
