//
//  NetworkError.swift
//  OpenLibrary
//
//  Created by vaibhav singh on 16/12/22.
//

import Foundation

/// Different error cases while interacting with the APIs
enum NetworkError: Error {
    case badRequest
    case networkError
    case badResponse
}
