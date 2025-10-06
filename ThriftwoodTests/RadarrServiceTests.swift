//
//  RadarrServiceTests.swift
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

import Testing
import Foundation
@testable import Thriftwood
import RadarrAPI

// MARK: - Configuration Tests

@Suite("Radarr Service Configuration Tests")
struct RadarrServiceConfigurationTests {
    
    let testBaseURL = URL(string: "https://radarr.example.com")!
    let testAPIKey = "test-api-key-12345"
    
    @MainActor
    @Test("Configure service with valid parameters succeeds")
    func configureServiceSuccess() async throws {
        let service = RadarrService()
        try await service.configure(baseURL: testBaseURL, apiKey: testAPIKey)
        // If no error thrown, configuration succeeded
    }
    
    @MainActor
    @Test("Configure service with HTTP URL succeeds")
    func configureServiceHTTP() async throws {
        let service = RadarrService()
        let httpURL = URL(string: "http://localhost:7878")!
        try await service.configure(baseURL: httpURL, apiKey: testAPIKey)
    }
    
    @MainActor
    @Test("Configure service with invalid URL scheme throws error")
    func configureServiceInvalidURL() async throws {
        let service = RadarrService()
        let invalidURL = URL(string: "ftp://radarr.example.com")!
        await #expect(throws: ThriftwoodError.self) {
            try await service.configure(baseURL: invalidURL, apiKey: testAPIKey)
        }
    }
    
    @MainActor
    @Test("Configure service with empty API key throws error")
    func configureServiceEmptyAPIKey() async throws {
        let service = RadarrService()
        await #expect(throws: ThriftwoodError.self) {
            try await service.configure(baseURL: testBaseURL, apiKey: "")
        }
    }
    
    @MainActor
    @Test("Unconfigured service throws invalidConfiguration error")
    func unconfiguredServiceThrowsError() async throws {
        let service = RadarrService()
        do {
            _ = try await service.getMovies()
            Issue.record("Expected error but got success")
        } catch let error as ThriftwoodError {
            guard case .invalidConfiguration = error else {
                Issue.record("Expected invalidConfiguration error, got \(error)")
                return
            }
        }
    }
}

// MARK: - Validation Tests

@Suite("Radarr Service Input Validation Tests")
struct RadarrServiceValidationTests {
    
    let testBaseURL = URL(string: "https://radarr.example.com")!
    let testAPIKey = "test-api-key-12345"
    
    @MainActor
    @Test("Search movies with empty query throws validation error")
    func searchMoviesEmptyQuery() async throws {
        let service = RadarrService()
        try await service.configure(baseURL: testBaseURL, apiKey: testAPIKey)
        
        do {
            _ = try await service.searchMovies(query: "")
            Issue.record("Expected validation error for empty query")
        } catch let error as ThriftwoodError {
            guard case .validation = error else {
                Issue.record("Expected validation error, got \(error)")
                return
            }
        }
    }
    
    @MainActor
    @Test("Update movie without ID throws validation error")
    func updateMovieWithoutID() async throws {
        let service = RadarrService()
        try await service.configure(baseURL: testBaseURL, apiKey: testAPIKey)
        
        // Create movie without ID
        let movieWithoutID = MovieResource(
            id: nil,
            title: "Test Movie"
        )
        
        do {
            _ = try await service.updateMovie(movieWithoutID)
            Issue.record("Expected validation error for movie without ID")
        } catch let error as ThriftwoodError {
            guard case .validation = error else {
                Issue.record("Expected validation error, got \(error)")
                return
            }
        }
    }
}

// MARK: - Mock Service Tests

@Suite("Radarr Service with Mock - Movie Management")
struct RadarrServiceMovieTests {
    
    var mockService: MockRadarrService
    
    init() {
        mockService = MockRadarrService()
    }
    
    @Test("Get movies returns empty list when no movies exist")
    func getMoviesEmpty() async throws {
        let movies = try await mockService.getMovies()
        #expect(movies.isEmpty)
        #expect(mockService.getMoviesCallCount == 1)
    }
    
    @Test("Get movies returns populated list")
    func getMoviesPopulated() async throws {
        // Setup mock data
        mockService.movies = [
            MockRadarrService.createMockMovie(id: 1, title: "Movie 1"),
            MockRadarrService.createMockMovie(id: 2, title: "Movie 2"),
            MockRadarrService.createMockMovie(id: 3, title: "Movie 3")
        ]
        
        let movies = try await mockService.getMovies()
        #expect(movies.count == 3)
        #expect(movies[0].title == "Movie 1")
        #expect(movies[1].title == "Movie 2")
        #expect(movies[2].title == "Movie 3")
        #expect(mockService.getMoviesCallCount == 1)
    }
    
    @Test("Get movie by ID returns correct movie")
    func getMovieByID() async throws {
        // Setup mock data
        mockService.movies = [
            MockRadarrService.createMockMovie(id: 1, title: "Test Movie", monitored: true, hasFile: true)
        ]
        
        let movie = try await mockService.getMovie(id: 1)
        #expect(movie.id == 1)
        #expect(movie.title == "Test Movie")
        #expect(movie.monitored == true)
        #expect(movie.hasFile == true)
        #expect(mockService.getMovieCallCount == 1)
    }
    
    @Test("Get movie with non-existing ID throws not found error")
    func getMovieNotFound() async throws {
        mockService.movies = []
        
        await #expect(throws: ThriftwoodError.self) {
            _ = try await mockService.getMovie(id: 999)
        }
        #expect(mockService.getMovieCallCount == 1)
    }
    
    @Test("Search movies returns results")
    func searchMoviesSuccess() async throws {
        mockService.searchResults = [
            MockRadarrService.createMockMovie(id: 100, title: "The Matrix"),
            MockRadarrService.createMockMovie(id: 101, title: "The Matrix Reloaded")
        ]
        
        let results = try await mockService.searchMovies(query: "Matrix")
        #expect(results.count == 2)
        #expect(mockService.lastSearchQuery == "Matrix")
        #expect(mockService.searchMoviesCallCount == 1)
    }
    
    @Test("Search movies with no results returns empty list")
    func searchMoviesNoResults() async throws {
        mockService.searchResults = []
        
        let results = try await mockService.searchMovies(query: "NonexistentMovie")
        #expect(results.isEmpty)
        #expect(mockService.lastSearchQuery == "NonexistentMovie")
        #expect(mockService.searchMoviesCallCount == 1)
    }
    
    @Test("Add movie assigns ID and stores movie")
    func addMovieSuccess() async throws {
        let movieToAdd = MovieResource(
            id: nil,
            title: "New Movie",
            monitored: true
        )
        
        let addedMovie = try await mockService.addMovie(movieToAdd)
        
        #expect(addedMovie.id != nil)
        #expect(addedMovie.title == "New Movie")
        #expect(mockService.movies.count == 1)
        #expect(mockService.addMovieCallCount == 1)
        #expect(mockService.lastAddedMovie?.title == "New Movie")
    }
    
    @Test("Update movie modifies existing movie")
    func updateMovieSuccess() async throws {
        // Setup existing movie
        let originalMovie = MockRadarrService.createMockMovie(id: 1, title: "Original Title", monitored: false)
        mockService.movies = [originalMovie]
        
        // Update movie
        var updatedMovie = originalMovie
        updatedMovie.monitored = true
        
        let result = try await mockService.updateMovie(updatedMovie)
        
        #expect(result.id == 1)
        #expect(result.monitored == true)
        #expect(mockService.updateMovieCallCount == 1)
        #expect(mockService.lastUpdatedMovie?.id == 1)
        #expect(mockService.movies[0].monitored == true)
    }
    
    @Test("Delete movie removes from collection")
    func deleteMovieSuccess() async throws {
        mockService.movies = [
            MockRadarrService.createMockMovie(id: 1, title: "Movie 1"),
            MockRadarrService.createMockMovie(id: 2, title: "Movie 2")
        ]
        
        try await mockService.deleteMovie(id: 1, deleteFiles: true)
        
        #expect(mockService.movies.count == 1)
        #expect(mockService.movies[0].id == 2)
        #expect(mockService.deleteMovieCallCount == 1)
        #expect(mockService.lastDeletedMovieId == 1)
        #expect(mockService.lastDeletedMovieDeleteFiles == true)
    }
    
    @Test("Delete movie with deleteFiles parameter is tracked")
    func deleteMovieWithoutFiles() async throws {
        mockService.movies = [
            MockRadarrService.createMockMovie(id: 1, title: "Movie 1")
        ]
        
        try await mockService.deleteMovie(id: 1, deleteFiles: false)
        
        #expect(mockService.movies.isEmpty)
        #expect(mockService.lastDeletedMovieDeleteFiles == false)
    }
}

// MARK: - Configuration Resources Tests

@Suite("Radarr Service with Mock - Configuration Resources")
struct RadarrServiceConfigurationResourcesTests {
    
    var mockService: MockRadarrService
    
    init() {
        mockService = MockRadarrService()
    }
    
    @Test("Get quality profiles returns list")
    func getQualityProfilesSuccess() async throws {
        mockService.qualityProfiles = [
            MockRadarrService.createMockQualityProfile(id: 1, name: "HD-1080p"),
            MockRadarrService.createMockQualityProfile(id: 2, name: "Ultra-HD")
        ]
        
        let profiles = try await mockService.getQualityProfiles()
        
        #expect(profiles.count == 2)
        #expect(profiles[0].name == "HD-1080p")
        #expect(profiles[1].name == "Ultra-HD")
        #expect(mockService.getQualityProfilesCallCount == 1)
    }
    
    @Test("Get quality profiles returns empty list when none configured")
    func getQualityProfilesEmpty() async throws {
        mockService.qualityProfiles = []
        
        let profiles = try await mockService.getQualityProfiles()
        
        #expect(profiles.isEmpty)
        #expect(mockService.getQualityProfilesCallCount == 1)
    }
    
    @Test("Get root folders returns list")
    func getRootFoldersSuccess() async throws {
        mockService.rootFolders = [
            MockRadarrService.createMockRootFolder(id: 1, path: "/movies/library1"),
            MockRadarrService.createMockRootFolder(id: 2, path: "/movies/library2")
        ]
        
        let folders = try await mockService.getRootFolders()
        
        #expect(folders.count == 2)
        #expect(folders[0].path == "/movies/library1")
        #expect(folders[1].path == "/movies/library2")
        #expect(mockService.getRootFoldersCallCount == 1)
    }
    
    @Test("Get root folders returns empty list when none configured")
    func getRootFoldersEmpty() async throws {
        mockService.rootFolders = []
        
        let folders = try await mockService.getRootFolders()
        
        #expect(folders.isEmpty)
        #expect(mockService.getRootFoldersCallCount == 1)
    }
}

// MARK: - System Information Tests

@Suite("Radarr Service with Mock - System Information")
struct RadarrServiceSystemTests {
    
    var mockService: MockRadarrService
    
    init() {
        mockService = MockRadarrService()
    }
    
    @Test("Get system status returns status information")
    func getSystemStatusSuccess() async throws {
        mockService.systemStatus = MockRadarrService.createMockSystemStatus(version: "5.2.1")
        
        let status = try await mockService.getSystemStatus()
        
        #expect(status.version == "5.2.1")
        #expect(mockService.getSystemStatusCallCount == 1)
    }
    
    @Test("Get system status throws error when not available")
    func getSystemStatusNotAvailable() async throws {
        mockService.systemStatus = nil
        
        await #expect(throws: ThriftwoodError.self) {
            _ = try await mockService.getSystemStatus()
        }
        #expect(mockService.getSystemStatusCallCount == 1)
    }
    
    @Test("Test connection returns true on success")
    func testConnectionSuccess() async throws {
        let result = try await mockService.testConnection()
        
        #expect(result == true)
        #expect(mockService.testConnectionCallCount == 1)
    }
    
    @Test("Test connection throws error on failure")
    func testConnectionFailure() async throws {
        mockService.shouldThrowError = true
        mockService.errorToThrow = .networkError(URLError(.notConnectedToInternet))
        
        await #expect(throws: ThriftwoodError.self) {
            _ = try await mockService.testConnection()
        }
        #expect(mockService.testConnectionCallCount == 1)
    }
}

// MARK: - Error Handling Tests

@Suite("Radarr Service with Mock - Error Handling")
struct RadarrServiceErrorTests {
    
    var mockService: MockRadarrService
    
    init() {
        mockService = MockRadarrService()
    }
    
    @Test("Service throws authentication error when configured")
    func authenticationError() async throws {
        mockService.shouldThrowError = true
        mockService.errorToThrow = .authenticationRequired
        
        await #expect(throws: ThriftwoodError.self) {
            _ = try await mockService.getMovies()
        }
    }
    
    @Test("Service throws not found error when configured")
    func notFoundError() async throws {
        mockService.shouldThrowError = true
        mockService.errorToThrow = .notFound(message: "Resource not found")
        
        await #expect(throws: ThriftwoodError.self) {
            _ = try await mockService.getMovies()
        }
    }
    
    @Test("Service throws service unavailable error when configured")
    func serviceUnavailableError() async throws {
        mockService.shouldThrowError = true
        mockService.errorToThrow = .serviceUnavailable
        
        await #expect(throws: ThriftwoodError.self) {
            _ = try await mockService.getMovies()
        }
    }
    
    @Test("Service throws network error when configured")
    func networkError() async throws {
        mockService.shouldThrowError = true
        mockService.errorToThrow = .networkError(URLError(.timedOut))
        
        await #expect(throws: ThriftwoodError.self) {
            _ = try await mockService.getMovies()
        }
    }
    
    @Test("Service throws API error when configured")
    func apiError() async throws {
        mockService.shouldThrowError = true
        mockService.errorToThrow = .apiError(statusCode: 400, message: "Bad Request")
        
        await #expect(throws: ThriftwoodError.self) {
            _ = try await mockService.getMovies()
        }
    }
    
    @Test("Error persists across multiple calls until reset")
    func errorPersistence() async throws {
        mockService.shouldThrowError = true
        mockService.errorToThrow = .serviceUnavailable
        
        // First call should throw
        await #expect(throws: ThriftwoodError.self) {
            _ = try await mockService.getMovies()
        }
        
        // Second call should also throw
        await #expect(throws: ThriftwoodError.self) {
            _ = try await mockService.getMovies()
        }
        
        #expect(mockService.getMoviesCallCount == 2)
    }
}

// MARK: - Concurrent Operations Tests

@Suite("Radarr Service with Mock - Concurrent Operations")
struct RadarrServiceConcurrencyTests {
    
    var mockService: MockRadarrService
    
    init() {
        mockService = MockRadarrService()
    }
    
    @Test("Multiple concurrent getMovies calls succeed")
    func concurrentGetMovies() async throws {
        mockService.movies = [
            MockRadarrService.createMockMovie(id: 1, title: "Movie 1"),
            MockRadarrService.createMockMovie(id: 2, title: "Movie 2")
        ]
        
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<5 {
                group.addTask {
                    do {
                        let movies = try await self.mockService.getMovies()
                        #expect(movies.count == 2)
                    } catch {
                        Issue.record("Concurrent call failed: \(error)")
                    }
                }
            }
        }
        
        #expect(mockService.getMoviesCallCount == 5)
    }
    
    @Test("Concurrent operations on different methods succeed")
    func concurrentDifferentMethods() async throws {
        mockService.movies = [MockRadarrService.createMockMovie(id: 1, title: "Movie 1")]
        mockService.qualityProfiles = [MockRadarrService.createMockQualityProfile(id: 1, name: "HD")]
        mockService.rootFolders = [MockRadarrService.createMockRootFolder(id: 1, path: "/movies")]
        mockService.systemStatus = MockRadarrService.createMockSystemStatus()
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                do {
                    _ = try await self.mockService.getMovies()
                } catch {
                    Issue.record("getMovies failed: \(error)")
                }
            }
            
            group.addTask {
                do {
                    _ = try await self.mockService.getQualityProfiles()
                } catch {
                    Issue.record("getQualityProfiles failed: \(error)")
                }
            }
            
            group.addTask {
                do {
                    _ = try await self.mockService.getRootFolders()
                } catch {
                    Issue.record("getRootFolders failed: \(error)")
                }
            }
            
            group.addTask {
                do {
                    _ = try await self.mockService.getSystemStatus()
                } catch {
                    Issue.record("getSystemStatus failed: \(error)")
                }
            }
        }
        
        #expect(mockService.getMoviesCallCount == 1)
        #expect(mockService.getQualityProfilesCallCount == 1)
        #expect(mockService.getRootFoldersCallCount == 1)
        #expect(mockService.getSystemStatusCallCount == 1)
    }
}

// MARK: - Call Tracking Tests

@Suite("Radarr Service with Mock - Call Tracking")
struct RadarrServiceCallTrackingTests {
    
    var mockService: MockRadarrService
    
    init() {
        mockService = MockRadarrService()
    }
    
    @Test("Mock service tracks configuration calls")
    func trackConfigurationCalls() async throws {
        #expect(mockService.configureCallCount == 0)
        
        try await mockService.configure(baseURL: URL(string: "https://test.com")!, apiKey: "key")
        
        #expect(mockService.configureCallCount == 1)
        #expect(mockService.configuredBaseURL?.absoluteString == "https://test.com")
        #expect(mockService.configuredApiKey == "key")
    }
    
    @Test("Mock service reset clears all state")
    func resetClearsState() async throws {
        // Setup state
        mockService.movies = [MockRadarrService.createMockMovie(id: 1, title: "Movie")]
        mockService.shouldThrowError = true
        try await mockService.configure(baseURL: URL(string: "https://test.com")!, apiKey: "key")
        _ = try? await mockService.getMovies()
        
        // Verify state exists
        #expect(mockService.configureCallCount == 1)
        #expect(mockService.getMoviesCallCount == 1)
        #expect(!mockService.movies.isEmpty)
        
        // Reset
        mockService.reset()
        
        // Verify state cleared
        #expect(mockService.configureCallCount == 0)
        #expect(mockService.getMoviesCallCount == 0)
        #expect(mockService.movies.isEmpty)
        #expect(mockService.shouldThrowError == false)
        #expect(mockService.configuredBaseURL == nil)
    }
}
