import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/tautulli.dart';
import 'package:thriftwood/router/routes/tautulli.dart';

class TautulliLibrariesDetailsUserStatsTile extends StatelessWidget {
  final TautulliLibraryUserStats user;

  const TautulliLibrariesDetailsUserStatsTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      posterUrl: context.watch<TautulliState>().getImageURLFromPath(
            user.userThumb,
          ),
      posterHeaders:
          context.watch<TautulliState>().headers.cast<String, String>(),
      posterPlaceholderIcon: LunaIcons.USER,
      title: user.friendlyName,
      body: [
        TextSpan(
          text: user.totalPlays == 1 ? '1 Play' : '${user.totalPlays} Plays',
        ),
        TextSpan(text: user.userId.toString()),
      ],
      bodyLeadingIcons: const [LunaIcons.PLAY, LunaIcons.USER],
      onTap: () async => _onTap(context),
      posterIsSquare: true,
    );
  }

  void _onTap(BuildContext context) {
    TautulliRoutes.USER_DETAILS.go(params: {'user': user.userId!.toString()});
  }
}
