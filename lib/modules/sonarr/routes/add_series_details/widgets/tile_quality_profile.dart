import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/sonarr.dart';

class SonarrSeriesAddDetailsQualityProfileTile extends StatelessWidget {
  const SonarrSeriesAddDetailsQualityProfileTile({super.key});

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: 'sonarr.QualityProfile'.tr(),
      body: [
        TextSpan(
          text: context
                  .watch<SonarrSeriesAddDetailsState>()
                  .qualityProfile
                  .name ??
              LunaUI.TEXT_EMDASH,
        ),
      ],
      trailing: const LunaIconButton.arrow(),
      onTap: () async => _onTap(context),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    List<SonarrQualityProfile> _profiles =
        await context.read<SonarrState>().qualityProfiles!;
    (bool, SonarrQualityProfile?) result =
        await SonarrDialogs().editQualityProfile(context, _profiles);
    if (result.$1) {
      context.read<SonarrSeriesAddDetailsState>().qualityProfile = result.$2!;
      SonarrDatabase.ADD_SERIES_DEFAULT_QUALITY_PROFILE.update(
        result.$2!.id,
      );
    }
  }
}
