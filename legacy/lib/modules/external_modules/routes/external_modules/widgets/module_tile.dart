import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/database/models/external_module.dart';
import 'package:thriftwood/extensions/string/links.dart';

class ExternalModulesModuleTile extends StatelessWidget {
  final LunaExternalModule? module;

  const ExternalModulesModuleTile({Key? key, required this.module})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: module!.displayName,
      body: [TextSpan(text: module!.host)],
      trailing: const LunaIconButton.arrow(),
      onTap: module!.host.openLink,
    );
  }
}
