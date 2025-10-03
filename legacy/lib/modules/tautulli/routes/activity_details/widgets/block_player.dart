import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/tautulli.dart';

class TautulliActivityDetailsPlayerBlock extends StatelessWidget {
  final TautulliSession session;

  const TautulliActivityDetailsPlayerBlock({Key? key, required this.session})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaTableCard(
      content: [
        LunaTableContent(
          title: 'tautulli.Location'.tr(),
          body: session.lunaIPAddress,
        ),
        LunaTableContent(
          title: 'tautulli.Platform'.tr(),
          body: session.lunaPlatform,
        ),
        LunaTableContent(
          title: 'tautulli.Product'.tr(),
          body: session.lunaProduct,
        ),
        LunaTableContent(
          title: 'tautulli.Player'.tr(),
          body: session.lunaPlayer,
        ),
        LunaTableContent(
          title: 'tautulli.Quality'.tr(),
          body: session.lunaQuality,
        ),
      ],
    );
  }
}
