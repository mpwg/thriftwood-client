import 'package:flutter/material.dart';
import 'package:thriftwood/modules.dart';
import 'package:thriftwood/modules/settings.dart';

class ConfigurationTautulliConnectionDetailsHeadersRoute
    extends StatelessWidget {
  const ConfigurationTautulliConnectionDetailsHeadersRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsHeaderRoute(module: LunaModule.TAUTULLI);
  }
}
