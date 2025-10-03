//
//  LoggerTests.swift
//  ThriftwoodTests
//
//  Unit tests for logging framework
//

import XCTest
@testable import Thriftwood

final class LoggerTests: XCTestCase {
    
    // MARK: - Logger Creation Tests
    
    func testCreateLoggerWithCategory() {
        // Given/When
        let logger = AppLogger(category: .networking)
        
        // Then - Should not crash
        XCTAssertNotNil(logger)
    }
    
    func testConvenienceLoggers() {
        // Given/When/Then - Should not crash
        XCTAssertNotNil(AppLogger.networking)
        XCTAssertNotNil(AppLogger.storage)
        XCTAssertNotNil(AppLogger.authentication)
        XCTAssertNotNil(AppLogger.ui)
        XCTAssertNotNil(AppLogger.services)
        XCTAssertNotNil(AppLogger.general)
    }
    
    // MARK: - Logging Method Tests
    
    func testDebugLogging() {
        // Given
        let logger = AppLogger(category: .general)
        
        // When/Then - Should not crash
        XCTAssertNoThrow(logger.debug("Test debug message"))
    }
    
    func testInfoLogging() {
        // Given
        let logger = AppLogger(category: .general)
        
        // When/Then - Should not crash
        XCTAssertNoThrow(logger.info("Test info message"))
    }
    
    func testWarningLogging() {
        // Given
        let logger = AppLogger(category: .general)
        
        // When/Then - Should not crash
        XCTAssertNoThrow(logger.warning("Test warning message"))
    }
    
    func testErrorLogging() {
        // Given
        let logger = AppLogger(category: .general)
        
        // When/Then - Should not crash
        XCTAssertNoThrow(logger.error("Test error message"))
    }
    
    func testErrorLoggingWithError() {
        // Given
        let logger = AppLogger(category: .general)
        let error = ThriftwoodError.serviceUnavailable
        
        // When/Then - Should not crash
        XCTAssertNoThrow(logger.error("Test error with object", error: error))
    }
    
    func testCriticalLogging() {
        // Given
        let logger = AppLogger(category: .general)
        
        // When/Then - Should not crash
        XCTAssertNoThrow(logger.critical("Test critical message"))
    }
    
    func testCriticalLoggingWithError() {
        // Given
        let logger = AppLogger(category: .general)
        let error = ThriftwoodError.authenticationRequired
        
        // When/Then - Should not crash
        XCTAssertNoThrow(logger.critical("Test critical with object", error: error))
    }
    
    // MARK: - Privacy Tests
    
    func testPrivateDataLogging() {
        // Given
        let logger = AppLogger(category: .authentication)
        
        // When/Then - Should not crash
        XCTAssertNoThrow(logger.logPrivate("User logged in", privateData: "user@example.com"))
    }
    
    func testAPIRequestLogging() {
        // Given
        let logger = AppLogger.networking
        
        // When/Then - Should not crash
        XCTAssertNoThrow(logger.logAPIRequest(method: "GET", path: "/api/v3/movie"))
        XCTAssertNoThrow(logger.logAPIRequest(method: "POST", path: "/api/v3/movie", statusCode: 200))
    }
    
    // MARK: - Category Tests
    
    func testAllCategories() {
        // Given
        let categories: [LogCategory] = [.networking, .storage, .authentication, .ui, .services, .general]
        
        // When/Then - All categories should be accessible
        for category in categories {
            let logger = AppLogger(category: category)
            XCTAssertNotNil(logger)
            XCTAssertNoThrow(logger.info("Test message for \(category.rawValue)"))
        }
    }
}
