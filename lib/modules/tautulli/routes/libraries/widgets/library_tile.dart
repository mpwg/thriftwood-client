import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/extensions/datetime.dart';
import 'package:thriftwood/extensions/duration/timestamp.dart';
import 'package:thriftwood/extensions/string/string.dart';
import 'package:thriftwood/modules/tautulli.dart';
import 'package:thriftwood/router/routes/tautulli.dart';

class TautulliLibrariesLibraryTile extends StatelessWidget {
  final TautulliTableLibrary library;

  const TautulliLibrariesLibraryTile({super.key, required this.library});

  @override
  Widget build(BuildContext context) {
    int? _plays = library.plays;
    return LunaBlock(
      title: library.sectionName,
      body: [
        TextSpan(text: library.readableCount),
        TextSpan(
          children: [
            TextSpan(text: _plays == 1 ? '1 Play' : '$_plays Plays'),
            TextSpan(text: LunaUI.TEXT_BULLET.pad()),
            TextSpan(text: library.duration!.asWordsTimestamp()),
          ],
        ),
        TextSpan(
          style: const TextStyle(
            color: LunaColours.accent,
            fontWeight: LunaUI.FONT_WEIGHT_BOLD,
          ),
          text: library.lastAccessed?.asAge() ?? 'Unknown',
        ),
      ],
      backgroundUrl: context.watch<TautulliState>().getImageURLFromPath(
            library.thumb,
          ),
      backgroundHeaders: context.watch<TautulliState>().headers,
      onTap: () => TautulliRoutes.LIBRARIES_DETAILS.go(
        params: {'section': library.sectionId.toString()},
      ),
    );
  }
}
