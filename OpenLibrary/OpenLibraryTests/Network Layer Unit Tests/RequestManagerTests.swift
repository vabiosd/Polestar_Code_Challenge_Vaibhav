//
//  NetworkManager.swift
//  OpenLibraryTests
//
//  Created by vaibhav singh on 20/12/22.
//

import XCTest
@testable import OpenLibrary

class RequestManagerTests: XCTestCase {
    
    var requestManager: RequestManager!
    let bundle = Bundle(for: RequestManagerTests.self)

    override func setUpWithError() throws {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        requestManager = RequestManager(apiManager: MockAPIManager(), jsonDecoder: jsonDecoder)
    }

    override func tearDownWithError() throws {
        requestManager = nil
    }
    
    /// Testing Network Manager's fetching data functionality using the local data from MockUserAccountsJSON
    func testNetworkManagerSuccessfulUserAccountsFetch() {
        let mockJSONPath = bundle.path(forResource: "BookSearchMockJSON", ofType: "json") ?? ""
        let endpoint = MockLocalEndpoint(path: mockJSONPath)
        
        requestManager.getDataModel(endpoint: endpoint) { (result: Result<BookSearchResults, NetworkError>) in
            switch result {
            case .success(let bookSearchResults):
                /// Checking the search results fetched is as expected
                XCTAssertEqual(bookSearchResults.results.count, 2, "Expected to fetch 2 items")
                
                /// Checking a few properties of the first items fetched
                if let bookSearchResult = bookSearchResults.results.first {
                    XCTAssertEqual(bookSearchResult.key, "/works/OL27448W", "Expected the key to be /works/OL27448 w")
                    XCTAssertEqual(bookSearchResult.title, "The Lord of the Rings", "Expected the id to be The Lord of the Rings")
                    XCTAssertEqual(bookSearchResult.publishYearValue, 1999, "Expected publishYearValue to be 1999")
                }
                
                
            case .failure(_):
                XCTFail("Failed to fetch the book search results!")
            }
        }
    }
    
    /// Testing a broken API response leads to failure when fetching accounts
    /// To break the JSON some required keys are removed and renamed
    func testNetworkManagerUnSuccessfulUserAccountsFetch() {
        let mockJSONPath = bundle.path(forResource: "BookSearchMockBrokenJSON", ofType: "json") ?? ""
        let endpoint = MockLocalEndpoint(path: mockJSONPath)
        
        requestManager.getDataModel(endpoint: endpoint) { (result: Result<BookSearchResults, NetworkError>) in
            switch result {
            case .success(_):
                XCTFail("Expected book search to fail")
                
            case .failure(let error):
                /// Checking the error thrown is as expected
                XCTAssertEqual(error, .badResponse, "Expected a bad response error")
            }
        }
    }

}
