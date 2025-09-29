import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/extensions/string/string.dart';
import 'package:thriftwood/modules/sonarr.dart';

class SonarrSeriesAddDetailsSeriesTypeTile extends StatelessWidget {
  const SonarrSeriesAddDetailsSeriesTypeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: 'sonarr.SeriesType'.tr(),
      body: [
        TextSpan(
          text: context
                  .watch<SonarrSeriesAddDetailsState>()
                  .seriesType
                  .value
                  ?.toTitleCase() ??
              LunaUI.TEXT_EMDASH,
        ),
      ],
      trailing: const LunaIconButton.arrow(),
      onTap: () async => _onTap(context),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    (bool, SonarrSeriesType?) result =
        await SonarrDialogs().editSeriesType(context);
    if (result.$1) {
      context.read<SonarrSeriesAddDetailsState>().seriesType = result.$2!;
      SonarrDatabase.ADD_SERIES_DEFAULT_SERIES_TYPE.update(
        result.$2!.value!,
      );
    }
  }
}
