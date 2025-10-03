import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:lunasea/system/bridge/bridge_error.dart';

/// Universal data accessor that routes all data operations through SwiftData bridge
/// Replaces all direct Hive database access with SwiftData bridge calls
/// SwiftData is the single source of truth for all data persistence
class SwiftDataAccessor {
  /// Private constructor to prevent instantiation
  SwiftDataAccessor._();

  /// Singleton instance
  static final SwiftDataAccessor _instance = SwiftDataAccessor._();
  static SwiftDataAccessor get instance => _instance;

  /// Method channel for communicating with SwiftData bridge
  static const MethodChannel _channel = MethodChannel('com.thriftwood.bridge');

  // MARK: - Profile Operations

  /// Get all profiles from SwiftData
  static Future<List<Map<String, dynamic>>> getAllProfiles() async {
    try {
      final result = await _channel.invokeMethod('profile.getAll');
      return List<Map<String, dynamic>>.from(result);
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'profile.getAll',
        'SwiftDataAccessor',
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// Get a specific profile by ID
  static Future<Map<String, dynamic>?> getProfile(String id) async {
    try {
      final result = await _channel.invokeMethod('profile.get', {'id': id});
      return result != null ? Map<String, dynamic>.from(result) : null;
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'profile.get',
        'SwiftDataAccessor',
        context: {'profileId': id},
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Create a new profile
  static Future<Map<String, dynamic>?> createProfile(
      Map<String, dynamic> profileData) async {
    try {
      final result = await _channel.invokeMethod('profile.create', profileData);
      return result != null ? Map<String, dynamic>.from(result) : null;
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'profile.create',
        'SwiftDataAccessor',
        context: {'profileData': profileData.keys.toList()},
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Update an existing profile
  static Future<Map<String, dynamic>?> updateProfile(
      String id, Map<String, dynamic> profileData) async {
    try {
      final data = Map<String, dynamic>.from(profileData);
      data['id'] = id;
      final result = await _channel.invokeMethod('profile.update', data);
      return result != null ? Map<String, dynamic>.from(result) : null;
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'profile.update',
        'SwiftDataAccessor',
        context: {'profileId': id, 'profileData': profileData.keys.toList()},
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Delete a profile
  static Future<bool> deleteProfile(String id) async {
    try {
      final result = await _channel.invokeMethod('profile.delete', {'id': id});
      return result == true;
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'profile.delete',
        'SwiftDataAccessor',
        context: {'profileId': id},
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  // MARK: - Settings Operations

  /// Get all app settings
  static Future<Map<String, dynamic>> getAppSettings() async {
    return await getSettings();
  }

  /// Get all app settings
  static Future<Map<String, dynamic>> getSettings() async {
    try {
      final result = await _channel.invokeMethod('settings.get');
      return result != null
          ? Map<String, dynamic>.from(result)
          : <String, dynamic>{};
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'settings.get',
        'SwiftDataAccessor',
        stackTrace: stackTrace,
      );
      return <String, dynamic>{};
    }
  }

  /// Update app settings
  static Future<Map<String, dynamic>?> updateSettings(
      Map<String, dynamic> settingsData) async {
    try {
      final result =
          await _channel.invokeMethod('settings.update', settingsData);
      return result != null ? Map<String, dynamic>.from(result) : null;
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'settings.update',
        'SwiftDataAccessor',
        context: {'settingsData': settingsData.keys.toList()},
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // MARK: - Indexer Operations

  /// Get all indexers from SwiftData
  static Future<List<Map<String, dynamic>>> getAllIndexers() async {
    try {
      final result = await _channel.invokeMethod('indexer.getAll');
      return List<Map<String, dynamic>>.from(result);
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'indexer.getAll',
        'SwiftDataAccessor',
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// Get a specific indexer by ID
  static Future<Map<String, dynamic>?> getIndexer(String id) async {
    try {
      final result = await _channel.invokeMethod('indexer.get', {'id': id});
      return result != null ? Map<String, dynamic>.from(result) : null;
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'indexer.get',
        'SwiftDataAccessor',
        context: {'indexerId': id},
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Create a new indexer
  static Future<Map<String, dynamic>?> createIndexer(
      Map<String, dynamic> indexerData) async {
    try {
      final result = await _channel.invokeMethod('indexer.create', indexerData);
      return result != null ? Map<String, dynamic>.from(result) : null;
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'indexer.create',
        'SwiftDataAccessor',
        context: {'indexerData': indexerData.keys.toList()},
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Update an existing indexer
  static Future<Map<String, dynamic>?> updateIndexer(
      String id, Map<String, dynamic> indexerData) async {
    try {
      final data = Map<String, dynamic>.from(indexerData);
      data['id'] = id;
      final result = await _channel.invokeMethod('indexer.update', data);
      return result != null ? Map<String, dynamic>.from(result) : null;
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'indexer.update',
        'SwiftDataAccessor',
        context: {'indexerId': id, 'indexerData': indexerData.keys.toList()},
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Delete an indexer
  static Future<bool> deleteIndexer(String id) async {
    try {
      final result = await _channel.invokeMethod('indexer.delete', {'id': id});
      return result == true;
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'indexer.delete',
        'SwiftDataAccessor',
        context: {'indexerId': id},
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  // MARK: - Logging Operations (OSLog Integration)

  /// Write a log entry (forwards to OSLog)
  static Future<bool> writeLog({
    required String message,
    required String type,
    String? className,
    String? methodName,
    String? error,
  }) async {
    try {
      final logData = {
        'message': message,
        'type': type,
        'className': className,
        'methodName': methodName,
        'error': error,
      };
      final result = await _channel.invokeMethod('log.write', logData);
      return result == true;
    } catch (e) {
      // Fallback to debug print if bridge fails to avoid circular dependency
      if (kDebugMode) print('Failed to write log to OSLog bridge: $e');
      return false;
    }
  }

  /// Get recent logs from OSLog
  static Future<List<Map<String, dynamic>>> getLogs({int limit = 250}) async {
    try {
      final result = await _channel.invokeMethod('log.get', {'limit': limit});
      return List<Map<String, dynamic>>.from(result);
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'log.get',
        'SwiftDataAccessor',
        context: {'limit': limit},
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// Export recent logs from OSLog
  static Future<List<Map<String, dynamic>>> exportLogs(
      {int limit = 1000}) async {
    try {
      final result =
          await _channel.invokeMethod('log.export', {'limit': limit});
      return List<Map<String, dynamic>>.from(result);
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'log.export',
        'SwiftDataAccessor',
        context: {'limit': limit},
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// Clear logs (OSLog manages retention automatically)
  static Future<bool> clearLogs() async {
    try {
      final result = await _channel.invokeMethod('log.clear');
      return result == true;
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'log.clear',
        'SwiftDataAccessor',
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  // MARK: - Migration Operations

  /// Trigger full migration from Hive to SwiftData
  static Future<bool> migrateFromHive() async {
    try {
      final result = await _channel.invokeMethod('migration.fromHive');
      return result == true;
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'migration.fromHive',
        'SwiftDataAccessor',
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Check if migration is complete
  static Future<bool> isMigrationComplete() async {
    try {
      final result = await _channel.invokeMethod('migration.isComplete');
      return result == true;
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'migration.isComplete',
        'SwiftDataAccessor',
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Clear all profiles (admin operation)
  static Future<bool> clearAllProfiles() async {
    try {
      final result = await _channel.invokeMethod('profile.clearAll');
      return result == true;
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'profile.clearAll',
        'SwiftDataAccessor',
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Clear all indexers (admin operation)
  static Future<bool> clearAllIndexers() async {
    try {
      final result = await _channel.invokeMethod('indexer.clearAll');
      return result == true;
    } catch (e, stackTrace) {
      BridgeErrorReporter.reportException(
        e,
        'indexer.clearAll',
        'SwiftDataAccessor',
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}
