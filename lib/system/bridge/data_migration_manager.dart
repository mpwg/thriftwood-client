import 'package:lunasea/core.dart';
import 'package:lunasea/system/bridge/swift_data_client.dart';

/// Manages the one-time migration from Flutter Hive to Swift SwiftData
/// Implements Phase 4.1 data persistence migration
class DataMigrationManager {
  /// Private constructor
  DataMigrationManager._();

  /// Singleton instance
  static final DataMigrationManager _instance = DataMigrationManager._();
  static DataMigrationManager get instance => _instance;

  /// Check if migration has been completed
  bool get isMigrationComplete {
    return LunaSeaDatabase.HIVE_TO_SWIFTDATA_MIGRATION_COMPLETE.read();
  }

  /// Perform the complete migration from Hive to SwiftData
  Future<bool> performMigration() async {
    if (isMigrationComplete) {
      LunaLogger().info('Migration already completed, skipping');
      return true;
    }

    try {
      LunaLogger().info('Starting migration from Hive to SwiftData...');

      // Step 1: Collect all data from Hive
      final migrationData = await _collectHiveData();

      // Step 2: Send data to Swift for SwiftData storage
      final success =
          await SwiftDataClient.instance.migrateFromHive(migrationData);

      if (success) {
        // Step 3: Mark migration as complete
        await _markMigrationComplete();

        // Step 4: Clear Hive data (optional - for cleanup)
        // await _clearHiveData();

        LunaLogger().info('Migration completed successfully');
        return true;
      } else {
        LunaLogger().error('Migration failed - Swift side returned false', null,
            StackTrace.current);
        return false;
      }
    } catch (e, stackTrace) {
      LunaLogger().error('Migration failed with exception', e, stackTrace);
      return false;
    }
  }

  /// Collect all relevant data from Hive storage
  Future<Map<String, dynamic>> _collectHiveData() async {
    final migrationData = <String, dynamic>{};

    // Collect all profiles
    final profiles = <Map<String, dynamic>>[];
    for (final profile in Database.profilesBox.values) {
      profiles.add(_profileToMap(profile));
    }
    migrationData['profiles'] = profiles;

    // Collect app settings
    migrationData['settings'] = _collectAppSettings();

    LunaLogger().info(
        'Collected ${profiles.length} profiles and app settings for migration');
    return migrationData;
  }

  /// Convert LunaProfile to Map for Swift consumption
  Map<String, dynamic> _profileToMap(LunaProfile profile) {
    return {
      'id': profile.key, // Hive key becomes Swift UUID string
      'name': profile.displayName,
      'isDefault': Database.profilesBox.get('default') == profile,

      // Lidarr
      'lidarrEnabled': profile.lidarrEnabled,
      'lidarrHost': profile.lidarrHost,
      'lidarrApiKey': profile.lidarrKey,
      'lidarrCustomHeaders': profile.lidarrHeaders ?? {},
      'lidarrStrictTLS': profile.lidarrStrictTLS,

      // Radarr
      'radarrEnabled': profile.radarrEnabled,
      'radarrHost': profile.radarrHost,
      'radarrApiKey': profile.radarrKey,
      'radarrCustomHeaders': profile.radarrHeaders ?? {},
      'radarrStrictTLS': profile.radarrStrictTLS,

      // Sonarr
      'sonarrEnabled': profile.sonarrEnabled,
      'sonarrHost': profile.sonarrHost,
      'sonarrApiKey': profile.sonarrKey,
      'sonarrCustomHeaders': profile.sonarrHeaders ?? {},
      'sonarrStrictTLS': profile.sonarrStrictTLS,

      // SABnzbd
      'sabnzbdEnabled': profile.sabnzbdEnabled,
      'sabnzbdHost': profile.sabnzbdHost,
      'sabnzbdApiKey': profile.sabnzbdKey,
      'sabnzbdCustomHeaders': profile.sabnzbdHeaders ?? {},
      'sabnzbdStrictTLS': profile.sabnzbdStrictTLS,

      // NZBGet
      'nzbgetEnabled': profile.nzbgetEnabled,
      'nzbgetHost': profile.nzbgetHost,
      'nzbgetUser': profile.nzbgetUser,
      'nzbgetPass': profile.nzbgetPassword,
      'nzbgetCustomHeaders': profile.nzbgetHeaders ?? {},
      'nzbgetStrictTLS': profile.nzbgetStrictTLS,

      // Tautulli
      'tautulliEnabled': profile.tautulliEnabled,
      'tautulliHost': profile.tautulliHost,
      'tautulliApiKey': profile.tautulliKey,
      'tautulliCustomHeaders': profile.tautulliHeaders ?? {},
      'tautulliStrictTLS': profile.tautulliStrictTLS,

      // Overseerr
      'overseerrEnabled': profile.overseerrEnabled,
      'overseerrHost': profile.overseerrHost,
      'overseerrApiKey': profile.overseerrKey,
      'overseerrCustomHeaders': profile.overseerrHeaders ?? {},
      'overseerrStrictTLS': profile.overseerrStrictTLS,

      // Wake on LAN
      'wakeOnLanEnabled': profile.wakeOnLANEnabled,
      'wakeOnLanMACAddress': profile.wakeOnLANMAC,
      'wakeOnLanBroadcastAddress': profile.wakeOnLANAddress,
    };
  }

  /// Collect app-wide settings from various Hive sources
  Map<String, dynamic> _collectAppSettings() {
    return {
      'enabledProfile': LunaSeaDatabase.ENABLED_PROFILE.read(),

      // Theme settings
      'themeAmoled': LunaSeaDatabase.THEME_AMOLED.read(),
      'themeAmoledBorder': LunaSeaDatabase.THEME_AMOLED_BORDER.read(),
      'themeImageBackgroundOpacity':
          LunaSeaDatabase.THEME_IMAGE_BACKGROUND_OPACITY.read(),

      // Drawer settings
      'drawerAutomaticManage': LunaSeaDatabase.DRAWER_AUTOMATIC_MANAGE.read(),
      'drawerManualOrder': LunaSeaDatabase.DRAWER_MANUAL_ORDER.read(),

      // Networking
      'networkingTLSValidation': LunaSeaDatabase.ALLOW_TLS_VALIDATION.read(),

      // Quick Actions
      'quickActionsLidarr': LunaSeaDatabase.QUICK_ACTIONS_LIDARR.read(),
      'quickActionsRadarr': LunaSeaDatabase.QUICK_ACTIONS_RADARR.read(),
      'quickActionsSonarr': LunaSeaDatabase.QUICK_ACTIONS_SONARR.read(),
      'quickActionsNZBGet': LunaSeaDatabase.QUICK_ACTIONS_NZBGET.read(),
      'quickActionsSABnzbd': LunaSeaDatabase.QUICK_ACTIONS_SABNZBD.read(),
      'quickActionsOverseerr': LunaSeaDatabase.QUICK_ACTIONS_OVERSEERR.read(),
      'quickActionsTautulli': LunaSeaDatabase.QUICK_ACTIONS_TAUTULLI.read(),
      'quickActionsSearch': LunaSeaDatabase.QUICK_ACTIONS_SEARCH.read(),

      // Other settings
      'use24HourTime': LunaSeaDatabase.USE_24_HOUR_TIME.read(),
      'enableInAppNotifications':
          LunaSeaDatabase.ENABLE_IN_APP_NOTIFICATIONS.read(),
      'changelogLastBuildVersion':
          LunaSeaDatabase.CHANGELOG_LAST_VERSION.read(),
    };
  }

  /// Mark migration as complete in both Flutter and Swift
  Future<void> _markMigrationComplete() async {
    // Mark in Flutter
    LunaSeaDatabase.HIVE_TO_SWIFTDATA_MIGRATION_COMPLETE.update(true);

    // Mark in Swift
    await SwiftDataClient.instance.markMigrationComplete();

    LunaLogger().info('Migration marked as complete on both platforms');
  }

  /// Optional: Clear Hive data after successful migration
  Future<void> _clearHiveData() async {
    try {
      // Note: Be very careful with this - only clear after confirming Swift migration worked
      // For now, we'll keep Hive data as backup until fully confident in SwiftData

      LunaLogger()
          .info('Hive data cleanup skipped (keeping as backup for now)');
    } catch (e, stackTrace) {
      LunaLogger().error('Failed to clear Hive data', e, stackTrace);
    }
  }

  /// Force re-migration (for testing purposes)
  Future<void> resetMigrationState() async {
    LunaSeaDatabase.HIVE_TO_SWIFTDATA_MIGRATION_COMPLETE.update(false);
    LunaLogger()
        .info('Migration state reset - will re-migrate on next attempt');
  }

  /// Check migration status and perform if needed
  Future<bool> ensureMigrationComplete() async {
    if (isMigrationComplete) {
      return true;
    }

    LunaLogger().info('Migration not complete, performing now...');
    return await performMigration();
  }
}
