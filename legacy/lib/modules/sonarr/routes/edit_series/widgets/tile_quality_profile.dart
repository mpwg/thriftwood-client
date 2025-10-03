import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/sonarr.dart';

class SonarrSeriesEditQualityProfileTile extends StatelessWidget {
  final List<SonarrQualityProfile?> profiles;

  const SonarrSeriesEditQualityProfileTile({Key? key, required this.profiles})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: 'sonarr.QualityProfile'.tr(),
      body: [
        TextSpan(
          text:
              context.watch<SonarrSeriesEditState>().qualityProfile?.name ??
              LunaUI.TEXT_EMDASH,
        ),
      ],
      trailing: const LunaIconButton.arrow(),
      onTap: () async => _onTap(context),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    (bool, SonarrQualityProfile?) result = await SonarrDialogs()
        .editQualityProfile(context, profiles);
    if (result.$1)
      context.read<SonarrSeriesEditState>().qualityProfile = result.$2!;
  }
}
