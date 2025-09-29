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
    
    // Initialize shared data manager
    let methodChannel = FlutterMethodChannel(
      name: "com.thriftwood.bridge",
      binaryMessenger: flutterViewController.binaryMessenger
    )
    SharedDataManager.shared.initialize(with: methodChannel)
    
    // Register test route for Phase 1 testing
    FlutterSwiftUIBridge.shared.registerNativeView("/test")
    
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
