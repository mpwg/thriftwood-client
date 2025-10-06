//
//  AppLogger.swift
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

import Foundation
import OSLog

/// Centralized logger for Thriftwood application
///
/// With Approachable Concurrency, this logger can be used from any isolation context.
/// Logging operations are inherently thread-safe and don't require actor isolation.
struct AppLogger: Sendable {
    private let subsystem = "eu.mpwg.thriftwood"
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
