import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/tautulli.dart';

class TautulliActivityStatus extends StatelessWidget {
  final TautulliActivity? activity;

  const TautulliActivityStatus({required this.activity, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaHeader(
      text: activity!.lunaSessionsHeader,
      subtitle: [activity!.lunaSessions, activity!.lunaBandwidth].join('\n'),
    );
  }
}
