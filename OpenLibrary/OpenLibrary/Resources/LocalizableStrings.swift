//
//  LocalizableStrings.swift
//  OpenLibrary
//
//  Created by vaibhav singh on 20/12/22.
//

import Foundation

/// In a real app we can localize all these strings to support multiple languages
struct LocalizableStrings {
    static let networkError = "Please check your network connection"
    static let searchFailure = "Unable to fetch the search results!"
    static let noSearchResultsAvailable = "No search results to display!"
    static let retryButtonTitle = "Retry"
    static let moreCharactersNeeded = "Please type atleast 3 or more characters and retry!"
    static let characterLimitExceeded = "Only a maximum of 20 characters are allowed, please retry with a shorter query!"
}
