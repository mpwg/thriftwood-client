import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/radarr.dart';

class RadarrMoviesEditPathTile extends StatelessWidget {
  const RadarrMoviesEditPathTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<RadarrMoviesEditState, String>(
      selector: (_, state) => state.path,
      builder: (context, path, _) => LunaBlock(
        title: 'radarr.MoviePath'.tr(),
        body: [TextSpan(text: path)],
        trailing: const LunaIconButton.arrow(),
        onTap: () async {
          (bool, String) _values = await LunaDialogs().editText(
            context,
            'radarr.MoviePath'.tr(),
            prefill: path,
          );
          if (_values.$1)
            context.read<RadarrMoviesEditState>().path = _values.$2;
        },
      ),
    );
  }
}
