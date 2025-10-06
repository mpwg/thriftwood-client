//
//  MockRadarrService.swift
//  ThriftwoodTests
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

import Foundation
import RadarrAPI
@testable import Thriftwood

/// Mock implementation of RadarrServiceProtocol for testing
/// 
/// **CRITICAL**: This class is NOT thread-safe and should NOT be shared between tests.
/// Each test MUST create its own instance via `MockRadarrService()` or a factory method.
/// Sharing instances between tests will cause data races and test failures.
///
/// The `@unchecked Sendable` conformance is used because:
/// 1. Tests create isolated instances that are not shared
/// 2. Swift Testing may run tests in parallel, requiring Sendable conformance
/// 3. The responsibility for thread-safety is on the test author, not this mock
final class MockRadarrService: RadarrServiceProtocol, @unchecked Sendable {
    
    // MARK: - Mock Configuration
    
    var shouldThrowError: Bool = false
    var errorToThrow: ThriftwoodError = .serviceUnavailable
    
    // MARK: - Mock Data Storage
    
    var configuredBaseURL: URL?
    var configuredApiKey: String?
    var movies: [MovieResource] = []
    var qualityProfiles: [QualityProfileResource] = []
    var rootFolders: [RootFolderResource] = []
    var systemStatus: SystemResource?
    var searchResults: [MovieResource] = []
    
    // MARK: - Call Tracking
    
    var configureCallCount: Int = 0
    var getMoviesCallCount: Int = 0
    var getMovieCallCount: Int = 0
    var searchMoviesCallCount: Int = 0
    var addMovieCallCount: Int = 0
    var updateMovieCallCount: Int = 0
    var deleteMovieCallCount: Int = 0
    var getQualityProfilesCallCount: Int = 0
    var getRootFoldersCallCount: Int = 0
    var getSystemStatusCallCount: Int = 0
    var testConnectionCallCount: Int = 0
    
    var lastDeletedMovieId: Int?
    var lastDeletedMovieDeleteFiles: Bool?
    var lastAddedMovie: MovieResource?
    var lastUpdatedMovie: MovieResource?
    var lastSearchQuery: String?
    
    // MARK: - RadarrServiceProtocol Implementation
    
    func configure(baseURL: URL, apiKey: String) async throws {
        configureCallCount += 1
        if shouldThrowError {
            throw errorToThrow
        }
        configuredBaseURL = baseURL
        configuredApiKey = apiKey
    }
    
    func getMovies() async throws -> [MovieResource] {
        getMoviesCallCount += 1
        if shouldThrowError {
            throw errorToThrow
        }
        return movies
    }
    
    func getMovie(id: Int) async throws -> MovieResource {
        getMovieCallCount += 1
        if shouldThrowError {
            throw errorToThrow
        }
        guard let movie = movies.first(where: { $0.id == id }) else {
            throw ThriftwoodError.notFound(message: "Movie not found")
        }
        return movie
    }
    
    func searchMovies(query: String) async throws -> [MovieResource] {
        searchMoviesCallCount += 1
        lastSearchQuery = query
        if shouldThrowError {
            throw errorToThrow
        }
        return searchResults
    }
    
    func addMovie(_ movie: MovieResource) async throws -> MovieResource {
        addMovieCallCount += 1
        lastAddedMovie = movie
        if shouldThrowError {
            throw errorToThrow
        }
        var addedMovie = movie
        addedMovie.id = Int.random(in: 1000...9999)
        movies.append(addedMovie)
        return addedMovie
    }
    
    func updateMovie(_ movie: MovieResource) async throws -> MovieResource {
        updateMovieCallCount += 1
        lastUpdatedMovie = movie
        if shouldThrowError {
            throw errorToThrow
        }
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index] = movie
        }
        return movie
    }
    
    func deleteMovie(id: Int, deleteFiles: Bool) async throws {
        deleteMovieCallCount += 1
        lastDeletedMovieId = id
        lastDeletedMovieDeleteFiles = deleteFiles
        if shouldThrowError {
            throw errorToThrow
        }
        movies.removeAll { $0.id == id }
    }
    
    func getQualityProfiles() async throws -> [QualityProfileResource] {
        getQualityProfilesCallCount += 1
        if shouldThrowError {
            throw errorToThrow
        }
        return qualityProfiles
    }
    
    func getRootFolders() async throws -> [RootFolderResource] {
        getRootFoldersCallCount += 1
        if shouldThrowError {
            throw errorToThrow
        }
        return rootFolders
    }
    
    func getSystemStatus() async throws -> SystemResource {
        getSystemStatusCallCount += 1
        if shouldThrowError {
            throw errorToThrow
        }
        guard let status = systemStatus else {
            throw ThriftwoodError.notFound(message: "System status not found")
        }
        return status
    }
    
    func testConnection() async throws -> Bool {
        testConnectionCallCount += 1
        if shouldThrowError {
            throw errorToThrow
        }
        return true
    }
    
    // MARK: - Test Helpers
    
    func reset() {
        shouldThrowError = false
        errorToThrow = .serviceUnavailable
        configuredBaseURL = nil
        configuredApiKey = nil
        movies = []
        qualityProfiles = []
        rootFolders = []
        systemStatus = nil
        searchResults = []
        configureCallCount = 0
        getMoviesCallCount = 0
        getMovieCallCount = 0
        searchMoviesCallCount = 0
        addMovieCallCount = 0
        updateMovieCallCount = 0
        deleteMovieCallCount = 0
        getQualityProfilesCallCount = 0
        getRootFoldersCallCount = 0
        getSystemStatusCallCount = 0
        testConnectionCallCount = 0
        lastDeletedMovieId = nil
        lastDeletedMovieDeleteFiles = nil
        lastAddedMovie = nil
        lastUpdatedMovie = nil
        lastSearchQuery = nil
    }
}

// MARK: - Test Data Factories

extension MockRadarrService {
    static func createMockMovie(id: Int, title: String, monitored: Bool = true, hasFile: Bool = false) -> MovieResource {
        MovieResource(
            id: id,
            title: title,
            hasFile: hasFile,
            monitored: monitored
        )
    }
    
    static func createMockQualityProfile(id: Int, name: String) -> QualityProfileResource {
        QualityProfileResource(
            id: id,
            name: name
        )
    }
    
    static func createMockRootFolder(id: Int, path: String) -> RootFolderResource {
        RootFolderResource(
            id: id,
            path: path
        )
    }
    
    static func createMockSystemStatus(version: String = "5.0.0") -> SystemResource {
        SystemResource(
            version: version
        )
    }
}
