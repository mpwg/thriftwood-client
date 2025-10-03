import 'package:lunasea/database/models/profile.dart';
import 'package:lunasea/database/tables/lunasea.dart';
import 'package:lunasea/system/bridge/swift_data_accessor.dart';

class LunaDatabase {
  /// SwiftData-only database - no Hive, no migration
  /// All data operations are handled directly by SwiftData bridge
  Future<void> initialize() async {
    await open();
  }

  Future<void> open() async {
    // Ensure default profile exists in SwiftData
    final profiles = await SwiftDataAccessor.getAllProfiles();
    if (profiles.isEmpty) await bootstrap();
  }

  Future<void> nuke() async {
    // Clear all SwiftData tables
    await SwiftDataAccessor.clearAllProfiles();
    await SwiftDataAccessor.clearAllIndexers();
    await SwiftDataAccessor.clearLogs();
  }

  Future<void> bootstrap() async {
    const defaultProfile = LunaProfile.DEFAULT_PROFILE;

    // Create default profile in SwiftData
    final defaultProfileData = LunaProfile().toJson();
    defaultProfileData['profileKey'] =
        defaultProfile; // Add profile key to data
    await SwiftDataAccessor.createProfile(defaultProfileData);

    // Set as enabled profile
    LunaSeaDatabase.ENABLED_PROFILE.update(defaultProfile);
  }

  Future<void> clear() async {
    // Clear all SwiftData tables
    await SwiftDataAccessor.clearAllProfiles();
    await SwiftDataAccessor.clearAllIndexers();
    await SwiftDataAccessor.clearLogs();
  }

  Future<void> deinitialize() async {
    // No-op - SwiftData managed by iOS
  }
}
