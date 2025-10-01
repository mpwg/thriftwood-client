import 'package:lunasea/system/bridge/native_bridge.dart';
import 'package:lunasea/system/bridge/hybrid_router.dart';
import 'package:lunasea/system/bridge/hive_bridge.dart';
import 'package:lunasea/system/bridge/dashboard_bridge_service.dart';

/// Bridge initialization for the hybrid Flutter/SwiftUI system
class BridgeInitializer {
  /// Private constructor to prevent instantiation
  BridgeInitializer._();

  /// Initialize the bridge system
  /// This should be called during app startup, after WidgetsFlutterBinding.ensureInitialized()
  static Future<void> initialize() async {
    // Initialize the hybrid router
    await HybridRouter.initialize();

    // Initialize the Hive data bridge for SwiftUI synchronization
    HiveBridge.initialize();

    // Initialize Dashboard bridge service for Phase 3
    await DashboardBridgeService.initialize();

    // Register any initial native views for Phase 1
    // This allows testing the bridge system immediately
    await NativeBridge.registerNativeView('/test');

    print('Bridge system initialized successfully');
  }
}
