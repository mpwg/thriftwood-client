import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/sonarr.dart';

class SonarrSeriesEditMonitoredTile extends StatelessWidget {
  const SonarrSeriesEditMonitoredTile({super.key});

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: 'sonarr.Monitored'.tr(),
      trailing: LunaSwitch(
        value: context.watch<SonarrSeriesEditState>().monitored,
        onChanged: (value) =>
            context.read<SonarrSeriesEditState>().monitored = value,
      ),
    );
  }
}
