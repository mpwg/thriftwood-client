import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/radarr.dart';

class RadarrMoviesEditMinimumAvailabilityTile extends StatelessWidget {
  const RadarrMoviesEditMinimumAvailabilityTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<RadarrMoviesEditState, RadarrAvailability>(
      selector: (_, state) => state.availability,
      builder: (context, availability, _) => LunaBlock(
        title: 'radarr.MinimumAvailability'.tr(),
        body: [TextSpan(text: availability.readable)],
        trailing: const LunaIconButton.arrow(),
        onTap: () async {
          (bool, RadarrAvailability?) _values = await RadarrDialogs()
              .editMinimumAvailability(context);
          if (_values.$1)
            context.read<RadarrMoviesEditState>().availability = _values.$2!;
        },
      ),
    );
  }
}
