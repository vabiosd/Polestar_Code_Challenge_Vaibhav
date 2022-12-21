//
//  BookSearchViewModel.swift
//  OpenLibrary
//
//  Created by vaibhav singh on 20/12/22.
//

import Foundation

class BookSearchViewModel {
    //MARK: Outputs for the viewController
    
    var updateBookSearchState: ((BookSearchState) -> ())?
    
    var bookSearchResults: [BookSearchResultCellData] = []
    
    //MARK: Private properties
    
    /// Setting initial state to an empty list
    private var state: BookSearchState = .displayingResults {
        didSet {
            self.updateBookSearchState?(state)
        }
    }
    
    private let requestManager: RequestManager
    
    /// Injecting networkManager which can make this viewModel fully testable by mocking its dependency using the APIManager protocol to read data from a local file
    init(requestManager: RequestManager) {
        self.requestManager = requestManager
    }
    
    func fetchBooks(searchString: String) {
        
        /// User input validation
        if let errorString = getInputValidationError(text: searchString) {
            state = .noResults(errorString)
            return
        } 
        
        state = .searching
        self.bookSearchResults = []
        let bookSearchEndpoint = BooksSearchEndpoint(searchString: searchString)
        requestManager.getDataModel(endpoint: bookSearchEndpoint) { [weak self] (result: Result<BookSearchResults, NetworkError>) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let bookSearchResults):
                /// If list if empty show an empty list message or display the list
                if bookSearchResults.results.isEmpty {
                    self.state = .noResults(LocalizableStrings.noSearchResultsAvailable)
                } else {
                    self.state = .displayingResults
                }
                /// Mapping the first 10 results to BookSearchResultCellData
                self.bookSearchResults = self.mapSearchResultsToCellViewData(results: Array(bookSearchResults.results.prefix(10)))
            case .failure(let error):
                /// Show an appropriate error message to the user based on the error
                switch error {
                case .networkError:
                    self.state = .errorSearching(LocalizableStrings.networkError)
                 default:
                    self.state = .errorSearching(LocalizableStrings.searchFailure)
                }
            }
        }
    }
    
    private func mapSearchResultsToCellViewData(results: [BookSearchResult]) -> [BookSearchResultCellData] {
        return results.map{ result in
            var bookTitleAndYear = result.title
            if let publishYear = result.publishYearValue {
                bookTitleAndYear.append(" (\(publishYear))")
            }
            return BookSearchResultCellData(bookTitleAndYear: bookTitleAndYear,
                                            authorNameString: "Author: \(result.authorNameString ?? "")")
        }
    }
    
    /// Handling user input validation
    /// Showing errors in case user has used too less or too many characters
    private func getInputValidationError(text: String) -> String? {
        if text.count < 3 {
            return LocalizableStrings.moreCharactersNeeded
        } else if text.count > 20 {
            return LocalizableStrings.characterLimitExceeded
        } else {
            return nil
        }
    }
}
