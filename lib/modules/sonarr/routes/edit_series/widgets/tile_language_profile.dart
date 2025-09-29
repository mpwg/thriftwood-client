import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/sonarr.dart';

class SonarrSeriesEditLanguageProfileTile extends StatelessWidget {
  final List<SonarrLanguageProfile?> profiles;

  const SonarrSeriesEditLanguageProfileTile(
      {super.key, required this.profiles});

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: 'sonarr.LanguageProfile'.tr(),
      body: [
        TextSpan(
          text: context.watch<SonarrSeriesEditState>().languageProfile?.name ??
              LunaUI.TEXT_EMDASH,
        ),
      ],
      trailing: const LunaIconButton.arrow(),
      onTap: () async => _onTap(context),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    (bool, SonarrLanguageProfile?) result =
        await SonarrDialogs().editLanguageProfiles(context, profiles);
    if (result.$1)
      context.read<SonarrSeriesEditState>().languageProfile = result.$2!;
  }
}
