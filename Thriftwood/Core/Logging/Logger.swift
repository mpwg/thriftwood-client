//
//  Logger.swift
//  Thriftwood
//
//  Centralized logging framework using OSLog
//

import Foundation
import OSLog

/// Logging categories for different subsystems
enum LogCategory: String {
    case networking = "Networking"
    case storage = "Storage"
    case authentication = "Authentication"
    case ui = "UI"
    case services = "Services"
    case navigation = "Navigation"
    case general = "General"
}

/// Centralized logger for Thriftwood application
///
/// With Approachable Concurrency, this logger can be used from any isolation context.
/// Logging operations are inherently thread-safe and don't require actor isolation.
struct AppLogger: Sendable {
    private let subsystem = "com.thriftwood.app"
    private let category: LogCategory
    private let logger: os.Logger
    
    /// Initialize logger with a specific category
    /// - Parameter category: The logging category
    nonisolated init(category: LogCategory) {
        self.category = category
        self.logger = os.Logger(subsystem: subsystem, category: category.rawValue)
    }
    
    // MARK: - Logging Methods
    
    /// Log debug information (only in debug builds)
    /// - Parameters:
    ///   - message: The message to log
    ///   - file: Source file (auto-populated)
    ///   - function: Function name (auto-populated)
    ///   - line: Line number (auto-populated)
    nonisolated func debug(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        logger.debug("[\(fileName):\(line)] \(function) - \(message)")
        #endif
    }
    
    /// Log informational messages
    /// - Parameter message: The message to log
    nonisolated func info(_ message: String) {
        logger.info("\(message)")
    }
    
    /// Log warning messages
    /// - Parameter message: The message to log
    nonisolated func warning(_ message: String) {
        logger.warning("\(message)")
    }
    
    /// Log error messages
    /// - Parameters:
    ///   - message: The error message
    ///   - error: Optional error object
    nonisolated func error(_ message: String, error: (any Error)? = nil) {
        if let error = error {
            logger.error("\(message): \(error.localizedDescription)")
        } else {
            logger.error("\(message)")
        }
    }
    
    /// Log critical errors that require immediate attention
    /// - Parameters:
    ///   - message: The critical error message
    ///   - error: Optional error object
    nonisolated func critical(_ message: String, error: (any Error)? = nil) {
        if let error = error {
            logger.critical("\(message): \(error.localizedDescription)")
        } else {
            logger.critical("\(message)")
        }
    }
    
    // MARK: - Privacy-Aware Logging
    
    /// Log with privacy redaction for sensitive data
    /// - Parameters:
    ///   - message: The message to log
    ///   - privateData: Data that should be redacted in release builds
    nonisolated func logPrivate(_ message: String, privateData: String) {
        logger.info("\(message): \(privateData, privacy: .private)")
    }
    
    /// Log API request details
    /// - Parameters:
    ///   - method: HTTP method
    ///   - path: Request path (will be redacted)
    ///   - statusCode: Response status code
    nonisolated func logAPIRequest(method: String, path: String, statusCode: Int? = nil) {
        if let statusCode = statusCode {
            logger.info("API \(method) \(path, privacy: .private) - Status: \(statusCode)")
        } else {
            logger.info("API \(method) \(path, privacy: .private)")
        }
    }
}

// MARK: - Convenience Loggers

extension AppLogger {
    nonisolated static let networking = AppLogger(category: .networking)
    nonisolated static let storage = AppLogger(category: .storage)
    nonisolated static let authentication = AppLogger(category: .authentication)
    nonisolated static let ui = AppLogger(category: .ui)
    nonisolated static let services = AppLogger(category: .services)
    nonisolated static let navigation = AppLogger(category: .navigation)
    nonisolated static let general = AppLogger(category: .general)
}
