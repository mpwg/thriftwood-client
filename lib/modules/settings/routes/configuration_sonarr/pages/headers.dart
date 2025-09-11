import 'package:flutter/material.dart';
import 'package:thriftwood/modules.dart';
import 'package:thriftwood/modules/settings.dart';

class ConfigurationSonarrConnectionDetailsHeadersRoute extends StatelessWidget {
  const ConfigurationSonarrConnectionDetailsHeadersRoute({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SettingsHeaderRoute(module: LunaModule.SONARR);
  }
}
