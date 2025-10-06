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
    
    // MARK: - Navigation Tracing
    
    /// Log navigation event with full context
    /// - Parameters:
    ///   - from: Source location (route, view, or coordinator)
    ///   - to: Destination (route or view)
    ///   - coordinator: Coordinator handling the navigation
    ///   - stackDepth: Current navigation stack depth (optional)
    ///   - file: Source file (auto-populated)
    ///   - function: Function name (auto-populated)
    ///   - line: Line number (auto-populated)
    nonisolated func logNavigation(
        from: String,
        to: String,
        coordinator: String,
        stackDepth: Int? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let fileName = (file as NSString).lastPathComponent
        let location = "[\(fileName):\(line)] \(function)"
        
        if let depth = stackDepth {
            logger.info("🧭 NAVIGATE [depth:\(depth)] \(coordinator): \(from) → \(to) | \(location)")
        } else {
            logger.info("🧭 NAVIGATE \(coordinator): \(from) → \(to) | \(location)")
        }
    }
    
    /// Log coordinator lifecycle events
    /// - Parameters:
    ///   - event: Event type (start, finish, created, destroyed)
    ///   - coordinator: Coordinator name
    ///   - details: Additional context
    ///   - file: Source file (auto-populated)
    ///   - function: Function name (auto-populated)
    ///   - line: Line number (auto-populated)
    nonisolated func logCoordinator(
        event: String,
        coordinator: String,
        details: String? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let fileName = (file as NSString).lastPathComponent
        let location = "[\(fileName):\(line)] \(function)"
        
        if let details = details {
            logger.info("🎯 COORDINATOR \(event.uppercased()): \(coordinator) - \(details) | \(location)")
        } else {
            logger.info("🎯 COORDINATOR \(event.uppercased()): \(coordinator) | \(location)")
        }
    }
    
    /// Log tab switching events
    /// - Parameters:
    ///   - from: Previous tab
    ///   - to: New tab
    ///   - file: Source file (auto-populated)
    ///   - line: Line number (auto-populated)
    nonisolated func logTabSwitch(
        from: String,
        to: String,
        file: String = #file,
        line: Int = #line
    ) {
        let fileName = (file as NSString).lastPathComponent
        logger.info("🔀 TAB SWITCH: \(from) → \(to) | [\(fileName):\(line)]")
    }
    
    /// Log view lifecycle events
    /// - Parameters:
    ///   - event: Event type (appear, disappear)
    ///   - view: View name
    ///   - coordinator: Associated coordinator (optional)
    ///   - file: Source file (auto-populated)
    ///   - line: Line number (auto-populated)
    nonisolated func logViewLifecycle(
        event: String,
        view: String,
        coordinator: String? = nil,
        file: String = #file,
        line: Int = #line
    ) {
        let fileName = (file as NSString).lastPathComponent
        
        if let coordinator = coordinator {
            logger.debug("👁️  VIEW \(event.uppercased()): \(view) [coordinator: \(coordinator)] | [\(fileName):\(line)]")
        } else {
            logger.debug("👁️  VIEW \(event.uppercased()): \(view) | [\(fileName):\(line)]")
        }
    }
    
    /// Log deep link handling
    /// - Parameters:
    ///   - url: Deep link URL
    ///   - action: Action being performed
    ///   - coordinator: Coordinator handling the deep link (optional)
    ///   - file: Source file (auto-populated)
    ///   - line: Line number (auto-populated)
    nonisolated func logDeepLink(
        url: String,
        action: String,
        coordinator: String? = nil,
        file: String = #file,
        line: Int = #line
    ) {
        let fileName = (file as NSString).lastPathComponent
        
        if let coordinator = coordinator {
            logger.info("🔗 DEEP LINK: \(action) - \(url, privacy: .private) [coordinator: \(coordinator)] | [\(fileName):\(line)]")
        } else {
            logger.info("🔗 DEEP LINK: \(action) - \(url, privacy: .private) | [\(fileName):\(line)]")
        }
    }
    
    /// Log navigation stack changes
    /// - Parameters:
    ///   - action: Action performed (push, pop, clear)
    ///   - coordinator: Coordinator managing the stack
    ///   - stackSize: Current stack size after action
    ///   - route: Route involved (optional)
    ///   - file: Source file (auto-populated)
    ///   - line: Line number (auto-populated)
    nonisolated func logStackChange(
        action: String,
        coordinator: String,
        stackSize: Int,
        route: String? = nil,
        file: String = #file,
        line: Int = #line
    ) {
        let fileName = (file as NSString).lastPathComponent
        
        if let route = route {
            logger.debug("📚 STACK \(action.uppercased()): \(coordinator) [size: \(stackSize)] route: \(route) | [\(fileName):\(line)]")
        } else {
            logger.debug("📚 STACK \(action.uppercased()): \(coordinator) [size: \(stackSize)] | [\(fileName):\(line)]")
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
