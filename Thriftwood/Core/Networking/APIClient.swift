//
//  APIClient.swift
//  Thriftwood
//
//  Protocol-oriented API client for network requests
//

import Foundation

/// Protocol for making HTTP requests to service APIs
protocol APIClient {
    /// Make a network request and decode the response
    /// - Parameter endpoint: The endpoint to request
    /// - Returns: Decoded response of type T
    /// - Throws: ThriftwoodError if request fails
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    
    /// Make a network request without expecting a response body
    /// - Parameter endpoint: The endpoint to request
    /// - Throws: ThriftwoodError if request fails
    func request(_ endpoint: Endpoint) async throws
}

/// Default implementation of APIClient using URLSession
final class DefaultAPIClient: APIClient {
    private let session: URLSession
    private let baseURL: URL
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    /// Initialize with configuration
    /// - Parameters:
    ///   - baseURL: Base URL for all requests
    ///   - session: URLSession instance (default: .shared)
    ///   - decoder: JSON decoder (default: JSONDecoder())
    ///   - encoder: JSON encoder (default: JSONEncoder())
    init(
        baseURL: URL,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let request = try buildRequest(from: endpoint)
        let (data, response) = try await session.data(for: request)
        
        try validateResponse(response)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw ThriftwoodError.decodingError(error as? DecodingError ?? DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unknown decoding error")))
        }
    }
    
    func request(_ endpoint: Endpoint) async throws {
        let request = try buildRequest(from: endpoint)
        let (_, response) = try await session.data(for: request)
        try validateResponse(response)
    }
    
    // MARK: - Private Helpers
    
    private func buildRequest(from endpoint: Endpoint) throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: true)
        components?.queryItems = endpoint.queryItems
        
        guard let url = components?.url else {
            throw ThriftwoodError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Add headers
        for (key, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add body if present
        if let body = endpoint.body {
            request.httpBody = try encodeBody(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
    private func encodeBody(_ body: any Encodable) throws -> Data {
        // Use type erasure to encode the existential type
        struct AnyEncodable: Encodable {
            let value: any Encodable
            
            func encode(to encoder: any Encoder) throws {
                try value.encode(to: encoder)
            }
        }
        
        return try encoder.encode(AnyEncodable(value: body))
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ThriftwoodError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            throw ThriftwoodError.authenticationRequired
        case 500...599:
            throw ThriftwoodError.serviceUnavailable
        default:
            throw ThriftwoodError.apiError(statusCode: httpResponse.statusCode, message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
        }
    }
}
