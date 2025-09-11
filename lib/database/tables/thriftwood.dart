import 'package:thriftwood/database/models/external_module.dart';
import 'package:thriftwood/database/models/indexer.dart';
import 'package:thriftwood/database/models/log.dart';
import 'package:thriftwood/database/models/profile.dart';
import 'package:thriftwood/types/indexer_icon.dart';
import 'package:thriftwood/types/list_view_option.dart';
import 'package:thriftwood/modules.dart';
import 'package:thriftwood/database/table.dart';
import 'package:thriftwood/types/log_type.dart';
import 'package:thriftwood/vendor.dart';
import 'package:thriftwood/widgets/ui.dart';

enum thriftwoodDatabase<T> with LunaTableMixin<T> {
  ANDROID_BACK_OPENS_DRAWER<bool>(true),
  DRAWER_AUTOMATIC_MANAGE<bool>(true),
  DRAWER_MANUAL_ORDER<List>([]),
  ENABLED_PROFILE<String>(LunaProfile.DEFAULT_PROFILE),
  NETWORKING_TLS_VALIDATION<bool>(false),
  THEME_AMOLED<bool>(false),
  THEME_AMOLED_BORDER<bool>(false),
  THEME_IMAGE_BACKGROUND_OPACITY<int>(20),
  QUICK_ACTIONS_LIDARR<bool>(false),
  QUICK_ACTIONS_RADARR<bool>(false),
  QUICK_ACTIONS_SONARR<bool>(false),
  QUICK_ACTIONS_NZBGET<bool>(false),
  QUICK_ACTIONS_SABNZBD<bool>(false),
  QUICK_ACTIONS_OVERSEERR<bool>(false),
  QUICK_ACTIONS_TAUTULLI<bool>(false),
  QUICK_ACTIONS_SEARCH<bool>(false),
  USE_24_HOUR_TIME<bool>(false),
  ENABLE_IN_APP_NOTIFICATIONS<bool>(true),
  CHANGELOG_LAST_BUILD_VERSION<int>(0);

  @override
  LunaTable get table => LunaTable.thriftwood;

  @override
  final T fallback;

  const thriftwoodDatabase(this.fallback);

  @override
  void register() {
    Hive.registerAdapter(LunaExternalModuleAdapter());
    Hive.registerAdapter(LunaIndexerAdapter());
    Hive.registerAdapter(LunaProfileAdapter());
    Hive.registerAdapter(LunaLogAdapter());
    Hive.registerAdapter(LunaIndexerIconAdapter());
    Hive.registerAdapter(LunaLogTypeAdapter());
    Hive.registerAdapter(LunaModuleAdapter());
    Hive.registerAdapter(LunaListViewOptionAdapter());
  }

  @override
  dynamic export() {
    thriftwoodDatabase db = this;
    switch (db) {
      case thriftwoodDatabase.DRAWER_MANUAL_ORDER:
        return LunaDrawer.moduleOrderedList()
            .map<String>((module) => module.key)
            .toList();
      default:
        return super.export();
    }
  }

  @override
  void import(dynamic value) {
    thriftwoodDatabase db = this;
    dynamic result;

    switch (db) {
      case thriftwoodDatabase.DRAWER_MANUAL_ORDER:
        List<LunaModule> item = [];
        (value as List).cast<String>().forEach((val) {
          LunaModule? module = LunaModule.fromKey(val);
          if (module != null) item.add(module);
        });
        result = item;
        break;
      default:
        result = value;
        break;
    }

    return super.import(result);
  }
}
