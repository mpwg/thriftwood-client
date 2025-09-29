import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/sonarr.dart';

class SonarrTagsAppBarActionAddTag extends StatelessWidget {
  final bool asDialogButton;

  const SonarrTagsAppBarActionAddTag({super.key, this.asDialogButton = false});

  @override
  Widget build(BuildContext context) {
    if (asDialogButton)
      return LunaDialog.button(
        text: 'thriftwood.Add'.tr(),
        textColor: Colors.white,
        onPressed: () async => _onPressed(context),
      );
    return LunaIconButton(
      icon: Icons.add_rounded,
      onPressed: () async => _onPressed(context),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    (bool, String) result = await SonarrDialogs().addNewTag(context);
    if (result.$1)
      SonarrAPIController().addTag(context: context, label: result.$2).then((
        value,
      ) {
        if (value) context.read<SonarrState>().fetchTags();
      });
  }
}
