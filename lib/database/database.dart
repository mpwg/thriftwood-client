import 'package:thriftwood/database/box.dart';
import 'package:thriftwood/database/models/profile.dart';
import 'package:thriftwood/database/table.dart';
import 'package:thriftwood/database/tables/thriftwood.dart';
import 'package:thriftwood/system/filesystem/filesystem.dart';
import 'package:thriftwood/system/platform.dart';
import 'package:thriftwood/vendor.dart';

class LunaDatabase {
  static const String _DATABASE_LEGACY_PATH = 'database';
  static const String _DATABASE_PATH = 'thriftwood/database';

  String get path {
    if (LunaPlatform.isWindows || LunaPlatform.isLinux) return _DATABASE_PATH;
    return _DATABASE_LEGACY_PATH;
  }

  Future<void> initialize() async {
    await Hive.initFlutter(path);
    LunaTable.register();
    await open();
  }

  Future<void> open() async {
    await LunaBox.open();
    if (LunaBox.profiles.isEmpty) await bootstrap();
  }

  Future<void> nuke() async {
    await Hive.close();

    for (final box in LunaBox.values) {
      await Hive.deleteBoxFromDisk(box.key, path: path);
    }

    if (LunaFileSystem.isSupported) {
      await LunaFileSystem().nuke();
    }
  }

  Future<void> bootstrap() async {
    const defaultProfile = LunaProfile.DEFAULT_PROFILE;
    await clear();

    LunaBox.profiles.update(defaultProfile, LunaProfile());
    thriftwoodDatabase.ENABLED_PROFILE.update(defaultProfile);
  }

  Future<void> clear() async {
    for (final box in LunaBox.values) await box.clear();
  }

  Future<void> deinitialize() async {
    await Hive.close();
  }
}
