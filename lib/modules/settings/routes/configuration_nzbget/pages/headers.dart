import 'package:flutter/material.dart';
import 'package:thriftwood/modules.dart';
import 'package:thriftwood/modules/settings.dart';

class ConfigurationNZBGetConnectionDetailsHeadersRoute extends StatelessWidget {
  const ConfigurationNZBGetConnectionDetailsHeadersRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsHeaderRoute(module: LunaModule.NZBGET);
  }
}
