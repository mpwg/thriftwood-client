import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/extensions/duration/timestamp.dart';
import 'package:thriftwood/modules/tautulli.dart';

class TautulliLibrariesDetailsInformationGlobalStats extends StatelessWidget {
  final List<TautulliLibraryWatchTimeStats> watchtime;

  const TautulliLibrariesDetailsInformationGlobalStats({
    super.key,
    required this.watchtime,
  });

  @override
  Widget build(BuildContext context) {
    return LunaTableCard(
      content: List.generate(
        watchtime.length,
        (index) => LunaTableContent(
          title: _title(watchtime[index].queryDays),
          body: _body(watchtime[index].totalPlays, watchtime[index].totalTime!),
        ),
      ),
    );
  }

  String _title(int? days) {
    if (days == 0) return 'All Time';
    if (days == 1) return '24 Hours';
    return '$days Days';
  }

  String _body(int? plays, Duration duration) {
    String _plays = plays == 1 ? '1 Play' : '$plays Plays';
    return '$_plays\n${duration.asWordsTimestamp()}';
  }
}
