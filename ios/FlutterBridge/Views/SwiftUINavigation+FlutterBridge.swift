//
//  SwiftUINavigation+FlutterBridge.swift
//  Runner
//  
//  Created by GitHub Copilot on 2025-10-02.
//  MIGRATION TEMPORARY: Navigation extensions for Flutter bridge integration
//  This file will be DELETED when migration to pure SwiftUI is complete
//

import SwiftUI
import Foundation

/// ⚠️ MIGRATION TEMPORARY: Flutter bridge navigation helpers
/// These extensions will be deleted when migration to pure SwiftUI is complete

extension View {
    
    /// Navigate to a route using the hybrid Flutter/SwiftUI bridge system
    /// ⚠️ MIGRATION TEMPORARY: Remove when pure SwiftUI navigation is implemented
    /// - Parameters:
    ///   - route: The route to navigate to
    ///   - data: Optional navigation data
    /// - Returns: A view that will be presented
    func navigateToHybridRoute(_ route: String, data: [String: Any] = [:]) -> some View {
        // This is a temporary bridge implementation
        // TODO: Replace with pure SwiftUI navigation when migration is complete
        
        return AnyView(
            EmptyView()
                .onAppear {
                    // Use the Flutter bridge to navigate during migration period
                    let bridge = FlutterSwiftUIBridge.shared
                    if bridge.shouldUseNativeView(for: route) {
                        // Present native SwiftUI view
                        _ = bridge.createSwiftUIView(for: route, data: data)
                    } else {
                        // Navigate back to Flutter
                        bridge.navigateBackToFlutter(data: [
                            "navigateTo": route,
                            "navigationData": data
                        ])
                    }
                }
        )
    }
    
    /// Create a SwiftUI view for a route using the bridge system
    /// ⚠️ MIGRATION TEMPORARY: Remove when pure SwiftUI navigation is implemented
    /// - Parameters:
    ///   - route: The route to create a view for
    ///   - data: Optional view data
    /// - Returns: A SwiftUI view
    func createHybridView(for route: String, data: [String: Any] = [:]) -> some View {
        // This is a temporary bridge implementation
        // TODO: Replace with pure SwiftUI view creation when migration is complete
        
        return FlutterSwiftUIBridge.shared.createSwiftUIView(for: route, data: data)
    }
}