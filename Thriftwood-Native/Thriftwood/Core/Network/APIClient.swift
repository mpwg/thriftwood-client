//
//  APIClient.swift
//  Thriftwood
//
//  Swift 6 Base API Client with Concurrency Safety
//

import Foundation

/// Base API client using Swift 6 concurrency patterns
actor APIClient: Sendable {
    
    // MARK: - Configuration
    
    struct Configuration: Sendable {
        let baseURL: URL
        let apiKey: String?
        let headers: [String: String]
        let timeout: TimeInterval
        
        init(baseURL: URL, apiKey: String? = nil, headers: [String: String] = [:], timeout: TimeInterval = 30.0) {
            self.baseURL = baseURL
            self.apiKey = apiKey
            self.headers = headers
            self.timeout = timeout
        }
    }
    
    // MARK: - Properties
    
    private let configuration: Configuration
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    // MARK: - Initialization
    
    init(configuration: Configuration) {
        self.configuration = configuration
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = configuration.timeout
        config.timeoutIntervalForResource = configuration.timeout
        self.session = URLSession(configuration: config)
        
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
        
        // Configure date decoding strategies
        decoder.dateDecodingStrategy = .iso8601
        encoder.dateEncodingStrategy = .iso8601
    }
    
    // MARK: - API Methods
    
    /// Perform GET request
    func get<T: Codable & Sendable>(
        path: String,
        queryParameters: [String: String] = [:],
        responseType: T.Type
    ) async throws -> T {
        let request = try buildRequest(
            path: path,
            method: "GET",
            queryParameters: queryParameters,
            body: Data?.none
        )
        
        return try await performRequest(request, responseType: responseType)
    }
    
    /// Perform POST request
    func post<T: Codable & Sendable, U: Codable & Sendable>(
        path: String,
        body: U? = nil,
        responseType: T.Type
    ) async throws -> T {
        var requestBody: Data?
        if let body = body {
            requestBody = try encoder.encode(body)
        }
        
        let request = try buildRequest(
            path: path,
            method: "POST",
            queryParameters: [:],
            body: requestBody
        )
        
        return try await performRequest(request, responseType: responseType)
    }
    
    /// Perform PUT request
    func put<T: Codable & Sendable, U: Codable & Sendable>(
        path: String,
        body: U? = nil,
        responseType: T.Type
    ) async throws -> T {
        var requestBody: Data?
        if let body = body {
            requestBody = try encoder.encode(body)
        }
        
        let request = try buildRequest(
            path: path,
            method: "PUT",
            queryParameters: [:],
            body: requestBody
        )
        
        return try await performRequest(request, responseType: responseType)
    }
    
    /// Perform DELETE request
    func delete<T: Codable & Sendable>(
        path: String,
        responseType: T.Type
    ) async throws -> T {
        let request = try buildRequest(
            path: path,
            method: "DELETE",
            queryParameters: [:],
            body: Data?.none
        )
        
        return try await performRequest(request, responseType: responseType)
    }
    
    /// Test connection to the service
    func testConnection() async throws -> Bool {
        let request = try buildRequest(
            path: "system/status",
            method: "GET",
            queryParameters: [:],
            body: Data?.none
        )
        
        do {
            let (_, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return false
            }
            return httpResponse.statusCode == 200
        } catch {
            return false
        }
    }
    
    // MARK: - Private Methods
    
    private func buildRequest(
        path: String,
        method: String,
        queryParameters: [String: String] = [:],
        body: Data? = nil
    ) throws -> URLRequest {
        var urlComponents = URLComponents(url: configuration.baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        
        // Add query parameters
        if !queryParameters.isEmpty {
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents?.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // Add headers
        configuration.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add API key if available
        if let apiKey = configuration.apiKey {
            request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        }
        
        // Add content type for body requests
        if body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // Set body data
        request.httpBody = body
        
        return request
    }
    
    private func performRequest<T: Codable & Sendable>(
        _ request: URLRequest,
        responseType: T.Type
    ) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw APIError.httpError(httpResponse.statusCode)
            }
            
            return try decoder.decode(responseType, from: data)
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}

// MARK: - API Error Types

enum APIError: Error, LocalizedError, Sendable {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(DecodingError)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

// MARK: - Request Logging (Debug)

#if DEBUG
extension APIClient {
    private func logRequest(_ request: URLRequest) {
        print("🌐 API Request: \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "unknown")")
        if let headers = request.allHTTPHeaderFields {
            print("📋 Headers: \(headers)")
        }
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("📦 Body: \(bodyString)")
        }
    }
    
    private func logResponse(_ data: Data, _ response: URLResponse) {
        if let httpResponse = response as? HTTPURLResponse {
            print("📡 API Response: \(httpResponse.statusCode)")
        }
        if let responseString = String(data: data, encoding: .utf8) {
            print("📋 Response: \(responseString)")
        }
    }
}
#endif