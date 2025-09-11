import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/tautulli.dart';

class TautulliLogsTautulliState extends ChangeNotifier {
  TautulliLogsTautulliState(BuildContext context) {
    fetchLogs(context);
  }

  Future<List<TautulliLog>>? _logs;
  Future<List<TautulliLog>>? get logs => _logs;
  Future<void> fetchLogs(BuildContext context) async {
    if (context.read<TautulliState>().enabled) {
      _logs = context.read<TautulliState>().api!.miscellaneous.getLogs(
        start: 0,
        end: TautulliDatabase.CONTENT_LOAD_LENGTH.read(),
      );
    }
    notifyListeners();
  }
}
