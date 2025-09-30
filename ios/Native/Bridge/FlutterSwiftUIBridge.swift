//
//  FlutterSwiftUIBridge.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-09-29.
//  Bridge system for seamless navigation between Flutter and SwiftUI views
//

import Foundation
import SwiftUI
import Flutter

/// Core bridge for seamless navigation between Flutter and SwiftUI
@objc class FlutterSwiftUIBridge: NSObject {
    static let shared = FlutterSwiftUIBridge()
    
    // MARK: - Properties
    
    /// Set of routes that should use native SwiftUI views
    private var nativeViews: Set<String> = []
    
    /// Reference to the main Flutter view controller
    private weak var flutterViewController: FlutterViewController?
    
    /// Method channel for communication with Flutter
    private(set) var methodChannel: FlutterMethodChannel?
    
    /// Navigation coordinator for managing hybrid navigation
    private let navigationCoordinator = HybridNavigationCoordinator()
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
    }
    
    /// Initialize the bridge with the Flutter view controller
    /// - Parameter flutterViewController: The main Flutter view controller
    func initialize(with flutterViewController: FlutterViewController) {
        self.flutterViewController = flutterViewController
        setupMethodChannel(with: flutterViewController)
        
        print("FlutterSwiftUIBridge initialized successfully")
    }
    
    // MARK: - Native View Registration
    
    /// Register a route to use native SwiftUI view instead of Flutter
    /// - Parameter route: The route path (e.g., "/settings", "/dashboard")
    func registerNativeView(_ route: String) {
        nativeViews.insert(route)
        print("Registered native view for route: \(route)")
    }
    
    /// Unregister a route from using native SwiftUI view
    /// - Parameter route: The route path to remove
    func unregisterNativeView(_ route: String) {
        nativeViews.remove(route)
        print("Unregistered native view for route: \(route)")
    }
    
    /// Check if a route should use native SwiftUI view
    /// - Parameter route: The route path to check
    /// - Returns: True if the route should use SwiftUI, false for Flutter
    func shouldUseNativeView(for route: String) -> Bool {
        return nativeViews.contains(route)
    }
    
    /// Get all registered native view routes
    /// - Returns: Array of all registered native routes
    func getAllNativeViews() -> [String] {
        return Array(nativeViews)
    }
    
    // MARK: - Navigation Methods
    
    /// Present a SwiftUI view from Flutter
    /// - Parameters:
    ///   - route: The route identifier
    ///   - data: Optional data to pass to the SwiftUI view
    func presentNativeView(route: String, data: [String: Any] = [:]) {
        guard let flutterVC = flutterViewController,
              shouldUseNativeView(for: route) else { 
            print("Cannot present native view for route: \(route)")
            return 
        }
        
        print("Presenting native SwiftUI view for route: \(route)")
        
        let swiftUIView = createSwiftUIView(for: route, data: data)
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // Configure presentation style
        hostingController.modalPresentationStyle = .fullScreen
        
        // Present the SwiftUI view
        DispatchQueue.main.async {
            flutterVC.present(hostingController, animated: true) {
                print("Successfully presented SwiftUI view for route: \(route)")
            }
        }
    }
    
    /// Navigate back to Flutter from SwiftUI
    /// - Parameter data: Optional data to pass back to Flutter
    func navigateBackToFlutter(data: [String: Any] = [:]) {
        guard let flutterVC = flutterViewController else { 
            print("Cannot navigate back to Flutter: no Flutter view controller")
            return 
        }
        
        print("Navigating back to Flutter with data: \(data)")
        
        // Send data back to Flutter via method channel
        if !data.isEmpty {
            methodChannel?.invokeMethod("onReturnFromNative", arguments: data)
        }
        
        // Dismiss the SwiftUI view
        DispatchQueue.main.async {
            flutterVC.dismiss(animated: true) {
                print("Successfully returned to Flutter")
            }
        }
    }
    
    // MARK: - Method Channel Setup
    
    private func setupMethodChannel(with flutterViewController: FlutterViewController) {
        let binaryMessenger = flutterViewController.binaryMessenger
        methodChannel = FlutterMethodChannel(
            name: "com.thriftwood.bridge",
            binaryMessenger: binaryMessenger
        )
        
        methodChannel?.setMethodCallHandler { [weak self] (call, result) in
            self?.handleMethodCall(call, result: result)
        }
        
        print("Method channel 'com.thriftwood.bridge' established")
    }
    
    private func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = call.method
        let arguments = call.arguments as? [String: Any] ?? [:]
        
        print("Received method call: \(method) with arguments: \(arguments)")
        
        switch method {
        case "navigateToNative":
            handleNavigateToNative(arguments: arguments, result: result)
        case "isNativeViewAvailable":
            handleIsNativeViewAvailable(arguments: arguments, result: result)
        case "registerNativeView":
            handleRegisterNativeView(arguments: arguments, result: result)
        case "getAllNativeViews":
            handleGetAllNativeViews(result: result)
        default:
            print("Unknown method call: \(method)")
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Method Call Handlers
    
    private func handleNavigateToNative(arguments: [String: Any], result: @escaping FlutterResult) {
        guard let route = arguments["route"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Route is required", details: nil))
            return
        }
        
        let data = arguments["data"] as? [String: Any] ?? [:]
        presentNativeView(route: route, data: data)
        result(true)
    }
    
    private func handleIsNativeViewAvailable(arguments: [String: Any], result: @escaping FlutterResult) {
        guard let route = arguments["route"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Route is required", details: nil))
            return
        }
        
        result(shouldUseNativeView(for: route))
    }
    
    private func handleRegisterNativeView(arguments: [String: Any], result: @escaping FlutterResult) {
        guard let route = arguments["route"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Route is required", details: nil))
            return
        }
        
        registerNativeView(route)
        result(true)
    }
    
    private func handleGetAllNativeViews(result: @escaping FlutterResult) {
        result(getAllNativeViews())
    }
    
    // MARK: - SwiftUI View Factory
    
    private func createSwiftUIView(for route: String, data: [String: Any]) -> AnyView {
        print("Creating SwiftUI view for route: \(route)")
        
        switch route {
        case "settings":
            let settingsViewModel = SettingsViewModel()
            return AnyView(SwiftUISettingsView(viewModel: settingsViewModel))
        case "settings_configuration":
            let settingsViewModel = SettingsViewModel()
            let configurationViewModel = ConfigurationViewModel(settingsViewModel: settingsViewModel)
            return AnyView(SwiftUIConfigurationView(viewModel: configurationViewModel))
        case "settings_profiles":
            let settingsViewModel = SettingsViewModel()
            let profilesViewModel = ProfilesViewModel(settingsViewModel: settingsViewModel)
            return AnyView(SwiftUIProfilesView(viewModel: profilesViewModel))
        case "settings_system":
            let settingsViewModel = SettingsViewModel()
            return AnyView(SwiftUISettingsView(viewModel: settingsViewModel))
        case "settings_system_logs":
            let systemLogsViewModel = SystemLogsViewModel()
            return AnyView(SwiftUISystemLogsView(viewModel: systemLogsViewModel))
        case "settings_general":
            let settingsViewModel = SettingsViewModel()
            return AnyView(SwiftUIGeneralSettingsView(viewModel: settingsViewModel))
        case "settings_dashboard":
            let settingsViewModel = SettingsViewModel()
            return AnyView(SwiftUIDashboardSettingsView(viewModel: settingsViewModel))
        case "settings_wake_on_lan":
            let settingsViewModel = SettingsViewModel()
            return AnyView(SwiftUIWakeOnLANSettingsView(viewModel: settingsViewModel))
        case "settings_search":
            let settingsViewModel = SettingsViewModel()
            return AnyView(SwiftUISearchSettingsView(viewModel: settingsViewModel))
        case "settings_external_modules":
            let settingsViewModel = SettingsViewModel()
            return AnyView(SwiftUIExternalModulesSettingsView(viewModel: settingsViewModel))
        case "settings_drawer":
            let settingsViewModel = SettingsViewModel()
            return AnyView(SwiftUIDrawerSettingsView(viewModel: settingsViewModel))
        case "settings_quick_actions":
            let settingsViewModel = SettingsViewModel()
            return AnyView(SwiftUIQuickActionsSettingsView(viewModel: settingsViewModel))
        case "settings_all":
            return AnyView(SwiftUIAllSettingsView())
        case "dashboard":
            return AnyView(DashboardWrapperView(data: data))
        case "test":
            return AnyView(TestSwiftUIView(route: route, data: data))
        default:
            // Fallback view for unimplemented routes
            return AnyView(PlaceholderSwiftUIView(route: route, data: data))
        }
    }
}

// MARK: - Test and Placeholder Views

/// Test SwiftUI view for validating the hybrid infrastructure
struct TestSwiftUIView: View {
    let route: String
    let data: [String: Any]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("SwiftUI Test View")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Route: \(route)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if !data.isEmpty {
                    Text("Data received:")
                        .font(.headline)
                    
                    ForEach(Array(data.keys), id: \.self) { key in
                        Text("\(key): \(String(describing: data[key]))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Button("Return to Flutter") {
                    FlutterSwiftUIBridge.shared.navigateBackToFlutter(data: [
                        "result": "success",
                        "timestamp": Date().timeIntervalSince1970,
                        "message": "Returned from SwiftUI test view"
                    ])
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
            .navigationTitle("SwiftUI Bridge Test")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

/// Placeholder view for routes that haven't been implemented yet
struct PlaceholderSwiftUIView: View {
    let route: String
    let data: [String: Any]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "wrench.and.screwdriver")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                
                Text("Under Construction")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("SwiftUI view for '\(route)' is not yet implemented")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Button("Return to Flutter") {
                    FlutterSwiftUIBridge.shared.navigateBackToFlutter()
                }
                .buttonStyle(.bordered)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Coming Soon")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Wrapper Views (Will be implemented in later phases)

struct SettingsWrapperView: View {
    let data: [String: Any]
    
    var body: some View {
        PlaceholderSwiftUIView(route: "/settings", data: data)
    }
}

struct DashboardWrapperView: View {
    let data: [String: Any]
    
    var body: some View {
        PlaceholderSwiftUIView(route: "/dashboard", data: data)
    }
}