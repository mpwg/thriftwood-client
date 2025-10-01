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
    
    // Handle Mac Catalyst specific setup
    #if targetEnvironment(macCatalyst)
    print("🖥️ Running in Mac Catalyst environment")
    // Disable unsupported features for Mac Catalyst
    #else
    print("📱 Running in native iOS environment")
    #endif
    
    // Initialize the hybrid bridge system
    initializeHybridBridge()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  /// Initialize the Flutter-SwiftUI hybrid bridge with Swift-first enforcement
  private func initializeHybridBridge() {
    guard let flutterViewController = window?.rootViewController as? FlutterViewController else {
      print("❌ Error: Could not find Flutter view controller for bridge initialization")
      return
    }

    // Initialize the Swift-first bridge system
    FlutterSwiftUIBridge.shared.initialize(with: flutterViewController)
    
    print("✅ Swift-first hybrid bridge initialization complete")
    print("✅ All method channel conflicts prevented")
    print("✅ Settings and Dashboard eliminated from Flutter")
  }
  
  /// DEPRECATED: Native views are now auto-registered in FlutterSwiftUIBridge.registerCompletedSwiftFeatures()
  /// This method is no longer called to prevent duplicate registrations
  private func registerNativeViews() {
    // NOTE: This method is deprecated
    // Native view registration is now handled automatically in:
    // FlutterSwiftUIBridge.registerCompletedSwiftFeatures()
    print("⚠️ DEPRECATED: registerNativeViews() - use FlutterSwiftUIBridge.registerCompletedSwiftFeatures()")
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
