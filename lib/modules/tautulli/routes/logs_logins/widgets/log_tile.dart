import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/extensions/datetime.dart';
import 'package:thriftwood/modules/tautulli.dart';

class TautulliLogsLoginsLogTile extends StatelessWidget {
  final TautulliUserLoginRecord login;

  const TautulliLogsLoginsLogTile({super.key, required this.login});

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: login.friendlyName,
      body: _body(),
      trailing: _trailing(),
    );
  }

  List<TextSpan> _body() {
    return [
      TextSpan(text: '${login.ipAddress}\n'),
      TextSpan(text: '${login.os}\n'),
      TextSpan(text: '${login.host}\n'),
      TextSpan(
        text: login.timestamp!.asDateTime(),
        style: const TextStyle(
          color: LunaColours.accent,
          fontWeight: LunaUI.FONT_WEIGHT_BOLD,
        ),
      ),
    ];
  }

  Widget _trailing() {
    return Column(
      children: [
        LunaIconButton(
          icon: login.success!
              ? Icons.check_circle_rounded
              : Icons.cancel_rounded,
          color: login.success! ? Colors.white : LunaColours.red,
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
