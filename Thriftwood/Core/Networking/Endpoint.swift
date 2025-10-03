//
//  Endpoint.swift
//  Thriftwood
//
//  Defines API endpoint structure for network requests
//

import Foundation

/// Represents a network API endpoint with all necessary request components
struct Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]
    let queryItems: [URLQueryItem]?
    let body: (any Encodable)?
    
    /// Creates a new endpoint
    /// - Parameters:
    ///   - path: The URL path (e.g., "/api/v3/movie")
    ///   - method: HTTP method (default: GET)
    ///   - headers: Additional headers (default: empty)
    ///   - queryItems: URL query parameters (default: nil)
    ///   - body: Request body (default: nil)
    init(
        path: String,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        queryItems: [URLQueryItem]? = nil,
        body: (any Encodable)? = nil
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
    }
}
