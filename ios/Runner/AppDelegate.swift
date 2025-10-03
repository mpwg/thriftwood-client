import UIKit
import SwiftUI

@main
@objc class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
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
    
    // CRITICAL: Initialize SwiftData FIRST (pure Swift, no Flutter dependencies)
    Task { @MainActor in
      let _ = SwiftDataManager.shared // This initializes SwiftData on main actor
      print("✅ SwiftData initialized as primary storage")
    }
    
    // MIGRATION TEMPORARY: Initialize Flutter for hybrid functionality
    // TODO: Remove this when migration to pure SwiftUI is complete
    FlutterEngineManager.shared.initializeFlutterEngine()
    
    // Setup SwiftUI as the primary interface
    setupSwiftUIWindow()
    
    return true
  }
  
  /// Setup SwiftUI as the root view controller
  /// This is the permanent app structure that will remain after migration
  private func setupSwiftUIWindow() {
    window = UIWindow(frame: UIScreen.main.bounds)
    
    // Create SwiftUI root view - this is the permanent architecture
    let rootView = MainAppCoordinatorView()
    let hostingController = UIHostingController(rootView: rootView)
    
    window?.rootViewController = hostingController
    window?.makeKeyAndVisible()
    
    // MIGRATION TEMPORARY: Initialize hybrid bridge for Flutter integration
    // TODO: Remove this when migration to pure SwiftUI is complete
    Task {
      await FlutterEngineManager.shared.initializeHybridBridge(with: window)
    }
    
    print("✅ SwiftUI window setup complete - Native NavigationStack enabled")
    print("⚠️  Flutter hybrid support active (migration temporary)")
  }
  
  /// Handle URL schemes for deep linking
  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    
    // MIGRATION TEMPORARY: Handle deep links through hybrid system
    // TODO: Replace with pure SwiftUI deep linking when migration complete
    if FlutterEngineManager.shared.handleDeepLink(url, sourceApplication: options[.sourceApplication] as? String) {
      return true
    }
    
    // TODO: Add pure SwiftUI deep link handling here
    print("Deep link not handled: \(url)")
    return false
  }
  
  /// App termination cleanup
  func applicationWillTerminate(_ application: UIApplication) {
    // MIGRATION TEMPORARY: Cleanup Flutter resources
    // TODO: Remove this when migration to pure SwiftUI is complete
    FlutterEngineManager.shared.cleanup()
  }
}
