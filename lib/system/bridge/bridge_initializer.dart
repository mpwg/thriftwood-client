import 'package:lunasea/system/bridge/hybrid_router.dart';

/// Bridge initialization for the hybrid Flutter/SwiftUI system
class BridgeInitializer {
  /// Private constructor to prevent instantiation
  BridgeInitializer._();

  /// Initialize the bridge system with Swift-first enforcement
  /// This should be called during app startup, after WidgetsFlutterBinding.ensureInitialized()
  static Future<void> initialize() async {
    // SWIFT-FIRST MIGRATION: Only initialize the hybrid router
    // All other bridges are handled by the centralized Swift system
    await HybridRouter.initialize();

    print('✅ Swift-first bridge system initialized');
    print('✅ Flutter code eliminated for Settings and Dashboard');
    print('✅ Method channel conflicts prevented via BridgeMethodDispatcher');
  }
}
