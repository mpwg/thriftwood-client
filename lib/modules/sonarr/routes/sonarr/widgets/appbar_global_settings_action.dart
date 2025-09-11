import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/sonarr.dart';

class SonarrAppBarGlobalSettingsAction extends StatelessWidget {
  const SonarrAppBarGlobalSettingsAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaIconButton(
      icon: Icons.more_vert_rounded,
      onPressed: () async {
        (bool, SonarrGlobalSettingsType?) values = await SonarrDialogs()
            .globalSettings(context);
        if (values.$1) values.$2!.execute(context);
      },
    );
  }
}
