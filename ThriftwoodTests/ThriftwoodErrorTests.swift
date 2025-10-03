//
//  ThriftwoodErrorTests.swift
//  ThriftwoodTests
//
//  Unit tests for error handling
//

import XCTest
@testable import Thriftwood

final class ThriftwoodErrorTests: XCTestCase {
    
    // MARK: - Error Description Tests
    
    func testNetworkErrorDescription() {
        // Given
        let urlError = URLError(.timedOut)
        let error = ThriftwoodError.networkError(urlError)
        
        // When
        let description = error.errorDescription
        
        // Then
        XCTAssertNotNil(description)
        XCTAssertTrue(description?.contains("Network error") ?? false)
    }
    
    func testAPIErrorDescription() {
        // Given
        let error = ThriftwoodError.apiError(statusCode: 404, message: "Not Found")
        
        // When
        let description = error.errorDescription
        
        // Then
        XCTAssertNotNil(description)
        XCTAssertTrue(description?.contains("404") ?? false)
        XCTAssertTrue(description?.contains("Not Found") ?? false)
    }
    
    func testAuthenticationRequiredDescription() {
        // Given
        let error = ThriftwoodError.authenticationRequired
        
        // When
        let description = error.errorDescription
        
        // Then
        XCTAssertNotNil(description)
        XCTAssertTrue(description?.contains("Authentication") ?? false)
    }
    
    func testInvalidConfigurationDescription() {
        // Given
        let error = ThriftwoodError.invalidConfiguration("Missing API key")
        
        // When
        let description = error.errorDescription
        
        // Then
        XCTAssertNotNil(description)
        XCTAssertTrue(description?.contains("Missing API key") ?? false)
    }
    
    // MARK: - Recovery Suggestion Tests
    
    func testNetworkErrorRecoverySuggestion() {
        // Given
        let urlError = URLError(.notConnectedToInternet)
        let error = ThriftwoodError.networkError(urlError)
        
        // When
        let suggestion = error.recoverySuggestion
        
        // Then
        XCTAssertNotNil(suggestion)
        XCTAssertTrue(suggestion?.contains("internet") ?? false)
    }
    
    func testAuthenticationRequiredRecoverySuggestion() {
        // Given
        let error = ThriftwoodError.authenticationRequired
        
        // When
        let suggestion = error.recoverySuggestion
        
        // Then
        XCTAssertNotNil(suggestion)
        XCTAssertTrue(suggestion?.contains("credentials") ?? false || suggestion?.contains("API key") ?? false)
    }
    
    // MARK: - Retry Logic Tests
    
    func testTimeoutErrorIsRetryable() {
        // Given
        let urlError = URLError(.timedOut)
        let error = ThriftwoodError.networkError(urlError)
        
        // Then
        XCTAssertTrue(error.isRetryable)
    }
    
    func testNetworkConnectionLostIsRetryable() {
        // Given
        let urlError = URLError(.networkConnectionLost)
        let error = ThriftwoodError.networkError(urlError)
        
        // Then
        XCTAssertTrue(error.isRetryable)
    }
    
    func testServerErrorIsRetryable() {
        // Given
        let error = ThriftwoodError.apiError(statusCode: 503, message: "Service Unavailable")
        
        // Then
        XCTAssertTrue(error.isRetryable)
    }
    
    func testAuthenticationErrorIsNotRetryable() {
        // Given
        let error = ThriftwoodError.authenticationRequired
        
        // Then
        XCTAssertFalse(error.isRetryable)
    }
    
    func testClientErrorIsNotRetryable() {
        // Given
        let error = ThriftwoodError.apiError(statusCode: 400, message: "Bad Request")
        
        // Then
        XCTAssertFalse(error.isRetryable)
    }
    
    // MARK: - Error Conversion Tests
    
    func testConvertThriftwoodError() {
        // Given
        let originalError = ThriftwoodError.serviceUnavailable
        
        // When
        let convertedError = ThriftwoodError.from(originalError)
        
        // Then
        if case .serviceUnavailable = convertedError {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected serviceUnavailable error")
        }
    }
    
    func testConvertURLError() {
        // Given
        let originalError = URLError(.badURL)
        
        // When
        let convertedError = ThriftwoodError.from(originalError)
        
        // Then
        if case .networkError(let urlError) = convertedError {
            XCTAssertEqual(urlError.code, .badURL)
        } else {
            XCTFail("Expected networkError")
        }
    }
    
    func testConvertDecodingError() {
        // Given
        let originalError = DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Test"))
        
        // When
        let convertedError = ThriftwoodError.from(originalError)
        
        // Then
        if case .decodingError = convertedError {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected decodingError")
        }
    }
    
    func testConvertUnknownError() {
        // Given
        struct CustomError: Error {}
        let originalError = CustomError()
        
        // When
        let convertedError = ThriftwoodError.from(originalError)
        
        // Then
        if case .unknown = convertedError {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected unknown error")
        }
    }
}
