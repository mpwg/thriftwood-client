//
//  LunaLogType.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import Foundation
import SwiftUI
import Combine
import UniformTypeIdentifiers

/// Swift equivalent of Flutter's LunaLogType enum
/// Matches exactly: lib/types/log_type.dart
enum LunaLogType: String, CaseIterable, Equatable {
    case warning = "warning"
    case error = "error" 
    case critical = "critical"
    case debug = "debug"
    case all = "all"  // Special case for UI filtering
    
    // Flutter equivalent: LunaLogType.key
    var key: String {
        return self.rawValue
    }
    
    // Flutter equivalent: LunaLogType.title  
    var title: String {
        switch self {
        case .warning: return "Warning"
        case .error: return "Error"
        case .critical: return "Critical" 
        case .debug: return "Debug"
        case .all: return "All Logs"
        }
    }
    
    // Flutter equivalent: LunaLogType.description
    var description: String {
        if self == .all {
            return "View all system logs"
        }
        return "View \(title.lowercased()) logs"
    }
    
    // Flutter equivalent: LunaLogType.color
    var color: Color {
        switch self {
        case .warning: return .orange    // LunaColours.orange
        case .error: return .red         // LunaColours.red  
        case .critical: return .purple   // LunaColours.accent
        case .debug: return .secondary   // LunaColours.blueGrey
        case .all: return .primary
        }
    }
    
    // Flutter equivalent: LunaLogType.icon (mapped to SF Symbols)
    var icon: String {
        switch self {
        case .warning: return "exclamationmark.triangle"
        case .error: return "xmark.circle"
        case .critical: return "exclamationmark.octagon"
        case .debug: return "ladybug"
        case .all: return "doc.text"
        }
    }
    
    // Flutter equivalent: LunaLogType.enabled
    var enabled: Bool {
        switch self {
        case .debug: 
            // Flutter: return LunaFlavor.BETA.isRunningFlavor()
            // For now, disable debug logs like Flutter does in production
            return false 
        default: 
            return true
        }
    }
    
    // Flutter equivalent: LunaLogType.fromKey()
    static func fromKey(_ key: String) -> LunaLogType? {
        return LunaLogType(rawValue: key)
    }
}