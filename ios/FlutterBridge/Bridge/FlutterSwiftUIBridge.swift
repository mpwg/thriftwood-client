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
    @MainActor
    func initialize(with flutterViewController: FlutterViewController) {
        self.flutterViewController = flutterViewController
        
        // Initialize central dispatcher to prevent method channel conflicts (Rule 13)
        BridgeMethodDispatcher.shared.initialize(with: flutterViewController)
        BridgeMethodDispatcher.shared.registerCoreBridgeMethods()
        
        // Register Swift-completed features (Swift-first rule enforcement)
        registerCompletedSwiftFeatures()
        
        // Initialize Flutter bridge for accessing existing SwiftData
        SwiftDataFlutterBridge.shared.initialize(with: flutterViewController)
        
        // Initialize data layer manager with existing SwiftData context
        Task {
            await initializeDataLayerManager(with: flutterViewController)
        }
        
        print("✅ FlutterSwiftUIBridge initialized with Swift-first enforcement")
        print("✅ Method channel conflicts prevented via BridgeMethodDispatcher")
    }
    
    /// Initialize DataLayerManager with existing SwiftData context and method channel
    @MainActor
    private func initializeDataLayerManager(with flutterViewController: FlutterViewController) async {
        // Get SwiftData context from SwiftDataManager (NOT from bridge)
        guard let modelContext = SwiftDataManager.shared.getContext() else {
            print("❌ Cannot initialize DataLayerManager: SwiftDataManager not ready")
            return
        }
        
        // Create method channel for DataLayerManager (uses same channel as HiveBridge)
        let methodChannel = FlutterMethodChannel(
            name: "com.thriftwood.hive",
            binaryMessenger: flutterViewController.binaryMessenger
        )
        
        // Initialize DataLayerManager with existing SwiftData context
        await DataLayerManager.shared.initialize(
            modelContext: modelContext,
            methodChannel: methodChannel
        )
        
        print("✅ DataLayerManager initialized with existing SwiftData context")
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
        guard shouldUseNativeView(for: route) else {
            print("Cannot present native view for route: \(route) - not registered")
            // Show actionable error and fallback
            navigationCoordinator.presentError(
                title: "Navigation not available",
                message: "The native view for \(route) is not registered.",
                actions: [.retry, .backToFlutter],
                retryRoute: route,
                data: data
            )
            return
        }
        
        // Try Flutter view controller first, then fall back to root view controller
        let presenterVC: UIViewController
        if let flutterVC = flutterViewController {
            presenterVC = flutterVC
        } else if let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first(where: { $0.isKeyWindow })?.rootViewController {
            presenterVC = rootVC
        } else {
            print("⚠️ Cannot present \(route): No suitable view controller found")
            return
        }
        
        print("Presenting native SwiftUI view for route: \(route)")
        
        let swiftUIView = createSwiftUIView(for: route, data: data)
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // Configure presentation style
        hostingController.modalPresentationStyle = .fullScreen
        
        // Present the SwiftUI view with robust error handling
        DispatchQueue.main.async {
            // Find the topmost view controller that can present
            guard let topVC = self.findTopViewController(from: presenterVC) else {
                print("⚠️ Cannot present \(route): No suitable view controller found")
                return
            }
            
            // If there's already a presented view, handle it gracefully
            if let presentedVC = topVC.presentedViewController {
                print("⚠️ Dismissing existing view to present \(route)")
                presentedVC.dismiss(animated: false) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        topVC.present(hostingController, animated: true) {
                            print("Successfully presented SwiftUI view for route: \(route) after dismissal")
                        }
                    }
                }
            } else {
                // Direct presentation
                topVC.present(hostingController, animated: true) {
                    print("Successfully presented SwiftUI view for route: \(route)")
                }
            }
        }
    }
    
    /// Present a SwiftUI view from another SwiftUI view (SwiftUI-to-SwiftUI navigation)
    /// - Parameters:
    ///   - route: The route identifier
    ///   - data: Optional data to pass to the SwiftUI view
    ///   - from: The current UIViewController to present from
    func presentNativeViewFromSwiftUI(route: String, data: [String: Any] = [:], from presenter: UIViewController) {
        guard shouldUseNativeView(for: route) else {
            print("Cannot present native view for route: \(route) - not registered")
            navigationCoordinator.presentError(
                title: "Navigation not available",
                message: "The native view for \(route) is not registered.",
                actions: [.retry, .backToFlutter],
                retryRoute: route,
                data: data
            )
            return
        }
        
        print("Presenting native SwiftUI view for route: \(route) from SwiftUI context")
        
        let swiftUIView = createSwiftUIView(for: route, data: data)
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // Configure presentation style
        hostingController.modalPresentationStyle = .fullScreen
        
        // Present the SwiftUI view from the current SwiftUI context
        DispatchQueue.main.async {
            presenter.present(hostingController, animated: true) {
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
    
    // MARK: - Swift-First Feature Registration
    
    /// Register all Swift-completed features (enforces Swift-first migration rules)
    private func registerCompletedSwiftFeatures() {
        // Phase 2 Complete: Settings fully implemented in Swift
        registerNativeView("/settings")
        registerNativeView("/settings/general")
        registerNativeView("/settings/profiles")
        registerNativeView("/settings/system")
        registerNativeView("/settings/dashboard")
        registerNativeView("/settings/radarr")
        registerNativeView("/settings/sonarr")
        registerNativeView("/settings/lidarr")
        registerNativeView("/settings/sabnzbd")
        registerNativeView("/settings/nzbget")
        registerNativeView("/settings/tautulli")
        registerNativeView("/settings/overseerr")
        registerNativeView("/settings/wake_on_lan")
        registerNativeView("/settings/search")
        registerNativeView("/settings/external_modules")
        registerNativeView("/settings/drawer")
        registerNativeView("/settings/quick_actions")
        
        // Phase 3 Complete: Dashboard fully implemented in Swift
        registerNativeView("/dashboard")
        
        print("✅ Swift-completed features registered (Settings + Dashboard)")
    }
    
    // MARK: - Method Channel Handling (Deprecated - Using BridgeMethodDispatcher)
    
    /// Legacy method call handler - now delegated to BridgeMethodDispatcher
    /// This ensures no method channel handler conflicts (Rule 13 enforcement)
    private func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // This method should not be called directly anymore
        // All method calls are routed through BridgeMethodDispatcher
        print("⚠️ WARNING: Direct method call received - should use BridgeMethodDispatcher")
        result(FlutterError(code: "DEPRECATED", message: "Use BridgeMethodDispatcher", details: nil))
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
        
        print("📱 Registering native view for route: \(route)")
        registerNativeView(route)
        result(true)
    }
    
    private func handleGetAllNativeViews(result: @escaping FlutterResult) {
        result(getAllNativeViews())
    }
    
    // MARK: - Helper Methods
    
    /// Find the topmost view controller that can present modally
    private func findTopViewController(from viewController: UIViewController) -> UIViewController? {
        // Start with the provided view controller
        var current = viewController
        
        // Keep going up until we find the topmost presented view controller
        while let presented = current.presentedViewController {
            current = presented
        }
        
        // Make sure the view controller is in the window hierarchy
        guard current.view.window != nil else {
            return nil
        }
        
        return current
    }
    
    // MARK: - Shared ViewModels
    private var sharedSettingsViewModel: SettingsViewModel?
    
    private func getSharedSettingsViewModel() -> SettingsViewModel {
        if let existing = sharedSettingsViewModel {
            return existing
        }
        
        let viewModel = SettingsViewModel()
        sharedSettingsViewModel = viewModel
        return viewModel
    }
    
    // MARK: - SwiftUI View Factory
    
    func createSwiftUIView(for route: String, data: [String: Any]) -> AnyView {
        print("Creating SwiftUI view for route: \(route)")
        
        // STANDARD RULE: All routes MUST use Flutter format: "/path/subpath"
        // NO underscore variants allowed (settings_general -> /settings/general)
        // This ensures 100% consistency between Flutter and SwiftUI navigation
        
        switch route {
        case "/settings":
            let settingsViewModel = getSharedSettingsViewModel()
            return AnyView(SwiftUISettingsView(viewModel: settingsViewModel))
        case "/settings/configuration":
            let settingsViewModel = getSharedSettingsViewModel()
            let configurationViewModel = ConfigurationViewModel(settingsViewModel: settingsViewModel)
            return AnyView(SwiftUIConfigurationView(viewModel: configurationViewModel))
        case "/settings/profiles":
            let settingsViewModel = getSharedSettingsViewModel()
            return AnyView(SwiftUIProfilesView(viewModel: settingsViewModel))
        case "/settings/system":
            let settingsViewModel = getSharedSettingsViewModel()
            return AnyView(SwiftUISystemView(viewModel: settingsViewModel))
        case "/settings/system/logs":
            let systemLogsViewModel = SystemLogsViewModel()
            return AnyView(SwiftUISystemLogsView(viewModel: systemLogsViewModel))
        case "/settings/general":
            let settingsViewModel = getSharedSettingsViewModel()
            return AnyView(SwiftUIGeneralSettingsView(viewModel: settingsViewModel))
        case "/settings/dashboard":
            let settingsViewModel = getSharedSettingsViewModel()
            return AnyView(SwiftUIDashboardSettingsView(viewModel: settingsViewModel))
        case "/settings/wake_on_lan":
            let settingsViewModel = getSharedSettingsViewModel()
            return AnyView(SwiftUIWakeOnLANSettingsView(viewModel: settingsViewModel))
        case "/settings/search":
            let settingsViewModel = getSharedSettingsViewModel()
            return AnyView(SwiftUISearchSettingsView(viewModel: settingsViewModel))
        case "/settings/external_modules":
            let settingsViewModel = getSharedSettingsViewModel()
            return AnyView(SwiftUIExternalModulesSettingsView(viewModel: settingsViewModel))  
        case "/settings/drawer":
            let settingsViewModel = getSharedSettingsViewModel()
            return AnyView(SwiftUIDrawerSettingsView(viewModel: settingsViewModel))
        case "/settings/quick_actions":
            let settingsViewModel = getSharedSettingsViewModel()
            return AnyView(SwiftUIQuickActionsSettingsView(viewModel: settingsViewModel))
        
        // Service-specific settings views
        case "/settings/radarr":
            let settingsViewModel = getSharedSettingsViewModel()
            return AnyView(SwiftUIRadarrSettingsView(viewModel: settingsViewModel))
        case "/settings/sonarr":
            let settingsViewModel = getSharedSettingsViewModel()
            return AnyView(SwiftUISonarrSettingsView(viewModel: settingsViewModel))
        case "/settings/lidarr":
            let settingsViewModel = getSharedSettingsViewModel()
            return AnyView(SwiftUILidarrSettingsView(viewModel: settingsViewModel))
        case "/settings/sabnzbd":
            let settingsViewModel = getSharedSettingsViewModel()
            return AnyView(SwiftUISABnzbdSettingsView(viewModel: settingsViewModel))
        case "/settings/nzbget":
            let settingsViewModel = getSharedSettingsViewModel()
            return AnyView(SwiftUINZBGetSettingsView(viewModel: settingsViewModel))
        case "/settings/tautulli":
            let settingsViewModel = getSharedSettingsViewModel()
            return AnyView(SwiftUITautulliSettingsView(viewModel: settingsViewModel))
        case "/settings/overseerr":
            let settingsViewModel = getSharedSettingsViewModel()
            return AnyView(SwiftUIOverseerrSettingsView(viewModel: settingsViewModel))
        
        case "/settings/all":
            return AnyView(SwiftUIAllSettingsView())
        case "/dashboard":
            return AnyView(DashboardWrapperView())
        case "/test":
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
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            DashboardView(navigationPath: $navigationPath)
        }
    }
}