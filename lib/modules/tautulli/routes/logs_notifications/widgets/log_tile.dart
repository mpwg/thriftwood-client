import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/extensions/datetime.dart';
import 'package:thriftwood/modules/tautulli.dart';

class TautulliLogsNotificationLogTile extends StatelessWidget {
  final TautulliNotificationLogRecord notification;

  const TautulliLogsNotificationLogTile(
      {super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: notification.agentName,
      body: _body(),
      trailing: _trailing(),
    );
  }

  List<TextSpan> _body() {
    return [
      TextSpan(text: notification.notifyAction),
      TextSpan(text: notification.subjectText),
      TextSpan(text: notification.bodyText),
      TextSpan(
        text: notification.timestamp!.asDateTime(),
        style: const TextStyle(
          color: LunaColours.accent,
          fontWeight: LunaUI.FONT_WEIGHT_BOLD,
        ),
      ),
    ];
  }

  Widget _trailing() => Column(
        children: [
          LunaIconButton(
            icon: notification.success!
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            color: notification.success! ? LunaColours.white : LunaColours.red,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      );
}
