import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/sonarr.dart';

class SonarrSeasonHeader extends StatelessWidget {
  final int seriesId;
  final int? seasonNumber;

  const SonarrSeasonHeader({
    super.key,
    required this.seriesId,
    required this.seasonNumber,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: LunaHeader(
        text: seasonNumber == 0
            ? 'sonarr.Specials'.tr()
            : 'sonarr.SeasonNumber'.tr(args: [seasonNumber.toString()]),
      ),
      onTap: () => context
          .read<SonarrSeasonDetailsState>()
          .toggleSeasonEpisodes(seasonNumber!),
      onLongPress: () async {
        HapticFeedback.heavyImpact();
        (bool, SonarrSeasonSettingsType?) result =
            await SonarrDialogs().seasonSettings(context, seasonNumber);
        if (result.$1) {
          result.$2!.execute(context, seriesId, seasonNumber);
        }
      },
    );
  }
}
