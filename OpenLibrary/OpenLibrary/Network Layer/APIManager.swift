//
//  APIManager.swift
//  OpenLibrary
//
//  Created by vaibhav singh on 16/12/22.
//

import Foundation

/// A protocol used to fetch data from a generic endpoint , we can easily mock this to fetch data from a local file for unit testing networking calls!
protocol APIManagerProtocol {
    func getData(fromEndpoint networkEndpoint: NetworkEndpointProtocol, completion: @escaping (Result<Data, NetworkError>) -> ())
}

/// A concrete APIManager class capable of calling any generic network endpoint
final class APIManager: APIManagerProtocol {
    
    let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func getData(fromEndpoint networkEndpoint: NetworkEndpointProtocol,  completion: @escaping (Result<Data, NetworkError>) -> ()) {
        guard let request = networkEndpoint.getNetworkRequest() else {
            completion(.failure(.badRequest))
            return
        }
        
        performRequest(urlRequest: request, completion: completion)
    }
    
    private func performRequest(urlRequest: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> ()) {
        urlSession.dataTask(with: urlRequest) { data, response, error in
            /// Check for client side error
            if let _ = error {
                completion(.failure(.networkError))
            } else if let httpResponse = response as? HTTPURLResponse {
                /// If response code is in the success range try to unwrap the data object
                if  200..<300 ~= httpResponse.statusCode, let apiData = data {
                    completion(.success(apiData))
                } else {
                    /// Else throw a generic badResponse error to the user
                    completion(.failure(.badResponse))
                }
                
            }
        }.resume()
    }
    
}
