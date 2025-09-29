import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/radarr.dart';

class RadarrAppBarGlobalSettingsAction extends StatelessWidget {
  const RadarrAppBarGlobalSettingsAction({super.key});

  @override
  Widget build(BuildContext context) {
    return LunaIconButton(
      icon: Icons.more_vert_rounded,
      iconSize: LunaUI.ICON_SIZE,
      onPressed: () async {
        (bool, RadarrGlobalSettingsType?) values =
            await RadarrDialogs().globalSettings(context);
        if (values.$1) values.$2!.execute(context);
      },
    );
  }
}
