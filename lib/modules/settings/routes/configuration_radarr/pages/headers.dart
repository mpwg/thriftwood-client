import 'package:flutter/material.dart';
import 'package:thriftwood/modules.dart';
import 'package:thriftwood/modules/settings.dart';

class ConfigurationRadarrConnectionDetailsHeadersRoute extends StatelessWidget {
  const ConfigurationRadarrConnectionDetailsHeadersRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsHeaderRoute(module: LunaModule.RADARR);
  }
}
