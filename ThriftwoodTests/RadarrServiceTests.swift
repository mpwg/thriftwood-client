//
//  RadarrServiceTests.swift
//  Thriftwood
//
//  Unit tests for RadarrService using OpenAPI models directly
//

import Testing
import Foundation
@testable import Thriftwood
import RadarrAPI

@Suite("Radarr Service Tests")
struct RadarrServiceTests {
    
    let testBaseURL = URL(string: "https://radarr.example.com")!
    let testAPIKey = "test-api-key-12345"
    
    @MainActor
    @Test("Configure service with valid parameters")
    func configureServiceSuccess() async throws {
        let service = RadarrService()
        try await service.configure(baseURL: testBaseURL, apiKey: testAPIKey)
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
