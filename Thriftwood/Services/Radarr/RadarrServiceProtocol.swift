//
//  RadarrServiceProtocol.swift
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
//  RadarrServiceProtocol.swift
//  Thriftwood
//
//  Protocol definition for Radarr service following MVVM-C architecture
//

import Foundation

/// Protocol for Radarr media management service
///
/// Provides async methods for interacting with Radarr API, following
/// the MVVM-C pattern (ADR-0005) and dependency injection principles (ADR-0003).
///
/// All methods are async and throw `ThriftwoodError` for error handling.
/// The service wraps OpenAPI-generated clients per ADR-0006.
///
/// ## Use Cases:
/// - **Movie Library Management**: View all movies, search for new movies, add/update/delete movies
/// - **Configuration**: Get quality profiles, root folders, and system status
/// - **Connection Testing**: Verify API connectivity and authentication
///
/// ## Error Handling:
/// All methods throw `ThriftwoodError` with semantic error types:
/// - `.authenticationRequired`: Invalid API key (401)
/// - `.networkError`: Network connectivity issues
/// - `.apiError`: HTTP error responses from Radarr
/// - `.decodingError`: Failed to parse API response
/// - `.invalidConfiguration`: Missing or invalid configuration
///
/// ## Example Usage:
/// ```swift
/// let radarrService = container.resolve(RadarrServiceProtocol.self)
/// do {
///     try await radarrService.configure(baseURL: url, apiKey: key)
///     let movies = try await radarrService.getMovies()
/// } catch let error as ThriftwoodError {
///     // Handle error
/// }
/// ```
protocol RadarrServiceProtocol: Sendable {
    
    // MARK: - Configuration
    
    /// Configure the service with connection details
    ///
    /// Must be called before any other methods to establish connection
    /// to Radarr instance. Credentials are validated on first API call.
    ///
    /// - Parameters:
    ///   - baseURL: Base URL of Radarr instance (e.g., "https://radarr.example.com")
    ///   - apiKey: Radarr API key for authentication
    /// - Throws: `ThriftwoodError.invalidURL` if baseURL is malformed
    /// - Throws: `ThriftwoodError.invalidConfiguration` if parameters are invalid
    func configure(baseURL: URL, apiKey: String) async throws
    
    // MARK: - Movie Management
    
    /// Get all movies from Radarr library
    ///
    /// Fetches the complete movie collection with metadata, file status,
    /// and monitoring state.
    ///
    /// - Returns: Array of `Movie` objects
    /// - Throws: `ThriftwoodError.authenticationRequired` if API key is invalid (401)
    /// - Throws: `ThriftwoodError.networkError` if network request fails
    /// - Throws: `ThriftwoodError.decodingError` if response parsing fails
    func getMovies() async throws -> [Movie]
    
    /// Get a specific movie by ID
    ///
    /// Retrieves detailed information for a single movie.
    ///
    /// - Parameter id: Radarr movie ID
    /// - Returns: `Movie` object with full details
    /// - Throws: `ThriftwoodError.notFound` if movie doesn't exist (404)
    /// - Throws: `ThriftwoodError.authenticationRequired` if API key is invalid (401)
    /// - Throws: `ThriftwoodError.networkError` if network request fails
    func getMovie(id: Int) async throws -> Movie
    
    /// Search for movies on external indexers (TMDB)
    ///
    /// Searches for movies by title to add to library. Results include
    /// both new movies and movies already in the library.
    ///
    /// - Parameter query: Search query (movie title)
    /// - Returns: Array of `MovieSearchResult` objects
    /// - Throws: `ThriftwoodError.validation` if query is empty
    /// - Throws: `ThriftwoodError.authenticationRequired` if API key is invalid (401)
    /// - Throws: `ThriftwoodError.networkError` if network request fails
    func searchMovies(query: String) async throws -> [MovieSearchResult]
    
    /// Add a new movie to Radarr library
    ///
    /// Adds a movie with specified quality profile, root folder, and monitoring settings.
    /// Optionally triggers automatic search for the movie.
    ///
    /// - Parameter request: `AddMovieRequest` with movie details and settings
    /// - Returns: The newly added `Movie` object
    /// - Throws: `ThriftwoodError.validation` if request is invalid
    /// - Throws: `ThriftwoodError.apiError` if movie already exists or parameters are invalid (400)
    /// - Throws: `ThriftwoodError.authenticationRequired` if API key is invalid (401)
    /// - Throws: `ThriftwoodError.networkError` if network request fails
    func addMovie(_ request: AddMovieRequest) async throws -> Movie
    
    /// Update an existing movie in Radarr library
    ///
    /// Updates movie properties such as monitoring state, quality profile,
    /// root folder path, etc.
    ///
    /// - Parameter movie: `Movie` object with updated properties
    /// - Returns: The updated `Movie` object
    /// - Throws: `ThriftwoodError.notFound` if movie doesn't exist (404)
    /// - Throws: `ThriftwoodError.validation` if movie data is invalid
    /// - Throws: `ThriftwoodError.authenticationRequired` if API key is invalid (401)
    /// - Throws: `ThriftwoodError.networkError` if network request fails
    func updateMovie(_ movie: Movie) async throws -> Movie
    
    /// Delete a movie from Radarr library
    ///
    /// Removes the movie from Radarr. Optionally deletes associated files.
    ///
    /// - Parameters:
    ///   - id: Radarr movie ID
    ///   - deleteFiles: Whether to delete associated movie files (default: false)
    /// - Throws: `ThriftwoodError.notFound` if movie doesn't exist (404)
    /// - Throws: `ThriftwoodError.authenticationRequired` if API key is invalid (401)
    /// - Throws: `ThriftwoodError.networkError` if network request fails
    func deleteMovie(id: Int, deleteFiles: Bool) async throws
    
    // MARK: - Configuration Resources
    
    /// Get all quality profiles from Radarr
    ///
    /// Quality profiles define video quality preferences (e.g., "HD-1080p", "Any").
    /// Required when adding movies to specify desired quality.
    ///
    /// - Returns: Array of `QualityProfile` objects
    /// - Throws: `ThriftwoodError.authenticationRequired` if API key is invalid (401)
    /// - Throws: `ThriftwoodError.networkError` if network request fails
    func getQualityProfiles() async throws -> [QualityProfile]
    
    /// Get all root folders from Radarr
    ///
    /// Root folders define where movie files are stored on disk.
    /// Required when adding movies to specify storage location.
    ///
    /// - Returns: Array of `RootFolder` objects with space information
    /// - Throws: `ThriftwoodError.authenticationRequired` if API key is invalid (401)
    /// - Throws: `ThriftwoodError.networkError` if network request fails
    func getRootFolders() async throws -> [RootFolder]
    
    // MARK: - System Information
    
    /// Get Radarr system status
    ///
    /// Retrieves system information including version, OS, runtime, and authentication method.
    /// Useful for verifying connection and displaying system details.
    ///
    /// - Returns: `SystemStatus` object with system information
    /// - Throws: `ThriftwoodError.authenticationRequired` if API key is invalid (401)
    /// - Throws: `ThriftwoodError.networkError` if network request fails
    func getSystemStatus() async throws -> SystemStatus
    
    /// Test connection to Radarr instance
    ///
    /// Verifies that the service is configured and can successfully
    /// communicate with Radarr API. Performs a lightweight API call.
    ///
    /// - Returns: `true` if connection is successful
    /// - Throws: `ThriftwoodError.invalidConfiguration` if service not configured
    /// - Throws: `ThriftwoodError.authenticationRequired` if API key is invalid (401)
    /// - Throws: `ThriftwoodError.networkError` if network request fails
    func testConnection() async throws -> Bool
}
