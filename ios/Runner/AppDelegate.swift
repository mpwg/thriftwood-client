import UIKit
import SwiftUI
import Flutter

@main
@objc class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  private var flutterEngine: FlutterEngine?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Handle Mac Catalyst specific setup
    #if targetEnvironment(macCatalyst)
    print("🖥️ Running in Mac Catalyst environment")
    #else
    print("📱 Running in native iOS environment")
    #endif
    
    // Initialize Flutter engine for hybrid functionality
    initializeFlutterEngine()
    
    // Create SwiftUI-first window
    setupSwiftUIWindow()
    
    return true
  }
  
  /// Initialize Flutter engine for embedding Flutter views when needed
  private func initializeFlutterEngine() {
    flutterEngine = FlutterEngine(name: "thriftwood_flutter_engine")
    flutterEngine?.run()
    
    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: flutterEngine!)
    
    print("✅ Flutter engine initialized for hybrid functionality")
  }
  
  /// Setup SwiftUI as the root view controller with native navigation
  private func setupSwiftUIWindow() {
    window = UIWindow(frame: UIScreen.main.bounds)
    
    // Create SwiftUI root view using MainAppCoordinatorView for proper navigation handling
    let rootView = MainAppCoordinatorView()
    let hostingController = UIHostingController(rootView: rootView)
    
    window?.rootViewController = hostingController
    window?.makeKeyAndVisible()
    
    // Initialize the Flutter bridge for hybrid functionality
    initializeHybridBridge()
    
    print("✅ SwiftUI window setup complete - Native NavigationStack enabled")
  }
  
  /// Initialize the Flutter-SwiftUI hybrid bridge for embedded Flutter views
  private func initializeHybridBridge() {
    guard let engine = flutterEngine else {
      print("❌ Error: Flutter engine not initialized")
      return
    }
    
    // Initialize the hybrid bridge with the Flutter engine  
    let flutterViewController = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
    FlutterSwiftUIBridge.shared.initialize(with: flutterViewController)
    
    print("✅ Hybrid bridge initialized - SwiftUI primary, Flutter embedded")
  }
  
  /// Handle URL schemes for deep linking
  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    // Handle deep links through the hybrid navigation coordinator
    let coordinator = HybridNavigationCoordinator()
    if coordinator.handleDeepLink(url, sourceApplication: options[.sourceApplication] as? String) {
      return true
    }
    
    // For SwiftUI-first architecture, we handle URLs directly
    return false
  }
}
