//
//  NetworkEndpointProtocol.swift
//  OpenLibrary
//
//  Created by vaibhav singh on 16/12/22.
//

import Foundation

/// An enum describing different request types
enum RequestType: String {
    case get = "GET"
}

/// A generic network endpoint protocol that can be used to build network requests to any possible endpoint!

protocol NetworkEndpointProtocol {
    /// Path to the API endpoint
    var path: String { get }
    
    /// Headers required by the request
    var headers: [String: String] { get}
    
    /// URL Params of the endpoint
    var urlParams: [String :String?] { get }
    
    /// Body params of the request
    var bodyParams: [String: Any] { get }
    
    /// Type of request, possible values are GET, POST, PUT etc
    var requestType: RequestType { get }
    
}

extension NetworkEndpointProtocol {
    
    /// Adding default values to the above property requirements
    /// We will just need to define the properties the URL request needs, we can skip the rest!
    
    var host: String {
        return "openlibrary.org"
    }
    
    var headers: [String: String] {
        return [:]
    }
    
    
    var urlParams: [String :String?] {
        return [:]
    }
    
    var bodyParams: [String: Any] {
        return [:]
    }
    
    var requestType: RequestType {
        return .get
    }
    
    /// Building up a network request with all available properties!
    func getNetworkRequest() -> URLRequest? {
        var comps = URLComponents()
        comps.scheme = "https"
        comps.host = host
        comps.path = path
        if !urlParams.isEmpty {
            comps.queryItems = urlParams.map{ URLQueryItem(name: $0, value: $1) }
        }
       
        guard let url = comps.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        
        if !headers.isEmpty {
            request.allHTTPHeaderFields = headers
        }
            
        if !bodyParams.isEmpty, let bodyData = try? JSONSerialization.data(withJSONObject: bodyParams) {
            request.httpBody = bodyData
        }
        
        return request
    }
}

