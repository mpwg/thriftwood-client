import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:thriftwood/modules/dashboard/core/state.dart';
import 'package:thriftwood/modules/lidarr/core/state.dart';
import 'package:thriftwood/modules/radarr/core/state.dart';
import 'package:thriftwood/modules/search/core/state.dart';
import 'package:thriftwood/modules/settings/core/state.dart';
import 'package:thriftwood/modules/sonarr/core/state.dart';
import 'package:thriftwood/modules/sabnzbd/core/state.dart';
import 'package:thriftwood/modules/nzbget/core/state.dart';
import 'package:thriftwood/modules/tautulli/core/state.dart';
import 'package:thriftwood/modules.dart';
import 'package:thriftwood/router/router.dart';

class LunaState {
  LunaState._();

  static BuildContext get context => LunaRouter.navigator.currentContext!;

  /// Calls `.reset()` on all states which extend [LunaModuleState].
  static void reset([BuildContext? context]) {
    final ctx = context ?? LunaState.context;
    LunaModule.values.forEach((module) => module.state(ctx)?.reset());
  }

  static MultiProvider providers({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardState()),
        ChangeNotifierProvider(create: (_) => SettingsState()),
        ChangeNotifierProvider(create: (_) => SearchState()),
        ChangeNotifierProvider(create: (_) => LidarrState()),
        ChangeNotifierProvider(create: (_) => RadarrState()),
        ChangeNotifierProvider(create: (_) => SonarrState()),
        ChangeNotifierProvider(create: (_) => NZBGetState()),
        ChangeNotifierProvider(create: (_) => SABnzbdState()),
        ChangeNotifierProvider(create: (_) => TautulliState()),
      ],
      child: child,
    );
  }
}

abstract class LunaModuleState extends ChangeNotifier {
  /// Reset the state back to the default
  void reset();
}
