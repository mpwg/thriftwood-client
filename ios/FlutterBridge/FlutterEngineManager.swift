//
//  FlutterEngineManager.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-10-02.
//  MIGRATION TEMPORARY: Flutter engine initialization and management
//  This file will be DELETED when migration to pure SwiftUI is complete
//

import UIKit
import Flutter

/// Manages Flutter engine initialization and lifecycle during the migration period
/// ⚠️ MIGRATION TEMPORARY: This entire class will be deleted after SwiftUI migration
class FlutterEngineManager {
    
    // MARK: - Properties
    
    /// The Flutter engine instance for hybrid functionality
    private(set) var flutterEngine: FlutterEngine?
    
    /// Shared instance for global access
    static let shared = FlutterEngineManager()
    
    private init() {}
    
    // MARK: - Engine Management
    
    /// Initialize Flutter engine for hybrid functionality
    /// This enables embedding Flutter views within the SwiftUI app during migration
    func initializeFlutterEngine() {
        flutterEngine = FlutterEngine(name: "thriftwood_flutter_engine")
        flutterEngine?.run()
        
        // Register Flutter plugins
        GeneratedPluginRegistrant.register(with: flutterEngine!)
        
        print("✅ Flutter engine initialized for hybrid functionality")
    }
    
    /// Initialize the Flutter-SwiftUI hybrid bridge system
    /// This enables seamless navigation between Flutter and SwiftUI views
    func initializeHybridBridge(with window: UIWindow?) async {
        guard let engine = flutterEngine else {
            print("❌ Error: Flutter engine not initialized")
            return
        }
        
        // Create Flutter view controller for bridge initialization
        let flutterViewController = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
        
        // Initialize the hybrid bridge system
        await MainActor.run {
            FlutterSwiftUIBridge.shared.initialize(with: flutterViewController)
        }
        
        print("✅ Hybrid bridge initialized - SwiftUI primary, Flutter embedded")
    }
    
    /// Handle deep links through the hybrid navigation system
    /// - Parameters:
    ///   - url: The deep link URL to handle
    ///   - sourceApplication: Optional source application identifier
    /// - Returns: True if the deep link was handled successfully
    func handleDeepLink(_ url: URL, sourceApplication: String? = nil) -> Bool {
        // Handle deep links through the hybrid navigation coordinator
        let coordinator = HybridNavigationCoordinator()
        return coordinator.handleDeepLink(url, sourceApplication: sourceApplication)
    }
    
    // MARK: - Cleanup
    
    /// Cleanup Flutter engine resources
    /// Called when the app is terminating or when switching to pure SwiftUI
    func cleanup() {
        flutterEngine?.destroyContext()
        flutterEngine = nil
        print("🧹 Flutter engine cleaned up")
    }
}