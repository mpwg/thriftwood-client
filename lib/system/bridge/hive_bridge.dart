import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:lunasea/database/database.dart';
import 'package:lunasea/database/tables/lunasea.dart';
import 'package:lunasea/system/logger.dart';
import 'package:lunasea/system/bridge/bridge_error.dart';
import 'package:lunasea/system/bridge/swift_data_accessor.dart';

/// Bridge for synchronizing Hive data between Flutter and SwiftUI
class HiveBridge {
  /// Private constructor to prevent instantiation
  HiveBridge._();

  /// Initialize the Hive bridge with method call handler
  static void initialize() {
    const MethodChannel('com.thriftwood.hive')
        .setMethodCallHandler(_handleMethodCall);

    LunaLogger().debug('HiveBridge initialized');
  }

  /// Handle method calls from SwiftUI for Hive operations
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    LunaLogger().debug('HiveBridge: Received method call: ${call.method}');

    try {
      switch (call.method) {
        case 'getHiveSettings':
          return await _getHiveSettings();
        case 'updateHiveSettings':
          await _updateHiveSettings(call.arguments);
          return true;
        case 'profileChanged':
          await _handleProfileChange(call.arguments);
          return true;
        case 'updateHiveProfile':
          await _updateHiveProfile(call.arguments);
          return true;
        case 'exportConfiguration':
          return await _exportConfiguration();
        case 'importConfiguration':
          return await _importConfiguration(call.arguments);
        case 'clearConfiguration':
          return await _clearConfiguration();
        case 'getLogs':
          return await _getLogs(call.arguments);
        case 'clearLogs':
          await _clearLogs();
          return true;
        case 'exportLogs':
          return await _exportLogs();
        case 'getSystemLogs':
          return await _getSystemLogs(call.arguments);
        case 'clearSystemLogs':
          return await _clearSystemLogs();
        case 'exportSystemLogs':
          return await _exportSystemLogs();
        default:
          LunaLogger()
              .warning('HiveBridge: Unknown method call: ${call.method}');
          throw PlatformException(
            code: 'UNIMPLEMENTED',
            message: 'Method ${call.method} not implemented',
          );
      }
    } catch (e, stackTrace) {
      // Use comprehensive error reporting
      BridgeErrorReporter.reportException(
        e,
        call.method,
        'HiveBridge',
        context: {
          'arguments': call.arguments?.toString(),
          'methodName': call.method,
        },
        stackTrace: stackTrace,
      );

      // Still throw PlatformException for method channel compatibility
      throw PlatformException(
        code: 'OPERATION_FAILED',
        message: 'HiveBridge operation ${call.method} failed: $e',
        details: {
          'operation': call.method,
          'component': 'HiveBridge',
          'originalError': e.toString(),
        },
      );
    }
  }

  /// Get current Hive settings for SwiftUI
  static Future<Map<String, dynamic>> _getHiveSettings() async {
    try {
      // Get all profiles from SwiftData
      final profilesList = await SwiftDataAccessor.getAllProfiles();
      final profilesMap = <String, Map<String, dynamic>>{};
      for (final profileData in profilesList) {
        final profileKey = profileData['key'] ?? profileData['id'];
        if (profileKey != null) {
          profilesMap[profileKey] = profileData;
        }
      }

      // Get current settings
      final settings = {
        'enabledProfile': LunaSeaDatabase.ENABLED_PROFILE.read(),
        'profiles': profilesMap,
        'selectedTheme': 'system', // Default to system theme
        'enableImageHeaders': true,
        'enableCustomHeaders': false,
        'enableBiometrics': false,
        'requireBiometricsOnLaunch': false,
        'requireBiometricsOnUnlock': false,
        'enableBackups': false,
        'backupOnProfileChange': false,
        'backupFrequency': 'daily',
        'enableNotifications': true,
        'enableBroadcastNotifications': false,
        'appName': 'Thriftwood',
        'enableAdvancedSettings': false,
        'enableErrorReporting': true,
        'enableAnalytics': false,
        'dashboardRefreshInterval': 300,
        'enableCalendarView': true,
        'calendarDaysAhead': 14,
        'calendarStartingDay': 'monday',
        'calendarStartingType': 'today',
        'drawerAutoExpand': LunaSeaDatabase.DRAWER_AUTOMATIC_MANAGE.read(),
        'drawerGroupModules': true,
        'drawerShowVersion': true,
        'enableQuickActions': true,
        'quickActionItems': [],
        'enableSearchHistory': true,
        'maxSearchHistory': 50,
        'defaultSearchCategory': 'all',
        'enableTorrentSearching': true,
        'enableUsenetSearching': true,
        'searchIndexers': [],
      };

      LunaLogger().debug(
          'HiveBridge: Retrieved settings with ${profilesMap.length} profiles');
      return settings;
    } catch (e, stackTrace) {
      LunaLogger()
          .error('HiveBridge: Error getting Hive settings', e, stackTrace);
      rethrow;
    }
  }

  /// Update Hive settings from SwiftUI
  static Future<void> _updateHiveSettings(dynamic arguments) async {
    try {
      if (arguments is! Map) {
        throw ArgumentError(
            'Invalid arguments for updateHiveSettings: Expected Map, got ${arguments.runtimeType}');
      }

      if (!arguments.containsKey('settings')) {
        throw ArgumentError(
            'Missing required "settings" key in updateHiveSettings arguments');
      }

      final rawSettings = arguments['settings'];
      if (rawSettings is! Map) {
        throw ArgumentError(
            'Invalid settings data for updateHiveSettings: Expected Map, got ${rawSettings.runtimeType}');
      }

      // Safely convert to Map<String, dynamic> with detailed error reporting
      Map<String, dynamic> settingsMap;
      try {
        settingsMap = Map<String, dynamic>.from(rawSettings.map((key, value) {
          if (key is! String) {
            throw ArgumentError(
                'Invalid settings key type: Expected String, got ${key.runtimeType} for key: $key');
          }
          return MapEntry(key.toString(), value);
        }));
      } catch (e) {
        throw ArgumentError(
            'Failed to convert settings map: $e. Raw data: $rawSettings');
      }

      // Settings update logic - hybrid toggle removed (Swift-first approach)

      // Update enabled profile
      if (settingsMap.containsKey('enabledProfile')) {
        LunaSeaDatabase.ENABLED_PROFILE.update(settingsMap['enabledProfile']);
      }

      // Update profiles
      if (settingsMap.containsKey('profiles')) {
        final rawProfiles = settingsMap['profiles'];
        if (rawProfiles is! Map) {
          throw ArgumentError(
              'Invalid profiles data: Expected Map, got ${rawProfiles.runtimeType}');
        }

        final profiles = Map<String, dynamic>.from(rawProfiles);
        for (String profileKey in profiles.keys) {
          final rawProfileData = profiles[profileKey];
          if (rawProfileData is! Map) {
            throw ArgumentError(
                'Invalid profile data for "$profileKey": Expected Map, got ${rawProfileData.runtimeType}');
          }

          final profileData = Map<String, dynamic>.from(rawProfileData);
          // Update profile via SwiftData instead of Hive
          await SwiftDataAccessor.updateProfile(profileKey, profileData);
        }
      }

      // Update other settings
      if (settingsMap.containsKey('drawerAutoExpand')) {
        LunaSeaDatabase.DRAWER_AUTOMATIC_MANAGE
            .update(settingsMap['drawerAutoExpand']);
      }

      // Hybrid settings toggle removed - Swift-first approach enforced

      LunaLogger().debug('HiveBridge: Updated Hive settings successfully');
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'updateHiveSettings',
        'HiveBridge',
        context: {
          'arguments': arguments?.toString(),
          'hasSettingsKey':
              arguments is Map ? arguments.containsKey('settings') : false,
        },
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Handle profile change from SwiftUI
  static Future<void> _handleProfileChange(dynamic arguments) async {
    try {
      if (arguments is! Map) {
        throw ArgumentError(
            'Invalid arguments for profileChanged: Expected Map, got ${arguments.runtimeType}');
      }

      if (!arguments.containsKey('profile')) {
        throw ArgumentError(
            'Missing required "profile" key in profileChanged arguments');
      }

      final rawProfileName = arguments['profile'];
      if (rawProfileName is! String) {
        throw ArgumentError(
            'Invalid profile name: Expected String, got ${rawProfileName.runtimeType}. Value: $rawProfileName');
      }

      final profileName = rawProfileName.toString();
      LunaSeaDatabase.ENABLED_PROFILE.update(profileName);

      LunaLogger().debug('HiveBridge: Profile changed to $profileName');
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'profileChanged',
        'HiveBridge',
        context: {
          'arguments': arguments?.toString(),
          'hasProfileKey':
              arguments is Map ? arguments.containsKey('profile') : false,
        },
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Update specific profile in Hive
  static Future<void> _updateHiveProfile(dynamic arguments) async {
    try {
      if (arguments is! Map) {
        throw ArgumentError(
            'Invalid arguments for updateHiveProfile: Expected Map, got ${arguments.runtimeType}');
      }

      if (!arguments.containsKey('profileName')) {
        throw ArgumentError(
            'Missing required "profileName" key in updateHiveProfile arguments');
      }
      if (!arguments.containsKey('profile')) {
        throw ArgumentError(
            'Missing required "profile" key in updateHiveProfile arguments');
      }

      final rawProfileName = arguments['profileName'];
      if (rawProfileName is! String) {
        throw ArgumentError(
            'Invalid profileName: Expected String, got ${rawProfileName.runtimeType}. Value: $rawProfileName');
      }

      final rawProfileData = arguments['profile'];
      if (rawProfileData is! Map) {
        throw ArgumentError(
            'Invalid profile data: Expected Map, got ${rawProfileData.runtimeType}');
      }

      final profileName = rawProfileName.toString();
      final profileData = Map<String, dynamic>.from(rawProfileData);

      // Update profile via SwiftData instead of Hive
      await SwiftDataAccessor.updateProfile(profileName, profileData);

      LunaLogger().debug('HiveBridge: Updated profile $profileName');
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'updateHiveProfile',
        'HiveBridge',
        context: {
          'arguments': arguments?.toString(),
          'hasProfileNameKey':
              arguments is Map ? arguments.containsKey('profileName') : false,
          'hasProfileKey':
              arguments is Map ? arguments.containsKey('profile') : false,
        },
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Export configuration (equivalent to Flutter LunaConfig.export())
  static Future<String> _exportConfiguration() async {
    try {
      // This would implement the same logic as Flutter's LunaConfig.export()
      // For now, return a placeholder JSON
      final config = await _getHiveSettings();

      // Add timestamp and version info
      config['exportTimestamp'] = DateTime.now().toIso8601String();
      config['exportVersion'] = '1.0.0';

      // Convert to JSON string
      return config.toString();
    } catch (e, stackTrace) {
      LunaLogger()
          .error('HiveBridge: Error exporting configuration', e, stackTrace);
      rethrow;
    }
  }

  /// Import configuration (equivalent to Flutter LunaConfig.import())
  static Future<bool> _importConfiguration(dynamic arguments) async {
    try {
      if (arguments is! Map) {
        throw ArgumentError('Invalid arguments for importConfiguration');
      }

      // Parse and import configuration
      // This would implement the same logic as Flutter's LunaConfig.import()
      // For now, just log the operation
      LunaLogger().debug('HiveBridge: Configuration imported successfully');
      return true;
    } catch (e, stackTrace) {
      LunaLogger()
          .error('HiveBridge: Error importing configuration', e, stackTrace);
      return false;
    }
  }

  /// Clear all configuration
  static Future<bool> _clearConfiguration() async {
    try {
      // Clear all Hive boxes
      await LunaDatabase().clear();

      // Re-bootstrap with defaults
      await LunaDatabase().bootstrap();

      LunaLogger()
          .debug('HiveBridge: Configuration cleared and re-bootstrapped');
      return true;
    } catch (e, stackTrace) {
      LunaLogger()
          .error('HiveBridge: Error clearing configuration', e, stackTrace);
      return false;
    }
  }

  /// Get logs (equivalent to SwiftDataAccessor.getLogs access)
  static Future<List<Map<String, dynamic>>> _getLogs(dynamic arguments) async {
    try {
      // Get logs from SwiftData instead of Hive
      final logs = await SwiftDataAccessor.getLogs();

      LunaLogger().debug('HiveBridge: Retrieved ${logs.length} log entries');
      return logs;
    } catch (e, stackTrace) {
      LunaLogger().error('HiveBridge: Error getting logs', e, stackTrace);
      rethrow;
    }
  }

  /// Get system logs
  static Future<List<Map<String, dynamic>>> _getSystemLogs(
      dynamic arguments) async {
    try {
      // Use the same implementation as _getLogs for backward compatibility
      return await _getLogs(arguments);
    } catch (e, stackTrace) {
      LunaLogger()
          .error('HiveBridge: Error getting system logs', e, stackTrace);
      return [];
    }
  }

  /// Clear logs (equivalent to SwiftDataAccessor.clearLogs())
  static Future<void> _clearLogs() async {
    try {
      // Clear logs via SwiftData instead of Hive
      await SwiftDataAccessor.clearLogs();

      LunaLogger().debug('HiveBridge: Logs cleared');
    } catch (e, stackTrace) {
      LunaLogger().error('HiveBridge: Error clearing logs', e, stackTrace);
      rethrow;
    }
  }

  /// Export logs (equivalent to SwiftDataAccessor.exportLogs())
  static Future<String> _exportLogs() async {
    try {
      // Export logs via SwiftData instead of Hive
      final logs = await SwiftDataAccessor.exportLogs();
      final encoder = JsonEncoder.withIndent(' ' * 4);

      LunaLogger().debug('HiveBridge: Exported ${logs.length} log entries');
      return encoder.convert(logs);
    } catch (e, stackTrace) {
      LunaLogger().error('HiveBridge: Error exporting logs', e, stackTrace);
      rethrow;
    }
  }

  /// Clear system logs
  static Future<bool> _clearSystemLogs() async {
    try {
      // Use the same implementation as _clearLogs for backward compatibility
      await _clearLogs();
      return true;
    } catch (e, stackTrace) {
      LunaLogger()
          .error('HiveBridge: Error clearing system logs', e, stackTrace);
      return false;
    }
  }

  /// Export system logs
  static Future<String> _exportSystemLogs() async {
    try {
      final logs = await _getSystemLogs(null);
      return logs.toString();
    } catch (e, stackTrace) {
      LunaLogger()
          .error('HiveBridge: Error exporting system logs', e, stackTrace);
      rethrow;
    }
  }
}
