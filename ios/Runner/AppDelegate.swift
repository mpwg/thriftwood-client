import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)
    
    // Initialize the hybrid bridge system
    initializeHybridBridge()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  /// Initialize the Flutter-SwiftUI hybrid bridge
  private func initializeHybridBridge() {
    guard let flutterViewController = window?.rootViewController as? FlutterViewController else {
      print("Error: Could not find Flutter view controller for bridge initialization")
      return
    }
    
    // Initialize the bridge with the Flutter view controller
      FlutterSwiftUIBridge.shared.initialize(with: flutterViewController)
    
    // Register settings routes for Phase 2 hybrid functionality
    // Main settings route (root level)
    FlutterSwiftUIBridge.shared.registerNativeView("settings")
    
    // Sub-routes for settings sections
    FlutterSwiftUIBridge.shared.registerNativeView("settings_configuration")
    FlutterSwiftUIBridge.shared.registerNativeView("settings_profiles")
    FlutterSwiftUIBridge.shared.registerNativeView("settings_system")
    FlutterSwiftUIBridge.shared.registerNativeView("settings_system_logs")
    FlutterSwiftUIBridge.shared.registerNativeView("settings_general")
    FlutterSwiftUIBridge.shared.registerNativeView("settings_dashboard")
    FlutterSwiftUIBridge.shared.registerNativeView("settings_wake_on_lan")
    FlutterSwiftUIBridge.shared.registerNativeView("settings_search")
    FlutterSwiftUIBridge.shared.registerNativeView("settings_external_modules")
    FlutterSwiftUIBridge.shared.registerNativeView("settings_drawer")
    FlutterSwiftUIBridge.shared.registerNativeView("settings_quick_actions")
    FlutterSwiftUIBridge.shared.registerNativeView("settings_all")

    print("Hybrid bridge system initialized successfully")
  }
  
  /// Handle URL schemes for deep linking
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    // Handle deep links through the hybrid navigation coordinator
    let coordinator = HybridNavigationCoordinator()
    if coordinator.handleDeepLink(url, sourceApplication: options[.sourceApplication] as? String) {
      return true
    }
    
    // Fallback to Flutter's URL handling
    return super.application(app, open: url, options: options)
  }
}
