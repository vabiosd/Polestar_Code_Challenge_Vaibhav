//
//  BooksSearchEndpoint.swift
//  OpenLibrary
//
//  Created by vaibhav singh on 16/12/22.
//

import Foundation

/// An endpoint used to search books
/// We only need to define a path and an url param
struct BooksSearchEndpoint: NetworkEndpointProtocol {
    var path: String {
        return "/search.json"
    }
    
    var urlParams: [String : String?] {
        return ["q": searchString ]
    }
    
    private let searchString: String
    
    /// Injecting the searchString to build the endpoint's query
    init(searchString: String) {
        self.searchString = searchString
    }
}
