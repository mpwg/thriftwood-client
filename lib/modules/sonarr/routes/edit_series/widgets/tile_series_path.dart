import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/sonarr.dart';

class SonarrSeriesEditSeriesPathTile extends StatelessWidget {
  const SonarrSeriesEditSeriesPathTile({super.key});

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: 'sonarr.SeriesPath'.tr(),
      body: [TextSpan(text: context.watch<SonarrSeriesEditState>().seriesPath)],
      trailing: const LunaIconButton.arrow(),
      onTap: () async => _onTap(context),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    (bool, String) _values = await LunaDialogs().editText(
      context,
      'sonarr.SeriesPath'.tr(),
      prefill: context.read<SonarrSeriesEditState>().seriesPath,
    );
    if (_values.$1)
      context.read<SonarrSeriesEditState>().seriesPath = _values.$2;
  }
}
