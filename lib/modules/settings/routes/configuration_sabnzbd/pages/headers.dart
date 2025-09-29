import 'package:flutter/material.dart';
import 'package:thriftwood/modules.dart';
import 'package:thriftwood/modules/settings.dart';

class ConfigurationSABnzbdConnectionDetailsHeadersRoute
    extends StatelessWidget {
  const ConfigurationSABnzbdConnectionDetailsHeadersRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsHeaderRoute(module: LunaModule.SABNZBD);
  }
}
