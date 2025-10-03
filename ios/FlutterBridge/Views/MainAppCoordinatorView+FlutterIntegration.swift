//
//  MainAppCoordinatorView+FlutterIntegration.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-10-03.
//  MIGRATION TEMPORARY: Flutter integration for MainAppCoordinatorView
//  This file will be DELETED when migration to pure SwiftUI is complete
//

import SwiftUI
import Flutter

/// ⚠️ MIGRATION TEMPORARY: Flutter integration extensions for MainAppCoordinatorView
/// This entire extension will be deleted when migration to pure SwiftUI is complete

extension MainAppCoordinatorView {
    
    /// Initialize the app with Flutter integration during migration period
    /// ⚠️ MIGRATION TEMPORARY: Remove when Flutter bridge is no longer needed
    /// NOTE: Disabled due to private property access issues - handled by main view
    @MainActor
    func initializeAppWithFlutterIntegration() async {
        // TODO: Cannot access private properties from extension
        // This functionality should be moved to the main view
        print("Flutter integration initialization requested")
    }
    
    /// Create MainAppCoordinatorView that is aware of Flutter initialization
    /// ⚠️ MIGRATION TEMPORARY: Remove when pure SwiftUI implementation is complete
    static func withFlutterSupport() -> MainAppCoordinatorView {
        // This method can be used during migration to ensure proper Flutter initialization
        return MainAppCoordinatorView()
    }
}

/// ⚠️ MIGRATION TEMPORARY: Flutter integration documentation
/// **Flutter Integration Notes:**
/// - Serves as the root SwiftUI view that allows Flutter-initiated navigation to present SwiftUI views
/// - Initial loading state coordination with Flutter
/// - Brief delay to allow Flutter initialization to complete
/// 
/// **When Migration is Complete:**
/// - Remove Flutter import from MainAppCoordinatorView.swift
/// - Remove initializeAppWithFlutterIntegration() method
/// - Remove Flutter-specific comments and delay logic
/// - This entire extension file should be deleted