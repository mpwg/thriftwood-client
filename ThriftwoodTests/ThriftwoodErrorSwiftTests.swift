//
//  ThriftwoodErrorSwiftTests.swift
//  ThriftwoodTests
//
//  Unit tests for error handling using Swift Testing
//

import Testing
import Foundation
@testable import Thriftwood

@Suite("Thriftwood Error Tests")
struct ThriftwoodErrorSwiftTests {
    
    // MARK: - Error Description Tests
    
    @Test("Network error has proper description")
    func networkErrorDescription() {
        // Given
        let urlError = URLError(.timedOut)
        let error = ThriftwoodError.networkError(urlError)
        
        // When
        let description = error.errorDescription
        
        // Then
        #expect(description != nil)
        #expect(description?.contains("Network error") == true)
    }
    
    @Test("API error includes status code and message")
    func apiErrorDescription() {
        // Given
        let error = ThriftwoodError.apiError(statusCode: 404, message: "Not Found")
        
        // When
        let description = error.errorDescription
        
        // Then
        #expect(description != nil)
        #expect(description?.contains("404") == true)
        #expect(description?.contains("Not Found") == true)
    }
    
    @Test("Authentication required error has proper description")
    func authenticationRequiredDescription() {
        // Given
        let error = ThriftwoodError.authenticationRequired
        
        // When
        let description = error.errorDescription
        
        // Then
        #expect(description != nil)
        #expect(description?.contains("Authentication") == true)
    }
    
    @Test("Invalid configuration error includes details")
    func invalidConfigurationDescription() {
        // Given
        let error = ThriftwoodError.invalidConfiguration("Missing API key")
        
        // When
        let description = error.errorDescription
        
        // Then
        #expect(description != nil)
        #expect(description?.contains("Missing API key") == true)
    }
    
    // MARK: - Recovery Suggestion Tests
    
    @Test("Network error provides recovery suggestion")
    func networkErrorRecoverySuggestion() {
        // Given
        let urlError = URLError(.notConnectedToInternet)
        let error = ThriftwoodError.networkError(urlError)
        
        // When
        let suggestion = error.recoverySuggestion
        
        // Then
        #expect(suggestion != nil)
        #expect(suggestion?.contains("internet") == true)
    }
    
    @Test("Authentication error provides recovery suggestion")
    func authenticationRequiredRecoverySuggestion() {
        // Given
        let error = ThriftwoodError.authenticationRequired
        
        // When
        let suggestion = error.recoverySuggestion
        
        // Then
        #expect(suggestion != nil)
        let containsCredentials = suggestion?.contains("credentials") == true
        let containsAPIKey = suggestion?.contains("API key") == true
        #expect(containsCredentials || containsAPIKey)
    }
    
    // MARK: - Retry Logic Tests
    
    @Test("Timeout error is retryable")
    func timeoutErrorIsRetryable() {
        // Given
        let urlError = URLError(.timedOut)
        let error = ThriftwoodError.networkError(urlError)
        
        // Then
        #expect(error.isRetryable)
    }
    
    @Test("Network connection lost is retryable")
    func networkConnectionLostIsRetryable() {
        // Given
        let urlError = URLError(.networkConnectionLost)
        let error = ThriftwoodError.networkError(urlError)
        
        // Then
        #expect(error.isRetryable)
    }
    
    @Test("Server error 503 is retryable")
    func serverErrorIsRetryable() {
        // Given
        let error = ThriftwoodError.apiError(statusCode: 503, message: "Service Unavailable")
        
        // Then
        #expect(error.isRetryable)
    }
    
    @Test("Authentication error is not retryable")
    func authenticationErrorIsNotRetryable() {
        // Given
        let error = ThriftwoodError.authenticationRequired
        
        // Then
        #expect(!error.isRetryable)
    }
    
    @Test("Client error 400 is not retryable")
    func clientErrorIsNotRetryable() {
        // Given
        let error = ThriftwoodError.apiError(statusCode: 400, message: "Bad Request")
        
        // Then
        #expect(!error.isRetryable)
    }
    
    // MARK: - Error Conversion Tests
    
    @Test("Convert Thriftwood error preserves type")
    func convertThriftwoodError() {
        // Given
        let originalError = ThriftwoodError.serviceUnavailable
        
        // When
        let convertedError = ThriftwoodError.from(originalError)
        
        // Then
        guard case .serviceUnavailable = convertedError else {
            Issue.record("Expected serviceUnavailable error")
            return
        }
    }
    
    @Test("Convert URLError to network error")
    func convertURLError() {
        // Given
        let originalError = URLError(.badURL)
        
        // When
        let convertedError = ThriftwoodError.from(originalError)
        
        // Then
        guard case .networkError(let urlError) = convertedError else {
            Issue.record("Expected networkError")
            return
        }
        #expect(urlError.code == .badURL)
    }
    
    @Test("Convert DecodingError")
    func convertDecodingError() {
        // Given
        let originalError = DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Test"))
        
        // When
        let convertedError = ThriftwoodError.from(originalError)
        
        // Then
        guard case .decodingError = convertedError else {
            Issue.record("Expected decodingError")
            return
        }
    }
    
    @Test("Convert unknown error")
    func convertUnknownError() {
        // Given
        struct CustomError: Error {}
        let originalError = CustomError()
        
        // When
        let convertedError = ThriftwoodError.from(originalError)
        
        // Then
        guard case .unknown = convertedError else {
            Issue.record("Expected unknown error")
            return
        }
    }
}
