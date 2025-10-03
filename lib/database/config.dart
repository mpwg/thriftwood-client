import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/database/database.dart';
import 'package:lunasea/database/table.dart';
import 'package:lunasea/system/bridge/swift_data_accessor.dart';

class LunaConfig {
  Future<void> import(BuildContext context, String data) async {
    await LunaDatabase().clear();

    try {
      Map<String, dynamic> config = json.decode(data);

      await _setProfiles(config['profiles']);
      await _setIndexers(config['indexers']);
      for (final table in LunaTable.values) table.import(config[table.key]);

      if (!LunaProfile.list.contains(LunaSeaDatabase.ENABLED_PROFILE.read())) {
        LunaSeaDatabase.ENABLED_PROFILE.update(LunaProfile.list[0]);
      }
    } catch (error, stack) {
      await LunaDatabase().bootstrap();
      LunaLogger().error(
        'Failed to import configuration, resetting to default',
        error,
        stack,
      );
    }

    LunaState.reset(context);
  }

  Future<String> export() async {
    Map<String, dynamic> config = {};

    // Export indexers and profiles from SwiftData
    config['indexers'] = await SwiftDataAccessor.getAllIndexers();
    config['profiles'] = await SwiftDataAccessor.getAllProfiles();

    for (final table in LunaTable.values) config[table.key] = table.export();

    return json.encode(config);
  }

  Future<void> _setProfiles(List? data) async {
    if (data == null) return;

    for (final item in data) {
      final content = (item as Map).cast<String, dynamic>();
      final key = content['key'] ?? content['id'] ?? 'default';
      // Update profile via SwiftData instead of Hive
      await SwiftDataAccessor.updateProfile(key, content);
    }
  }

  Future<void> _setIndexers(List? data) async {
    if (data == null) return;

    for (final indexerData in data) {
      final content = (indexerData as Map).cast<String, dynamic>();
      // Create indexer via SwiftData instead of Hive
      await SwiftDataAccessor.createIndexer(content);
    }
  }
}
