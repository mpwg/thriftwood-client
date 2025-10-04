//
//  HTTPMethod.swift
//  Thriftwood
//
//  Core networking types for HTTP methods
//

import Foundation

/// HTTP methods supported by the API client
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}
