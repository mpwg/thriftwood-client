import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/tautulli.dart';

class TautulliActivityDetailsStreamBlock extends StatelessWidget {
  final TautulliSession session;

  const TautulliActivityDetailsStreamBlock({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return LunaTableCard(
      content: [
        LunaTableContent(
          title: 'tautulli.Bandwidth'.tr(),
          body: session.lunaBandwidth,
        ),
        LunaTableContent(
          title: 'tautulli.Stream'.tr(),
          body: session.formattedStream(),
        ),
        LunaTableContent(
          title: 'tautulli.Container'.tr(),
          body: session.formattedContainer(),
        ),
        if (session.hasVideo())
          LunaTableContent(
            title: 'tautulli.Video'.tr(),
            body: session.formattedVideo(),
          ),
        if (session.hasAudio())
          LunaTableContent(
            title: 'tautulli.Audio'.tr(),
            body: session.formattedAudio(),
          ),
        if (session.hasSubtitles())
          LunaTableContent(
            title: 'tautulli.Subtitle'.tr(),
            body: session.formattedSubtitles(),
          ),
      ],
    );
  }
}
