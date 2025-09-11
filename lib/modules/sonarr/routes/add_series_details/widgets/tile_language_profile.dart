import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/sonarr.dart';

class SonarrSeriesAddDetailsLanguageProfileTile extends StatelessWidget {
  const SonarrSeriesAddDetailsLanguageProfileTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: 'sonarr.LanguageProfile'.tr(),
      body: [
        TextSpan(
          text:
              context
                  .watch<SonarrSeriesAddDetailsState>()
                  .languageProfile
                  .name ??
              LunaUI.TEXT_EMDASH,
        ),
      ],
      trailing: const LunaIconButton.arrow(),
      onTap: () async => _onTap(context),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    List<SonarrLanguageProfile> _profiles = await context
        .read<SonarrState>()
        .languageProfiles!;
    (bool, SonarrLanguageProfile?) result = await SonarrDialogs()
        .editLanguageProfiles(context, _profiles);
    if (result.$1) {
      context.read<SonarrSeriesAddDetailsState>().languageProfile =
          result.$2!;
      SonarrDatabase.ADD_SERIES_DEFAULT_LANGUAGE_PROFILE.update(
        result.$2!.id,
      );
    }
  }
}
