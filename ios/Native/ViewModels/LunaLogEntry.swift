//
//  LunaLogEntry.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import Foundation
import SwiftUI
import Combine
import UniformTypeIdentifiers

/// Swift equivalent of Flutter's LunaLog class
/// Matches exactly: lib/database/models/log.dart
struct LunaLogEntry: Identifiable, Equatable {
    let id = UUID()
    let timestamp: Int           // Flutter: @HiveField(0) final int timestamp
    let type: LunaLogType       // Flutter: @HiveField(1) final LunaLogType type  
    let className: String?      // Flutter: @HiveField(2) final String? className
    let methodName: String?     // Flutter: @HiveField(3) final String? methodName
    let message: String         // Flutter: @HiveField(4) final String message
    let error: String?          // Flutter: @HiveField(5) final String? error
    let stackTrace: String?     // Flutter: @HiveField(6) final String? stackTrace
    
    var date: Date {
        // Flutter: DateTime.fromMillisecondsSinceEpoch(timestamp)
        Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
    }
    
    /// Flutter equivalent: LunaLog.toJson()
    func toJSON() -> [String: Any] {
        var json: [String: Any] = [
            "timestamp": ISO8601DateFormatter().string(from: date),
            "type": type.title,  // Use title, not displayName
            "message": message
        ]
        
        if let className = className, !className.isEmpty {
            json["class_name"] = className
        }
        if let methodName = methodName, !methodName.isEmpty {
            json["method_name"] = methodName
        }
        if let error = error, !error.isEmpty {
            json["error"] = error
        }
        if let stackTrace = stackTrace, !stackTrace.isEmpty {
            json["stack_trace"] = stackTrace.components(separatedBy: "\n")
        }
        
        return json
    }
    
    /// Flutter equivalent: LunaLog.withMessage factory
    static func withMessage(
        type: LunaLogType,
        message: String,
        className: String? = nil,
        methodName: String? = nil
    ) -> LunaLogEntry {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        return LunaLogEntry(
            timestamp: timestamp,
            type: type,
            className: className,
            methodName: methodName,
            message: message,
            error: nil,
            stackTrace: nil
        )
    }
    
    /// Flutter equivalent: LunaLog.withError factory
    static func withError(
        type: LunaLogType,
        message: String,
        error: Error,
        stackTrace: String? = nil,
        className: String? = nil,
        methodName: String? = nil
    ) -> LunaLogEntry {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        return LunaLogEntry(
            timestamp: timestamp,
            type: type,
            className: className,
            methodName: methodName,
            message: message,
            error: error.localizedDescription,
            stackTrace: stackTrace
        )
    }
}