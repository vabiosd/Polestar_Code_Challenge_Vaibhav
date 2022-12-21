//
//  BookSearchViewModelTests.swift
//  OpenLibraryTests
//
//  Created by vaibhav singh on 21/12/22.
//

import XCTest
@testable import OpenLibrary

class BookSearchViewModelTests: XCTestCase {
    
    var bookSearchViewModel: BookSearchViewModel!
    let bundle = Bundle(for: BookSearchViewModelTests.self)
    var requestManager: RequestManager!

    override func setUpWithError() throws {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        requestManager = RequestManager(apiManager: MockAPIManager(),
                                        jsonDecoder: jsonDecoder)
        bookSearchViewModel = BookSearchViewModel(requestManager: requestManager)
    }

    override func tearDownWithError() throws {
        bookSearchViewModel = nil
        requestManager = nil
    }
    
    func testViewModelInit() {
        /// Testing the initial viewModel properties
        XCTAssertEqual(bookSearchViewModel.bookSearchResults, [])
    }
    
    //MARK: Input Validation Tests
    
    func testFetchBookInputMoreCharactersNeededFailure() {
        /// Expecting input validation error state
        let errorStateExpectation = XCTestExpectation(description: "Expect Input Validation error.")
        
        bookSearchViewModel.updateBookSearchState = { state in
            switch state {
            case .noResults(let errorString):
                XCTAssertEqual(errorString, LocalizableStrings.moreCharactersNeeded, "Expected more charcters needed error")
                errorStateExpectation.fulfill()
            default:
                XCTFail("Expected more charcters needed error")
            }
        }
        
        bookSearchViewModel.fetchBooks(searchString: "a")
        
        wait(for: [errorStateExpectation], timeout: 0.1)
    }
    
    func testFetchBookInputCharacterLimitExceededFailure() {
        /// Expecting input validation error state
        let errorStateExpectation = XCTestExpectation(description: "Expect Input Validation error.")
        
        bookSearchViewModel.updateBookSearchState = { state in
            switch state {
            case .noResults(let errorString):
                XCTAssertEqual(errorString, LocalizableStrings.characterLimitExceeded, "Expected character limit exceeded error")
                errorStateExpectation.fulfill()
            default:
                XCTFail("Expected more charcters needed error")
            }
        }
        
        bookSearchViewModel.fetchBooks(searchString: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua")
        
        wait(for: [errorStateExpectation], timeout: 0.1)
    }
    
    //MARK: Book Search Tests
    
    /// Testing the state and viewModel outputs when books are searched successfully
    func testFetchBooksFromEndpointSuccess() {
        /// Local endPoint used to extract data from a local file using the MockAPIManager
        let localBookSearchEndpoint = MockLocalEndpoint(path: bundle.path(forResource: "BookSearchMockJSON", ofType: "json") ?? "")
        
        /// Expecting loading state
        let loadingExpectation = XCTestExpectation(description: "Expect loading state")
        /// Expecting loaded state
        let loadedExpectation = XCTestExpectation(description: "Expect search results to be displayed")
        
        bookSearchViewModel.updateBookSearchState = { state in
            switch state {
            /// Fulfil the expectations based on state
            case .searching:
                loadingExpectation.fulfill()
            case .displayingResults:
                loadedExpectation.fulfill()
            default:
                /// Didn't expect a failure state so fail the test
                XCTFail("Expected search to succeed")
            }
        }

        bookSearchViewModel.fetchBooks(fromEndPoint: localBookSearchEndpoint)
        
        /// Check the search results
        XCTAssertEqual(bookSearchViewModel.bookSearchResults.count, 2, "Expected 2 serach resultss")
        XCTAssertEqual(bookSearchViewModel.bookSearchResults[0].bookTitleAndYear, "The Lord of the Rings (1999)", "Title and year string not as expected")
        XCTAssertEqual(bookSearchViewModel.bookSearchResults[0].authorNameString, "Author: J.R.R. Tolkien", "Author string not as expected")
        
        wait(for: [loadingExpectation, loadedExpectation], timeout: 0.1)
    }
    
    /// Testing the state and viewModel outputs when book search fails
    func testFetchBooksFromEndPointFailure() {
        /// Local endPoint containing broken JSON
        let localBookSearchEndpoint = MockLocalEndpoint(path: bundle.path(forResource: "BookSearchMockBrokenJSON", ofType: "json") ?? "")
        
        /// Expecting loading state
        let loadingExpectation = XCTestExpectation(description: "Expect loading state")
        /// Expecting loaded state
        let errorStateExpectation = XCTestExpectation(description: "Expect Book Search to fail")
        
        bookSearchViewModel.updateBookSearchState = { state in
            switch state {
            /// Fulfil the expectations based on state
            case .searching:
                loadingExpectation.fulfill()
            case .errorSearching(_):
                errorStateExpectation.fulfill()
            default:
                XCTFail("Expected search to fail")
            }
        }
        
        bookSearchViewModel.fetchBooks(fromEndPoint: localBookSearchEndpoint)
        
        wait(for: [loadingExpectation, errorStateExpectation], timeout: 0.1)
    }

}
