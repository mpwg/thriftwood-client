import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/tautulli.dart';

class TautulliAppBarGlobalSettingsAction extends StatelessWidget {
  const TautulliAppBarGlobalSettingsAction({super.key});

  @override
  Widget build(BuildContext context) {
    return LunaIconButton(
      icon: Icons.more_vert_rounded,
      onPressed: () async {
        (bool, TautulliGlobalSettingsType?) values =
            await TautulliDialogs().globalSettings(context);
        if (values.$1) values.$2!.execute(context);
      },
    );
  }
}
