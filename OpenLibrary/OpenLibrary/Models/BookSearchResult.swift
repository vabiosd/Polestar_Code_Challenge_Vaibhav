//
//  BookSearchResult.swift
//  OpenLibrary
//
//  Created by vaibhav singh on 16/12/22.
//

import Foundation

struct BookSearchResult: Decodable {
    
    /// Properties decoded from the book search result JSON
    let title: String
    /// Both author name and publish year are optional as they can be missing for some results
    let authorName: [String]?
    let publishYear: [Int]?
    
    ///Computed properties used within the project
    ///We are just taking the first value from the author name and publish year
    var authorNameString: String? {
        return authorName?.first
    }
    
    var publishYearValue: Int? {
        return publishYear?.first
    }
}
