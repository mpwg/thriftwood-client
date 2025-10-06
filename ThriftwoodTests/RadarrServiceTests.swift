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
//
//  RadarrServiceTests.swift
//  ThriftwoodTests
//
//  Unit tests for RadarrService using Swift Testing
//

import Testing
import Foundation
@testable import Thriftwood

@Suite("Radarr Service Tests")
struct RadarrServiceTests {
    
    // MARK: - Test Data
    
    let testBaseURL = URL(string: "https://radarr.example.com")!
    let testAPIKey = "test-api-key-12345"
    
    // MARK: - Configuration Tests
    
    @MainActor
    @Test("Configure service with valid parameters")
    func configureServiceSuccess() async throws {
        // Given
        let service = RadarrService()
        
        // When
        try await service.configure(baseURL: testBaseURL, apiKey: testAPIKey)
        
        // Then - no error thrown, configuration stored
        // Note: We can't directly verify internal state, but testConnection will validate
    }
    
    @MainActor
    @Test("Configure service with invalid URL scheme throws error")
    func configureServiceInvalidURL() async throws {
        // Given
        let service = RadarrService()
        let invalidURL = URL(string: "ftp://radarr.example.com")!
        
        // When/Then
        await #expect(throws: ThriftwoodError.self) {
            try await service.configure(baseURL: invalidURL, apiKey: testAPIKey)
        }
    }
    
    @MainActor
    @Test("Configure service with empty API key throws error")
    func configureServiceEmptyAPIKey() async throws {
        // Given
        let service = RadarrService()
        
        // When/Then
        await #expect(throws: ThriftwoodError.self) {
            try await service.configure(baseURL: testBaseURL, apiKey: "")
        }
    }
    
    // MARK: - Error Handling Tests
    
    @MainActor
    @Test("Unconfigured service throws invalidConfiguration error")
    func unconfiguredServiceThrowsError() async throws {
        // Given
        let service = RadarrService()
        
        // When/Then - attempt to use service without configuration
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
    
    @MainActor
    @Test("Search with empty query throws validation error")
    func searchEmptyQueryThrowsError() async throws {
        // Given
        let service = RadarrService()
        try await service.configure(baseURL: testBaseURL, apiKey: testAPIKey)
        
        // When/Then
        do {
            _ = try await service.searchMovies(query: "")
            Issue.record("Expected validation error but got success")
        } catch let error as ThriftwoodError {
            guard case .validation = error else {
                Issue.record("Expected validation error, got \(error)")
                return
            }
        }
    }
    
    // MARK: - Model Tests
    
    @MainActor
    @Test("Movie model initialization with all fields")
    func movieModelInitialization() {
        // Given
        let releaseDate = Date()
        let posterURL = URL(string: "https://example.com/poster.jpg")
        
        // When
        let movie = Movie(
            id: 123,
            title: "Test Movie",
            overview: "A test movie overview",
            releaseDate: releaseDate,
            posterURL: posterURL,
            year: 2025,
            tmdbId: 456,
            imdbId: "tt1234567",
            hasFile: true,
            monitored: true,
            qualityProfileId: 1,
            rootFolderPath: "/movies",
            sizeOnDisk: 1024 * 1024 * 1024,
            status: .released,
            genres: ["Action", "Thriller"],
            runtime: 120,
            certification: "PG-13"
        )
        
        // Then
        #expect(movie.id == 123)
        #expect(movie.title == "Test Movie")
        #expect(movie.overview == "A test movie overview")
        #expect(movie.releaseDate == releaseDate)
        #expect(movie.posterURL == posterURL)
        #expect(movie.year == 2025)
        #expect(movie.tmdbId == 456)
        #expect(movie.imdbId == "tt1234567")
        #expect(movie.hasFile == true)
        #expect(movie.monitored == true)
        #expect(movie.qualityProfileId == 1)
        #expect(movie.rootFolderPath == "/movies")
        #expect(movie.sizeOnDisk == 1024 * 1024 * 1024)
        #expect(movie.status == .released)
        #expect(movie.genres == ["Action", "Thriller"])
        #expect(movie.runtime == 120)
        #expect(movie.certification == "PG-13")
    }
    
    @Test("Movie model conforms to MediaItem protocol")
    func movieConformsToMediaItem() {
        // Given
        let movie = Movie(
            id: 123,
            title: "Test Movie",
            overview: "Overview",
            releaseDate: Date(),
            posterURL: URL(string: "https://example.com/poster.jpg")
        )
        
        // When
        let mediaItem: any MediaItem = movie
        
        // Then
        #expect(mediaItem.id == 123)
        #expect(mediaItem.title == "Test Movie")
        #expect(mediaItem.overview == "Overview")
        #expect(mediaItem.releaseDate != nil)
        #expect(mediaItem.posterURL != nil)
    }
    
    @Test("MovieSearchResult initialization")
    func movieSearchResultInitialization() {
        // Given/When
        let searchResult = MovieSearchResult(
            id: 456,
            title: "Search Result Movie",
            overview: "A search result",
            year: 2024,
            tmdbId: 789,
            imdbId: "tt9876543",
            posterURL: URL(string: "https://example.com/poster.jpg"),
            isExisting: true
        )
        
        // Then
        #expect(searchResult.id == 456)
        #expect(searchResult.title == "Search Result Movie")
        #expect(searchResult.overview == "A search result")
        #expect(searchResult.year == 2024)
        #expect(searchResult.tmdbId == 789)
        #expect(searchResult.imdbId == "tt9876543")
        #expect(searchResult.posterURL?.absoluteString == "https://example.com/poster.jpg")
        #expect(searchResult.isExisting == true)
    }
    
    @Test("AddMovieRequest initialization")
    func addMovieRequestInitialization() {
        // Given/When
        let request = AddMovieRequest(
            tmdbId: 123,
            title: "New Movie",
            year: 2025,
            qualityProfileId: 1,
            rootFolderPath: "/movies",
            monitored: true,
            searchForMovie: true,
            minimumAvailability: .announced
        )
        
        // Then
        #expect(request.tmdbId == 123)
        #expect(request.title == "New Movie")
        #expect(request.year == 2025)
        #expect(request.qualityProfileId == 1)
        #expect(request.rootFolderPath == "/movies")
        #expect(request.monitored == true)
        #expect(request.searchForMovie == true)
        #expect(request.minimumAvailability == .announced)
    }
    
    @Test("QualityProfile initialization")
    func qualityProfileInitialization() {
        // Given/When
        let profile = QualityProfile(
            id: 1,
            name: "HD-1080p",
            upgradeAllowed: true,
            cutoff: 5
        )
        
        // Then
        #expect(profile.id == 1)
        #expect(profile.name == "HD-1080p")
        #expect(profile.upgradeAllowed == true)
        #expect(profile.cutoff == 5)
    }
    
    @Test("RootFolder initialization")
    func rootFolderInitialization() {
        // Given/When
        let rootFolder = RootFolder(
            id: 1,
            path: "/movies",
            accessible: true,
            freeSpace: 500 * 1024 * 1024 * 1024, // 500GB
            totalSpace: 1000 * 1024 * 1024 * 1024 // 1TB
        )
        
        // Then
        #expect(rootFolder.id == 1)
        #expect(rootFolder.path == "/movies")
        #expect(rootFolder.accessible == true)
        #expect(rootFolder.freeSpace == 500 * 1024 * 1024 * 1024)
        #expect(rootFolder.totalSpace == 1000 * 1024 * 1024 * 1024)
    }
    
    @Test("SystemStatus initialization")
    func systemStatusInitialization() {
        // Given/When
        let status = SystemStatus(
            version: "3.2.2.5080",
            buildTime: Date(),
            isDebug: false,
            isProduction: true,
            isAdmin: true,
            isUserInteractive: false,
            startupPath: "/app/radarr",
            appData: "/config",
            osName: "ubuntu",
            osVersion: "20.04",
            isMonoRuntime: false,
            isMono: false,
            isLinux: true,
            isOsx: false,
            isWindows: false,
            branch: "master",
            authentication: "forms",
            sqliteVersion: "3.32.1",
            urlBase: "/radarr",
            runtimeVersion: "5.0.0",
            runtimeName: ".NET"
        )
        
        // Then
        #expect(status.version == "3.2.2.5080")
        #expect(status.isProduction == true)
        #expect(status.isLinux == true)
        #expect(status.authentication == "forms")
        #expect(status.urlBase == "/radarr")
    }
    
    @Test("MovieStatus enum values")
    func movieStatusEnumValues() {
        // Given/When/Then
        #expect(MovieStatus.tba.rawValue == "tba")
        #expect(MovieStatus.announced.rawValue == "announced")
        #expect(MovieStatus.inCinemas.rawValue == "inCinemas")
        #expect(MovieStatus.released.rawValue == "released")
        #expect(MovieStatus.deleted.rawValue == "deleted")
    }
    
    // MARK: - Sendable Conformance Tests
    
    @Test("Movie is Sendable")
    func movieIsSendable() {
        // Verify at compile time that Movie conforms to Sendable
        let movie = Movie(id: 1, title: "Test")
        let _: any Sendable = movie
    }
    
    @Test("MovieSearchResult is Sendable")
    func movieSearchResultIsSendable() {
        // Verify at compile time that MovieSearchResult conforms to Sendable
        let result = MovieSearchResult(id: 1, title: "Test")
        let _: any Sendable = result
    }
    
    @Test("AddMovieRequest is Sendable")
    func addMovieRequestIsSendable() {
        // Verify at compile time that AddMovieRequest conforms to Sendable
        let request = AddMovieRequest(tmdbId: 1, title: "Test", qualityProfileId: 1, rootFolderPath: "/movies")
        let _: any Sendable = request
    }
    
    @Test("RadarrServiceProtocol is Sendable")
    func radarrServiceProtocolIsSendable() async throws {
        // Verify at compile time that RadarrService conforms to Sendable
        let service: any Sendable = RadarrService()
        #expect(service is any RadarrServiceProtocol)
    }
}
