import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/radarr.dart';

class RadarrAddMovieDetailsMinimumAvailabilityTile extends StatelessWidget {
  const RadarrAddMovieDetailsMinimumAvailabilityTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<RadarrAddMovieDetailsState, RadarrAvailability>(
      selector: (_, state) => state.availability,
      builder: (context, availability, _) {
        return LunaBlock(
          title: 'radarr.MinimumAvailability'.tr(),
          body: [TextSpan(text: availability.readable)],
          trailing: const LunaIconButton.arrow(),
          onTap: () async {
            (bool, RadarrAvailability?) values =
                await RadarrDialogs().editMinimumAvailability(context);
            if (values.$1)
              context.read<RadarrAddMovieDetailsState>().availability =
                  values.$2!;
          },
        );
      },
    );
  }
}
