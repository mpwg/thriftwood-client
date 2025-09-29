import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/radarr.dart';

class RadarrAddMovieDetailsMonitoredTile extends StatelessWidget {
  const RadarrAddMovieDetailsMonitoredTile({super.key});

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: 'radarr.Monitor'.tr(),
      trailing: Selector<RadarrAddMovieDetailsState, bool>(
        selector: (_, state) => state.monitored,
        builder: (context, monitored, _) => LunaSwitch(
          value: monitored,
          onChanged: (value) =>
              context.read<RadarrAddMovieDetailsState>().monitored = value,
        ),
      ),
    );
  }
}
