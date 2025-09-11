import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/tautulli.dart';

class TautulliAppBarGlobalSettingsAction extends StatelessWidget {
  const TautulliAppBarGlobalSettingsAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaIconButton(
      icon: Icons.more_vert_rounded,
      onPressed: () async {
        Tuple2<bool, TautulliGlobalSettingsType?> values =
            await TautulliDialogs().globalSettings(context);
        if (values.item1) values.item2!.execute(context);
      },
    );
  }
}
