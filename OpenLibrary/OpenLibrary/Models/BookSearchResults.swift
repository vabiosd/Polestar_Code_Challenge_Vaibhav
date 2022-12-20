//
//  BookSearchResult.swift
//  OpenLibrary
//
//  Created by vaibhav singh on 16/12/22.
//

import Foundation

/// A struct containing the book search results
struct BookSearchResults: Decodable {
    let results: [BookSearchResult]
    
    /// Keys use to decode a JSON object in to a ``BookSearchResults``
    private enum CodingKeys: CodingKey {
        case docs
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decode([BookSearchResult].self, forKey: .docs)
    }
}
