import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/radarr.dart';

class RadarrTagsAppBarActionAddTag extends StatelessWidget {
  final bool asDialogButton;

  const RadarrTagsAppBarActionAddTag({Key? key, this.asDialogButton = false})
    : super(key: key);

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
    (bool, String) values = await RadarrDialogs().addNewTag(context);
    if (values.$1)
      RadarrAPIHelper().addTag(context: context, label: values.$2).then((
        value,
      ) {
        if (value) context.read<RadarrState>().fetchTags();
      });
  }
}
