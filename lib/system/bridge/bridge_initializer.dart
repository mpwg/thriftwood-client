import 'package:lunasea/system/bridge/hybrid_router.dart';
import 'package:lunasea/system/bridge/hive_bridge.dart';

/// Bridge initialization for the hybrid Flutter/SwiftUI system
class BridgeInitializer {
  /// Private constructor to prevent instantiation
  BridgeInitializer._();

  /// Initialize the bridge system with Swift-first enforcement
  /// This should be called during app startup, after WidgetsFlutterBinding.ensureInitialized()
  static Future<void> initialize() async {
    // CRITICAL: Initialize HiveBridge to handle method calls from DataLayerManager
    // Even though Hive is removed, the bridge handles SwiftData method calls
    HiveBridge.initialize();

    // Initialize hybrid router for navigation
    await HybridRouter.initialize();

    print('✅ Swift-first bridge system initialized');
    print('✅ HiveBridge handling method calls from DataLayerManager');
    print('✅ Method channel conflicts prevented via BridgeMethodDispatcher');
    print('✅ SwiftData is single source of truth with Flutter bridge access');
  }
}
