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

// MARK: - Future Tests

// TODO: Add tests that use MockRadarrService to test ViewModels
// Example: MovieViewModel tests that verify:
// - ViewModel loads movies on appear using the service
// - ViewModel handles errors from the service
// - ViewModel filters/searches movies correctly
// - Coordinator navigation when selecting a movie

// TODO: Add tests for actual Radarr API integration
// These should test real RadarrService with mocked HTTP layer
// Example: Test that API requests are formed correctly, parsed correctly
