//
//  LoggerSwiftTests.swift
//  ThriftwoodTests
//
//  Unit tests for logging framework using Swift Testing
//

import Testing
@testable import Thriftwood

@Suite("Logger Tests")
struct LoggerSwiftTests {
    
    // MARK: - Logger Creation Tests
    
    @Test("Create logger with specific category")
    func createLoggerWithCategory() {
        // Given/When
        _ = AppLogger(category: .networking)
        
        // Then - Logger creation should succeed (no crash)
        #expect(Bool(true))
    }
    
    @Test("Convenience loggers are accessible")
    func convenienceLoggers() {
        // Given/When
        _ = AppLogger.networking
        _ = AppLogger.storage
        _ = AppLogger.authentication
        _ = AppLogger.ui
        _ = AppLogger.services
        _ = AppLogger.general
        
        // Then - All convenience loggers should be accessible (no crash)
        #expect(Bool(true))
    }
    
    // MARK: - Logging Method Tests
    
    @Test("Debug logging does not crash")
    func debugLogging() {
        // Given
        let logger = AppLogger(category: .general)
        
        // When/Then - Should not crash
        logger.debug("Test debug message")
        #expect(Bool(true)) // Test completed without crashing
    }
    
    @Test("Info logging does not crash")
    func infoLogging() {
        // Given
        let logger = AppLogger(category: .general)
        
        // When/Then - Should not crash
        logger.info("Test info message")
        #expect(Bool(true))
    }
    
    @Test("Warning logging does not crash")
    func warningLogging() {
        // Given
        let logger = AppLogger(category: .general)
        
        // When/Then - Should not crash
        logger.warning("Test warning message")
        #expect(Bool(true))
    }
    
    @Test("Error logging does not crash")
    func errorLogging() {
        // Given
        let logger = AppLogger(category: .general)
        
        // When/Then - Should not crash
        logger.error("Test error message")
        #expect(Bool(true))
    }
    
    @Test("Error logging with error object does not crash")
    func errorLoggingWithError() {
        // Given
        let logger = AppLogger(category: .general)
        let error = ThriftwoodError.serviceUnavailable
        
        // When/Then - Should not crash
        logger.error("Test error with object", error: error)
        #expect(Bool(true))
    }
    
    @Test("Critical logging does not crash")
    func criticalLogging() {
        // Given
        let logger = AppLogger(category: .general)
        
        // When/Then - Should not crash
        logger.critical("Test critical message")
        #expect(Bool(true))
    }
    
    @Test("Critical logging with error does not crash")
    func criticalLoggingWithError() {
        // Given
        let logger = AppLogger(category: .general)
        let error = ThriftwoodError.authenticationRequired
        
        // When/Then - Should not crash
        logger.critical("Test critical with object", error: error)
        #expect(Bool(true))
    }
    
    // MARK: - Privacy Tests
    
    @Test("Private data logging does not crash")
    func privateDataLogging() {
        // Given
        let logger = AppLogger(category: .authentication)
        
        // When/Then - Should not crash
        logger.logPrivate("User logged in", privateData: "user@example.com")
        #expect(Bool(true))
    }
    
    @Test("API request logging without status code")
    func apiRequestLoggingWithoutStatus() {
        // Given
        let logger = AppLogger.networking
        
        // When/Then - Should not crash
        logger.logAPIRequest(method: "GET", path: "/api/v3/movie")
        #expect(Bool(true))
    }
    
    @Test("API request logging with status code")
    func apiRequestLoggingWithStatus() {
        // Given
        let logger = AppLogger.networking
        
        // When/Then - Should not crash
        logger.logAPIRequest(method: "POST", path: "/api/v3/movie", statusCode: 200)
        #expect(Bool(true))
    }
    
    // MARK: - Category Tests
    
    @Test("All log categories are functional", arguments: [
        LogCategory.networking,
        LogCategory.storage,
        LogCategory.authentication,
        LogCategory.ui,
        LogCategory.services,
        LogCategory.general
    ])
    func allCategories(category: LogCategory) {
        // Given/When
        let logger = AppLogger(category: category)
        
        // Then - Should be able to log to all categories without crashing
        logger.info("Test message for \(category.rawValue)")
        #expect(Bool(true))
    }
}
