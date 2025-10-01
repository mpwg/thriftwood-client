import 'package:flutter/services.dart';
import 'package:lunasea/system/logger.dart';

/// Client for accessing Swift SwiftData models from Flutter
/// Implements Phase 4.1 Swift-first migration strategy
class SwiftDataClient {
  /// Method channel for communicating with Swift
  static const _channel = MethodChannel('com.thriftwood.swift_data');

  /// Private constructor
  SwiftDataClient._();

  /// Singleton instance
  static final SwiftDataClient _instance = SwiftDataClient._();
  static SwiftDataClient get instance => _instance;

  // MARK: - Profile Management

  /// Get all profiles from Swift SwiftData
  Future<List<Map<String, dynamic>>> getAllProfiles() async {
    try {
      final result = await _channel.invokeMethod('profile.getAllProfiles');
      if (result is List) {
        return List<Map<String, dynamic>>.from(
            result.map((item) => Map<String, dynamic>.from(item)));
      }
      return [];
    } on PlatformException catch (e) {
      _logError('getAllProfiles', e);
      return [];
    }
  }

  /// Get the currently active profile from Swift SwiftData
  Future<Map<String, dynamic>?> getActiveProfile() async {
    try {
      final result = await _channel.invokeMethod('profile.getActiveProfile');
      if (result is Map) {
        return Map<String, dynamic>.from(result);
      }
      return null;
    } on PlatformException catch (e) {
      _logError('getActiveProfile', e);
      return null;
    }
  }

  /// Create a new profile in Swift SwiftData
  Future<Map<String, dynamic>?> createProfile(
      Map<String, dynamic> profileData) async {
    try {
      final result =
          await _channel.invokeMethod('profile.createProfile', profileData);
      if (result is Map) {
        return Map<String, dynamic>.from(result);
      }
      return null;
    } on PlatformException catch (e) {
      _logError('createProfile', e);
      return null;
    }
  }

  /// Update an existing profile in Swift SwiftData
  Future<Map<String, dynamic>?> updateProfile(
      Map<String, dynamic> profileData) async {
    try {
      final result =
          await _channel.invokeMethod('profile.updateProfile', profileData);
      if (result is Map) {
        return Map<String, dynamic>.from(result);
      }
      return null;
    } on PlatformException catch (e) {
      _logError('updateProfile', e);
      return null;
    }
  }

  /// Delete a profile from Swift SwiftData
  Future<bool> deleteProfile(String profileId) async {
    try {
      final result = await _channel
          .invokeMethod('profile.deleteProfile', {'id': profileId});
      return result == true;
    } on PlatformException catch (e) {
      _logError('deleteProfile', e);
      return false;
    }
  }

  /// Set a profile as the active profile in Swift SwiftData
  Future<bool> setActiveProfile(String profileId) async {
    try {
      final result = await _channel
          .invokeMethod('profile.setActiveProfile', {'id': profileId});
      return result == true;
    } on PlatformException catch (e) {
      _logError('setActiveProfile', e);
      return false;
    }
  }

  // MARK: - App Settings Management

  /// Get app settings from Swift SwiftData
  Future<Map<String, dynamic>> getAppSettings() async {
    try {
      final result = await _channel.invokeMethod('settings.getAppSettings');
      if (result is Map) {
        return Map<String, dynamic>.from(result);
      }
      return {};
    } on PlatformException catch (e) {
      _logError('getAppSettings', e);
      return {};
    }
  }

  /// Update app settings in Swift SwiftData
  Future<Map<String, dynamic>?> updateAppSettings(
      Map<String, dynamic> settingsData) async {
    try {
      final result = await _channel.invokeMethod(
          'settings.updateAppSettings', settingsData);
      if (result is Map) {
        return Map<String, dynamic>.from(result);
      }
      return null;
    } on PlatformException catch (e) {
      _logError('updateAppSettings', e);
      return null;
    }
  }

  // MARK: - Migration Support

  /// Migrate data from Flutter Hive to Swift SwiftData
  Future<bool> migrateFromHive(Map<String, dynamic> migrationData) async {
    try {
      final result = await _channel.invokeMethod(
          'migration.migrateFromHive', migrationData);
      return result == true;
    } on PlatformException catch (e) {
      _logError('migrateFromHive', e);
      return false;
    }
  }

  /// Check if migration from Hive to SwiftData is complete
  Future<bool> isMigrationComplete() async {
    try {
      final result =
          await _channel.invokeMethod('migration.isMigrationComplete');
      return result == true;
    } on PlatformException catch (e) {
      _logError('isMigrationComplete', e);
      return false;
    }
  }

  /// Mark migration as complete
  Future<bool> markMigrationComplete() async {
    try {
      final result =
          await _channel.invokeMethod('migration.markMigrationComplete');
      return result == true;
    } on PlatformException catch (e) {
      _logError('markMigrationComplete', e);
      return false;
    }
  }

  // MARK: - Error Handling

  /// Log platform exceptions with context
  void _logError(String method, PlatformException error) {
    LunaLogger().error(
      'SwiftDataClient.$method failed',
      error,
      StackTrace.current,
    );
  }
}

/// Extension to provide convenient access to specific data types
extension SwiftDataClientProfiles on SwiftDataClient {
  /// Get profiles as LunaProfile-compatible objects
  Future<List<LunaProfile>> getProfilesAsLunaProfiles() async {
    final profilesData = await getAllProfiles();
    return profilesData.map((data) => LunaProfile.fromSwiftData(data)).toList();
  }

  /// Get active profile as LunaProfile-compatible object
  Future<LunaProfile?> getActiveProfileAsLunaProfile() async {
    final profileData = await getActiveProfile();
    if (profileData != null) {
      return LunaProfile.fromSwiftData(profileData);
    }
    return null;
  }
}

/// Temporary LunaProfile class for compatibility during migration
/// This will be replaced by direct Swift data access eventually
class LunaProfile {
  final String id;
  final String name;
  final bool isDefault;

  // Service configurations
  final bool lidarrEnabled;
  final String lidarrHost;
  final String lidarrApiKey;
  // ... other service fields

  LunaProfile({
    required this.id,
    required this.name,
    required this.isDefault,
    required this.lidarrEnabled,
    required this.lidarrHost,
    required this.lidarrApiKey,
    // ... other service parameters
  });

  /// Create LunaProfile from Swift data
  factory LunaProfile.fromSwiftData(Map<String, dynamic> data) {
    return LunaProfile(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      isDefault: data['isDefault'] ?? false,
      lidarrEnabled: data['lidarrEnabled'] ?? false,
      lidarrHost: data['lidarrHost'] ?? '',
      lidarrApiKey: data['lidarrApiKey'] ?? '',
      // ... map other service fields from data
    );
  }

  /// Convert to dictionary for Swift bridge
  Map<String, dynamic> toSwiftData() {
    return {
      'id': id,
      'name': name,
      'isDefault': isDefault,
      'lidarrEnabled': lidarrEnabled,
      'lidarrHost': lidarrHost,
      'lidarrApiKey': lidarrApiKey,
      // ... include other service fields
    };
  }
}
