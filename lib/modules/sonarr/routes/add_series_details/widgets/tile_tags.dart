import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/sonarr.dart';

class SonarrSeriesAddDetailsTagsTile extends StatelessWidget {
  const SonarrSeriesAddDetailsTagsTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<SonarrTag> _tags = context.watch<SonarrSeriesAddDetailsState>().tags;
    return LunaBlock(
      title: 'sonarr.Tags'.tr(),
      body: [
        TextSpan(
          text: _tags.isEmpty
              ? LunaUI.TEXT_EMDASH
              : _tags.map((e) => e.label).join(', '),
        ),
      ],
      trailing: const LunaIconButton.arrow(),
      onTap: () async => await SonarrDialogs().setAddTags(context),
    );
  }
}
