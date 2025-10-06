//
//  RadarrService.swift
//  Thriftwood
//
//  Thriftwood - Frontend for Media Management
//  Copyright (C) 2025 Matthias Wallner Géhri
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
//
//  RadarrService.swift
//  Thriftwood
//
//  Implementation of RadarrServiceProtocol using AsyncHTTPClient
//

import Foundation
import AsyncHTTPClient
import NIOCore
import NIOHTTP1
import NIOFoundationCompat

/// Implementation of Radarr service using AsyncHTTPClient
///
/// Wraps Radarr API v3 endpoints with type-safe Swift models.
/// Uses AsyncHTTPClient (per ADR-0004) for HTTP networking.
///
/// ## Architecture:
/// - Follows MVVM-C pattern (ADR-0005)
/// - Registered in DIContainer as singleton (ADR-0003)
/// - Maps all errors to `ThriftwoodError` for consistent error handling
///
/// ## Configuration:
/// Service must be configured via `configure(baseURL:apiKey:)` before use.
/// Configuration is stored in-memory and injected per-request via headers.
///
/// ## Error Mapping:
/// - HTTP 401 → `.authenticationRequired`
/// - HTTP 404 → `.notFound`
/// - HTTP 400 → `.apiError` with details
/// - HTTP 500+ → `.serviceUnavailable`
/// - Network errors → `.networkError`
/// - JSON decoding errors → `.decodingError`
final class RadarrService: RadarrServiceProtocol, Sendable {
    
    // MARK: - Properties
    
    /// HTTP client for API requests
    private let httpClient: HTTPClient
    
    /// Current base URL (thread-safe via actor isolation)
    private let configuration: Configuration
    
    // MARK: - Configuration Actor
    
    /// Thread-safe configuration storage
    private actor Configuration {
        var baseURL: URL?
        var apiKey: String?
        
        func set(baseURL: URL, apiKey: String) {
            self.baseURL = baseURL
            self.apiKey = apiKey
        }
        
        func get() -> (baseURL: URL, apiKey: String)? {
            guard let baseURL, let apiKey else { return nil }
            return (baseURL, apiKey)
        }
    }
    
    // MARK: - Initialization
    
    /// Creates a new Radarr service instance
    ///
    /// - Parameter httpClient: AsyncHTTPClient instance for HTTP requests
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
        self.configuration = Configuration()
    }
    
    // MARK: - Configuration
    
    func configure(baseURL: URL, apiKey: String) async throws {
        // Validate inputs
        guard baseURL.scheme == "http" || baseURL.scheme == "https" else {
            throw ThriftwoodError.invalidURL
        }
        
        guard !apiKey.isEmpty else {
            throw ThriftwoodError.invalidConfiguration("API key cannot be empty")
        }
        
        // Store configuration
        await configuration.set(baseURL: baseURL, apiKey: apiKey)
        
        AppLogger.networking.info("Radarr service configured for \(baseURL.absoluteString)")
    }
    
    // MARK: - Movie Management
    
    func getMovies() async throws -> [Movie] {
        let endpoint = "/api/v3/movie"
        let response: [RadarrMovieDTO] = try await executeRequest(
            path: endpoint,
            method: .GET
        )
        return response.map { $0.toDomain() }
    }
    
    func getMovie(id: Int) async throws -> Movie {
        let endpoint = "/api/v3/movie/\(id)"
        let response: RadarrMovieDTO = try await executeRequest(
            path: endpoint,
            method: .GET
        )
        return response.toDomain()
    }
    
    func searchMovies(query: String) async throws -> [MovieSearchResult] {
        guard !query.isEmpty else {
            throw ThriftwoodError.validation(message: "Search query cannot be empty")
        }
        
        let endpoint = "/api/v3/movie/lookup"
        let queryItems = [URLQueryItem(name: "term", value: query)]
        
        let response: [RadarrMovieLookupDTO] = try await executeRequest(
            path: endpoint,
            method: .GET,
            queryItems: queryItems
        )
        return response.map { $0.toDomain() }
    }
    
    func addMovie(_ request: AddMovieRequest) async throws -> Movie {
        let endpoint = "/api/v3/movie"
        let dto = AddMovieDTO(from: request)
        
        let response: RadarrMovieDTO = try await executeRequest(
            path: endpoint,
            method: .POST,
            body: dto
        )
        return response.toDomain()
    }
    
    func updateMovie(_ movie: Movie) async throws -> Movie {
        let endpoint = "/api/v3/movie/\(movie.id)"
        let dto = UpdateMovieDTO(from: movie)
        
        let response: RadarrMovieDTO = try await executeRequest(
            path: endpoint,
            method: .PUT,
            body: dto
        )
        return response.toDomain()
    }
    
    func deleteMovie(id: Int, deleteFiles: Bool = false) async throws {
        let endpoint = "/api/v3/movie/\(id)"
        let queryItems = [URLQueryItem(name: "deleteFiles", value: String(deleteFiles))]
        
        // DELETE returns no content (204)
        try await executeRequestNoResponse(
            path: endpoint,
            method: .DELETE,
            queryItems: queryItems
        )
    }
    
    // MARK: - Configuration Resources
    
    func getQualityProfiles() async throws -> [QualityProfile] {
        let endpoint = "/api/v3/qualityprofile"
        let response: [RadarrQualityProfileDTO] = try await executeRequest(
            path: endpoint,
            method: .GET
        )
        return response.map { $0.toDomain() }
    }
    
    func getRootFolders() async throws -> [RootFolder] {
        let endpoint = "/api/v3/rootfolder"
        let response: [RadarrRootFolderDTO] = try await executeRequest(
            path: endpoint,
            method: .GET
        )
        return response.map { $0.toDomain() }
    }
    
    // MARK: - System Information
    
    func getSystemStatus() async throws -> SystemStatus {
        let endpoint = "/api/v3/system/status"
        let response: RadarrSystemStatusDTO = try await executeRequest(
            path: endpoint,
            method: .GET
        )
        return response.toDomain()
    }
    
    func testConnection() async throws -> Bool {
        // Test connection by fetching system status
        _ = try await getSystemStatus()
        return true
    }
    
    // MARK: - Private Helper Methods
    
    /// Executes an HTTP request with proper error handling and authentication
    private func executeRequest<T: Decodable>(
        path: String,
        method: HTTPMethod,
        queryItems: [URLQueryItem]? = nil,
        body: (any Encodable)? = nil,
        expectsNoContent: Bool = false
    ) async throws -> T {
        // Get configuration
        guard let config = await configuration.get() else {
            throw ThriftwoodError.invalidConfiguration("Service not configured. Call configure(baseURL:apiKey:) first")
        }
        
        // Build URL
        var components = URLComponents(url: config.baseURL, resolvingAgainstBaseURL: false)!
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw ThriftwoodError.invalidURL
        }
        
        // Create request
        var request = HTTPClientRequest(url: url.absoluteString)
        request.method = method
        
        // Add authentication header
        request.headers.add(name: "X-Api-Key", value: config.apiKey)
        request.headers.add(name: "Accept", value: "application/json")
        
        // Add body if present
        if let body {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            encoder.dateEncodingStrategy = .iso8601
            
            let bodyData = try encoder.encode(body)
            request.body = .bytes(ByteBuffer(data: bodyData))
            request.headers.add(name: "Content-Type", value: "application/json")
        }
        
        // Execute request
        let response: HTTPClientResponse
        do {
            response = try await httpClient.execute(request, timeout: .seconds(30))
        } catch {
            AppLogger.networking.error("Network request failed for \(url.absoluteString)", error: error)
            throw ThriftwoodError.networkError(error as? URLError ?? URLError(.badServerResponse))
        }
        
        // Handle HTTP status codes
        try handleHTTPStatus(response.status, url: url)
        
        // Handle no-content responses (DELETE operations)
        if expectsNoContent {
            // Return empty value for Void responses
            return () as! T
        }
        
        // Read response body
        let bodyData = try await response.body.collect(upTo: 10 * 1024 * 1024) // 10MB max
        let data = Data(buffer: bodyData)
        
        // Decode response
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            AppLogger.networking.error("Failed to decode response from \(url.absoluteString)", error: error)
            throw ThriftwoodError.decodingError(error as? DecodingError ?? DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unknown decoding error")))
        }
    }
    
    /// Maps HTTP status codes to ThriftwoodError
    private func handleHTTPStatus(_ status: HTTPResponseStatus, url: URL) throws {
        switch status.code {
        case 200...299:
            return // Success
        case 401:
            AppLogger.networking.error("Authentication failed for \(url.absoluteString)")
            throw ThriftwoodError.authenticationRequired
        case 404:
            AppLogger.networking.error("Resource not found: \(url.absoluteString)")
            throw ThriftwoodError.notFound(message: "Resource not found")
        case 400...499:
            AppLogger.networking.error("Client error \(status.code) for \(url.absoluteString)")
            throw ThriftwoodError.apiError(statusCode: Int(status.code), message: status.reasonPhrase)
        case 500...599:
            AppLogger.networking.error("Server error \(status.code) for \(url.absoluteString)")
            throw ThriftwoodError.serviceUnavailable
        default:
            AppLogger.networking.error("Unexpected status code \(status.code) for \(url.absoluteString)")
            throw ThriftwoodError.apiError(statusCode: Int(status.code), message: status.reasonPhrase)
        }
    }
    
    /// Executes an HTTP request that doesn't return data (e.g., DELETE)
    private func executeRequestNoResponse(
        path: String,
        method: HTTPMethod,
        queryItems: [URLQueryItem]? = nil
    ) async throws {
        // Get configuration
        guard let config = await configuration.get() else {
            throw ThriftwoodError.invalidConfiguration("Service not configured. Call configure(baseURL:apiKey:) first")
        }
        
        // Build URL
        var components = URLComponents(url: config.baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw ThriftwoodError.invalidURL
        }
        
        // Build request
        var request = HTTPClientRequest(url: url.absoluteString)
        request.method = method
        request.headers.add(name: "X-Api-Key", value: config.apiKey)
        request.headers.add(name: "Accept", value: "application/json")
        
        // Execute request
        let response: HTTPClientResponse
        do {
            response = try await httpClient.execute(request, timeout: .seconds(30))
        } catch {
            AppLogger.networking.error("Network request failed for \(url.absoluteString)", error: error)
            throw ThriftwoodError.networkError(error as? URLError ?? URLError(.badServerResponse))
        }
        
        // Handle HTTP status codes
        try handleHTTPStatus(response.status, url: url)
    }
}


// MARK: - Data Transfer Objects (DTOs)

/// DTO for Radarr movie API responses
private struct RadarrMovieDTO: Codable {
    let id: Int
    let title: String
    let overview: String?
    let year: Int?
    let tmdbId: Int?
    let imdbId: String?
    let hasFile: Bool?
    let monitored: Bool?
    let qualityProfileId: Int?
    let rootFolderPath: String?
    let sizeOnDisk: Int64?
    let status: String?
    let genres: [String]?
    let runtime: Int?
    let certification: String?
    let images: [RadarrImageDTO]?
    let inCinemas: String?
    let physicalRelease: String?
    let digitalRelease: String?
    
    func toDomain() -> Movie {
        // Parse release date (prefer digital, then physical, then cinemas)
        let dateFormatter = ISO8601DateFormatter()
        let releaseDate = [digitalRelease, physicalRelease, inCinemas]
            .compactMap { $0 }
            .compactMap { dateFormatter.date(from: $0) }
            .first
        
        // Get poster URL
        let posterURL = images?
            .first(where: { $0.coverType == "poster" })
            .flatMap { URL(string: $0.remoteUrl ?? "") }
        
        return Movie(
            id: String(id),
            title: title,
            overview: overview,
            releaseDate: releaseDate,
            posterURL: posterURL,
            year: year,
            tmdbId: tmdbId,
            imdbId: imdbId,
            hasFile: hasFile ?? false,
            monitored: monitored ?? true,
            qualityProfileId: qualityProfileId,
            rootFolderPath: rootFolderPath,
            sizeOnDisk: sizeOnDisk ?? 0,
            status: MovieStatus(rawValue: status?.lowercased() ?? "announced") ?? .announced,
            genres: genres ?? [],
            runtime: runtime,
            certification: certification
        )
    }
}

private struct RadarrImageDTO: Codable {
    let coverType: String?
    let remoteUrl: String?
    let url: String?
}

private struct RadarrMovieLookupDTO: Codable {
    let tmdbId: Int
    let title: String
    let overview: String?
    let year: Int?
    let imdbId: String?
    let images: [RadarrImageDTO]?
    let isExisting: Bool?
    
    func toDomain() -> MovieSearchResult {
        let posterURL = images?
            .first(where: { $0.coverType == "poster" })
            .flatMap { URL(string: $0.remoteUrl ?? "") }
        
        return MovieSearchResult(
            id: String(tmdbId),
            title: title,
            overview: overview,
            year: year,
            tmdbId: tmdbId,
            imdbId: imdbId,
            posterURL: posterURL,
            isExisting: isExisting ?? false
        )
    }
}

private struct AddMovieDTO: Codable {
    let tmdbId: Int
    let title: String
    let year: Int?
    let qualityProfileId: Int
    let rootFolderPath: String
    let monitored: Bool
    let addOptions: AddOptionsDTO
    let minimumAvailability: String
    
    init(from request: AddMovieRequest) {
        self.tmdbId = request.tmdbId
        self.title = request.title
        self.year = request.year
        self.qualityProfileId = request.qualityProfileId
        self.rootFolderPath = request.rootFolderPath
        self.monitored = request.monitored
        self.addOptions = AddOptionsDTO(searchForMovie: request.searchForMovie)
        self.minimumAvailability = request.minimumAvailability.rawValue
    }
}

private struct AddOptionsDTO: Codable {
    let searchForMovie: Bool
}

private struct UpdateMovieDTO: Codable {
    let id: Int
    let title: String
    let monitored: Bool
    let qualityProfileId: Int?
    let rootFolderPath: String?
    
    init(from movie: Movie) {
        self.id = Int(movie.id) ?? 0
        self.title = movie.title
        self.monitored = movie.monitored
        self.qualityProfileId = movie.qualityProfileId
        self.rootFolderPath = movie.rootFolderPath
    }
}

private struct RadarrQualityProfileDTO: Codable {
    let id: Int
    let name: String
    let upgradeAllowed: Bool?
    let cutoff: Int?
    
    func toDomain() -> QualityProfile {
        QualityProfile(
            id: String(id),
            name: name,
            upgradeAllowed: upgradeAllowed ?? true,
            cutoff: cutoff ?? 0
        )
    }
}

private struct RadarrRootFolderDTO: Codable {
    let id: Int
    let path: String
    let accessible: Bool?
    let freeSpace: Int64?
    let totalSpace: Int64?
    
    func toDomain() -> RootFolder {
        RootFolder(
            id: String(id),
            path: path,
            accessible: accessible ?? true,
            freeSpace: freeSpace ?? 0,
            totalSpace: totalSpace ?? 0
        )
    }
}

private struct RadarrSystemStatusDTO: Codable {
    let version: String
    let buildTime: String?
    let isDebug: Bool?
    let isProduction: Bool?
    let isAdmin: Bool?
    let isUserInteractive: Bool?
    let startupPath: String?
    let appData: String?
    let osName: String?
    let osVersion: String?
    let isMonoRuntime: Bool?
    let isMono: Bool?
    let isLinux: Bool?
    let isOsx: Bool?
    let isWindows: Bool?
    let branch: String?
    let authentication: String?
    let sqliteVersion: String?
    let urlBase: String?
    let runtimeVersion: String?
    let runtimeName: String?
    
    func toDomain() -> SystemStatus {
        let dateFormatter = ISO8601DateFormatter()
        let buildDate = buildTime.flatMap { dateFormatter.date(from: $0) }
        
        return SystemStatus(
            version: version,
            buildTime: buildDate,
            isDebug: isDebug ?? false,
            isProduction: isProduction ?? true,
            isAdmin: isAdmin ?? false,
            isUserInteractive: isUserInteractive ?? false,
            startupPath: startupPath ?? "",
            appData: appData ?? "",
            osName: osName ?? "",
            osVersion: osVersion ?? "",
            isMonoRuntime: isMonoRuntime ?? false,
            isMono: isMono ?? false,
            isLinux: isLinux ?? false,
            isOsx: isOsx ?? false,
            isWindows: isWindows ?? false,
            branch: branch ?? "",
            authentication: authentication ?? "none",
            sqliteVersion: sqliteVersion ?? "",
            urlBase: urlBase,
            runtimeVersion: runtimeVersion ?? "",
            runtimeName: runtimeName ?? ""
        )
    }
}
