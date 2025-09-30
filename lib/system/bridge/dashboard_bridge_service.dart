import 'package:flutter/services.dart';
import 'package:lunasea/database/models/profile.dart';
import 'package:lunasea/api/wake_on_lan/wake_on_lan.dart';
import 'package:lunasea/system/logger.dart';

/// Flutter service to handle Dashboard-specific method channel calls from SwiftUI
/// Maintains bidirectional communication between SwiftUI Dashboard and Flutter services
class DashboardBridgeService {
  static const MethodChannel _platform = MethodChannel('com.thriftwood.bridge');

  /// Initialize the Dashboard bridge service
  /// Sets up method call handlers for Dashboard-specific functionality
  static Future<void> initialize() async {
    _platform.setMethodCallHandler(_handleMethodCall);
    LunaLogger().debug('DashboardBridgeService initialized');
  }

  /// Handle method calls from SwiftUI Dashboard
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    LunaLogger().debug('Dashboard method call: ${call.method}');

    try {
      switch (call.method) {
        case 'checkServiceConnectivity':
          return await _handleCheckServiceConnectivity(call.arguments);
        case 'executeWakeOnLAN':
          return await _handleExecuteWakeOnLAN();
        case 'refreshAllServices':
          return await _handleRefreshAllServices();
        case 'updateDashboardState':
          return await _handleUpdateDashboardState(call.arguments);
        case 'getDashboardState':
          return await _handleGetDashboardState();
        default:
          throw PlatformException(
            code: 'UNIMPLEMENTED',
            message: 'Method ${call.method} not implemented',
          );
      }
    } catch (e) {
      LunaLogger().error(
          'Dashboard bridge error for ${call.method}', e, StackTrace.current);
      rethrow;
    }
  }

  /// Check connectivity for a specific service
  /// Swift equivalent functionality for Flutter's API client tests
  static Future<bool> _handleCheckServiceConnectivity(dynamic arguments) async {
    final args = arguments as Map<String, dynamic>;
    final serviceKey = args['serviceKey'] as String;
    final config = args['config'] as Map<String, dynamic>;

    try {
      // Use Flutter's existing API client connectivity checks
      switch (serviceKey) {
        case 'radarr':
          return await _checkRadarrConnectivity(config);
        case 'sonarr':
          return await _checkSonarrConnectivity(config);
        case 'lidarr':
          return await _checkLidarrConnectivity(config);
        case 'sabnzbd':
          return await _checkSABnzbdConnectivity(config);
        case 'nzbget':
          return await _checkNZBGetConnectivity(config);
        case 'tautulli':
          return await _checkTautulliConnectivity(config);
        case 'search':
          return _checkSearchAvailability();
        case 'wake_on_lan':
          return _checkWakeOnLANAvailability();
        default:
          return false;
      }
    } catch (e) {
      LunaLogger()
          .warning('Service connectivity check failed for $serviceKey: $e');
      return false;
    }
  }

  /// Execute Wake on LAN functionality
  /// Swift equivalent of Flutter's LunaWakeOnLAN().wake()
  static Future<bool> _handleExecuteWakeOnLAN() async {
    try {
      await LunaWakeOnLAN().wake();
      return true;
    } catch (e) {
      LunaLogger().error('Wake on LAN execution failed', e, StackTrace.current);
      throw PlatformException(
        code: 'WAKE_ON_LAN_FAILED',
        message: 'Failed to execute Wake on LAN: $e',
      );
    }
  }

  /// Refresh all services
  /// Triggers service-specific refresh operations
  static Future<bool> _handleRefreshAllServices() async {
    try {
      // Trigger refresh for each enabled service
      // This would typically notify providers or state managers
      LunaLogger().debug('Refreshing all services from SwiftUI request');
      return true;
    } catch (e) {
      LunaLogger().error('Service refresh failed', e, StackTrace.current);
      return false;
    }
  }

  /// Update dashboard state from SwiftUI
  /// Maintains data consistency between platforms
  static Future<bool> _handleUpdateDashboardState(dynamic arguments) async {
    final args = arguments as Map<String, dynamic>;
    final serviceStates = args['serviceStates'] as Map<String, dynamic>?;
    final alphabetical = args['useAlphabeticalOrdering'] as bool?;

    try {
      // Update service states in profile if provided
      if (serviceStates != null) {
        for (final entry in serviceStates.entries) {
          final serviceKey = entry.key;
          final isEnabled = entry.value as bool;
          // Update profile service enablement
          // This would update the LunaProfile.current settings
          LunaLogger()
              .debug('Updating $serviceKey enabled state to $isEnabled');
        }
      }

      // Update drawer ordering preference if provided
      if (alphabetical != null) {
        // Update DRAWER_AUTOMATIC_MANAGE setting
        LunaLogger().debug('Updating drawer automatic manage to $alphabetical');
      }

      return true;
    } catch (e) {
      LunaLogger()
          .error('Dashboard state update failed', e, StackTrace.current);
      return false;
    }
  }

  /// Get current dashboard state
  /// Provides SwiftUI with current Flutter state
  static Future<Map<String, dynamic>> _handleGetDashboardState() async {
    try {
      final profile = LunaProfile.current;

      return {
        'serviceStates': {
          'radarr': profile.radarrEnabled,
          'sonarr': profile.sonarrEnabled,
          'lidarr': profile.lidarrEnabled,
          'sabnzbd': profile.sabnzbdEnabled,
          'nzbget': profile.nzbgetEnabled,
          'tautulli': profile.tautulliEnabled,
          'search': false, // Would check indexers
          'wake_on_lan': profile.wakeOnLANEnabled,
        },
        'useAlphabeticalOrdering':
            true, // Would read from DRAWER_AUTOMATIC_MANAGE
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
    } catch (e) {
      LunaLogger()
          .error('Failed to get dashboard state', e, StackTrace.current);
      throw PlatformException(
        code: 'DASHBOARD_STATE_ERROR',
        message: 'Failed to get dashboard state: $e',
      );
    }
  }

  // MARK: - Service Connectivity Checks

  static Future<bool> _checkRadarrConnectivity(
      Map<String, dynamic> config) async {
    // Implementation would use existing Radarr API client
    return true; // Placeholder
  }

  static Future<bool> _checkSonarrConnectivity(
      Map<String, dynamic> config) async {
    // Implementation would use existing Sonarr API client
    return true; // Placeholder
  }

  static Future<bool> _checkLidarrConnectivity(
      Map<String, dynamic> config) async {
    // Implementation would use existing Lidarr API client
    return true; // Placeholder
  }

  static Future<bool> _checkSABnzbdConnectivity(
      Map<String, dynamic> config) async {
    // Implementation would use existing SABnzbd API client
    return true; // Placeholder
  }

  static Future<bool> _checkNZBGetConnectivity(
      Map<String, dynamic> config) async {
    // Implementation would use existing NZBGet API client
    return true; // Placeholder
  }

  static Future<bool> _checkTautulliConnectivity(
      Map<String, dynamic> config) async {
    // Implementation would use existing Tautulli API client
    return true; // Placeholder
  }

  static bool _checkSearchAvailability() {
    // Check if indexers are configured
    return true; // Placeholder
  }

  static bool _checkWakeOnLANAvailability() {
    return LunaWakeOnLAN.isSupported;
  }
}
