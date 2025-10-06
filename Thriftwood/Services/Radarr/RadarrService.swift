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
//  Implementation of RadarrServiceProtocol using OpenAPI-generated client
//

import Foundation
import RadarrAPI

// Import generated OpenAPI client
// Note: RadarrAPI is a local Swift Package at project root
// Add it via Xcode: File > Add Package Dependencies > Add Local > RadarrAPI

/// Implementation of Radarr service using OpenAPI-generated client
///
/// Wraps Radarr API v3 endpoints with type-safe Swift models.
/// Uses OpenAPITools-generated client (per ADR-0006) for type-safe API access.
///
/// ## Architecture:
/// - Follows MVVM-C pattern (ADR-0005)
/// - Registered in DIContainer as singleton (ADR-0003)
/// - Maps all errors to `ThriftwoodError` for consistent error handling
/// - Uses generated RadarrAPI clients for all HTTP communication
///
/// ## Configuration:
/// Service must be configured via `configure(baseURL:apiKey:)` before use.
/// Configuration updates the shared RadarrAPIAPIConfiguration instance.
///
/// ## Error Mapping:
/// - ErrorResponse.error(401) → `.authenticationRequired`
/// - ErrorResponse.error(404) → `.notFound`
/// - ErrorResponse.error(400) → `.apiError` with details
/// - ErrorResponse.error(500+) → `.serviceUnavailable`
/// - Network errors → `.networkError`
/// - Decoding errors → `.decodingError`
final class RadarrService: RadarrServiceProtocol, Sendable {
    
    // MARK: - Properties
    
    /// Thread-safe configuration storage
    private let configuration: Configuration
    
    // MARK: - Configuration Actor
    
    /// Thread-safe configuration storage
    private actor Configuration {
        var apiConfiguration: RadarrAPIAPIConfiguration
        var isConfigured: Bool = false
        
        init() {
            // Initialize with empty configuration
            // Will be set via configure(baseURL:apiKey:)
            self.apiConfiguration = RadarrAPIAPIConfiguration.shared
        }
        
        func configure(baseURL: URL, apiKey: String) {
            // Create new configuration with custom headers for API key
            let basePath = baseURL.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            apiConfiguration = RadarrAPIAPIConfiguration(
                basePath: basePath,
                customHeaders: ["X-Api-Key": apiKey]  // Radarr uses X-Api-Key header
            )
            isConfigured = true
        }
        
        func getConfiguration() -> RadarrAPIAPIConfiguration? {
            guard isConfigured else { return nil }
            return apiConfiguration
        }
    }
    
    // MARK: - Initialization
    
    /// Creates a new Radarr service instance
    init() {
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
        await configuration.configure(baseURL: baseURL, apiKey: apiKey)
        
        AppLogger.networking.info("Radarr service configured for \(baseURL.absoluteString)")
    }
    
    // MARK: - Movie Management
    
    func getMovies() async throws -> [Movie] {
        let apiConfig = try await getAPIConfiguration()
        
        do {
            let resources = try await RadarrMovieAPI.apiV3MovieGet(apiConfiguration: apiConfig)
            return resources.compactMap { $0.toDomainModel() }
        } catch {
            throw mapError(error)
        }
    }
    
    func getMovie(id: Int) async throws -> Movie {
        let apiConfig = try await getAPIConfiguration()
        
        do {
            let resource = try await RadarrMovieAPI.apiV3MovieIdGet(id: id, apiConfiguration: apiConfig)
            guard let movie = resource.toDomainModel() else {
                throw ThriftwoodError.decodingError(.dataCorrupted(.init(codingPath: [], debugDescription: "Failed to map MovieResource to domain model")))
            }
            return movie
        } catch {
            throw mapError(error)
        }
    }
    
    func searchMovies(query: String) async throws -> [MovieSearchResult] {
        guard !query.isEmpty else {
            throw ThriftwoodError.validation(message: "Search query cannot be empty")
        }
        
        let apiConfig = try await getAPIConfiguration()
        
        do {
            let resources = try await RadarrMovieLookupAPI.apiV3MovieLookupGet(term: query, apiConfiguration: apiConfig)
            return resources.compactMap { $0.toSearchResult() }
        } catch {
            throw mapError(error)
        }
    }
    
    func addMovie(_ request: AddMovieRequest) async throws -> Movie {
        let apiConfig = try await getAPIConfiguration()
        
        do {
            let movieResource = request.toMovieResource()
            let resource = try await RadarrMovieAPI.apiV3MoviePost(movieResource: movieResource, apiConfiguration: apiConfig)
            guard let movie = resource.toDomainModel() else {
                throw ThriftwoodError.decodingError(.dataCorrupted(.init(codingPath: [], debugDescription: "Failed to map added movie to domain model")))
            }
            return movie
        } catch {
            throw mapError(error)
        }
    }
    
    func updateMovie(_ movie: Movie) async throws -> Movie {
        let apiConfig = try await getAPIConfiguration()
        
        do {
            let movieResource = movie.toMovieResource()
            let resource = try await RadarrMovieAPI.apiV3MovieIdPut(
                id: String(movie.id),
                moveFiles: false,
                movieResource: movieResource,
                apiConfiguration: apiConfig
            )
            guard let updatedMovie = resource.toDomainModel() else {
                throw ThriftwoodError.decodingError(.dataCorrupted(.init(codingPath: [], debugDescription: "Failed to map updated movie to domain model")))
            }
            return updatedMovie
        } catch {
            throw mapError(error)
        }
    }
    
    func deleteMovie(id: Int, deleteFiles: Bool = false) async throws {
        let apiConfig = try await getAPIConfiguration()
        
        do {
            try await RadarrMovieAPI.apiV3MovieIdDelete(
                id: id,
                deleteFiles: deleteFiles,
                addImportExclusion: false,
                apiConfiguration: apiConfig
            )
        } catch {
            throw mapError(error)
        }
    }
    
    // MARK: - Configuration Resources
    
    func getQualityProfiles() async throws -> [QualityProfile] {
        let apiConfig = try await getAPIConfiguration()
        
        do {
            let resources = try await RadarrQualityProfileAPI.apiV3QualityprofileGet(apiConfiguration: apiConfig)
            return resources.compactMap { $0.toDomainModel() }
        } catch {
            throw mapError(error)
        }
    }
    
    func getRootFolders() async throws -> [RootFolder] {
        let apiConfig = try await getAPIConfiguration()
        
        do {
            let resources = try await RadarrRootFolderAPI.apiV3RootfolderGet(apiConfiguration: apiConfig)
            return resources.compactMap { $0.toDomainModel() }
        } catch {
            throw mapError(error)
        }
    }
    
    // MARK: - System Information
    
    func getSystemStatus() async throws -> SystemStatus {
        let apiConfig = try await getAPIConfiguration()
        
        do {
            let resource = try await RadarrSystemAPI.apiV3SystemStatusGet(apiConfiguration: apiConfig)
            guard let status = resource.toDomainModel() else {
                throw ThriftwoodError.decodingError(.dataCorrupted(.init(codingPath: [], debugDescription: "Failed to map system status to domain model")))
            }
            return status
        } catch {
            throw mapError(error)
        }
    }
    
    func testConnection() async throws -> Bool {
        // Test connection by fetching system status
        _ = try await getSystemStatus()
        return true
    }
    
    // MARK: - Private Helper Methods
    
    /// Get configured API configuration or throw error
    private func getAPIConfiguration() async throws -> RadarrAPIAPIConfiguration {
        guard let apiConfig = await configuration.getConfiguration() else {
            throw ThriftwoodError.invalidConfiguration("Service not configured. Call configure(baseURL:apiKey:) first")
        }
        return apiConfig
    }
    
    /// Map OpenAPI ErrorResponse to ThriftwoodError
    private func mapError(_ error: any Error) -> ThriftwoodError {
        if let error = error as? ThriftwoodError {
            return error
        }
        
        // Handle ErrorResponse from OpenAPI generator
        if let errorResponse = error as? ErrorResponse {
            switch errorResponse {
            case .error(let statusCode, let data, _, let underlyingError):
                switch statusCode {
                case 401:
                    return .authenticationRequired
                case 404:
                    return .notFound(message: "Resource not found")
                case 400...499:
                    let detail = String(data: data ?? Data(), encoding: .utf8) ?? underlyingError.localizedDescription
                    return .apiError(statusCode: statusCode, message: detail)
                case 500...599:
                    return .serviceUnavailable
                default:
                    let detail = String(data: data ?? Data(), encoding: .utf8) ?? underlyingError.localizedDescription
                    return .apiError(statusCode: statusCode, message: detail)
                }
            }
        }
        
        // Handle URLError
        if let urlError = error as? URLError {
            return .networkError(urlError)
        }
        
        // Generic network error - wrap in URLError
        return .networkError(URLError(.unknown))
    }
}
