//
//  MockLocalEndpoint.swift
//  OpenLibraryTests
//
//  Created by vaibhav singh on 20/12/22.
//

import Foundation
@testable import OpenLibrary

struct MockLocalEndpoint: NetworkEndpointProtocol {
    var path: String
}
