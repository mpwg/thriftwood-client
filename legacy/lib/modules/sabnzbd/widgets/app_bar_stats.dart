import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/extensions/string/string.dart';
import 'package:thriftwood/modules/sabnzbd.dart';

class SABnzbdAppBarStats extends StatelessWidget {
  const SABnzbdAppBarStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Selector<SABnzbdState, (bool, String, String, String, int)>(
        selector: (_, model) => (
          model.paused, //item1
          model.currentSpeed, //item2
          model.queueTimeLeft, //item3
          model.queueSizeLeft, //item4
          model.speedLimit, //item5
        ),
        builder: (context, data, widget) => GestureDetector(
          onTap: () async => _onTap(context, data.$5),
          child: Center(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: LunaColours.grey,
                  fontSize: LunaUI.FONT_SIZE_H3,
                ),
                children: [
                  TextSpan(
                    text: _status(data.$1, data.$2),
                    style: const TextStyle(
                      fontWeight: LunaUI.FONT_WEIGHT_BOLD,
                      fontSize: LunaUI.FONT_SIZE_HEADER,
                      color: LunaColours.accent,
                    ),
                  ),
                  const TextSpan(text: '\n'),
                  TextSpan(text: data.$3 == '0:00:00' ? '―' : data.$3),
                  TextSpan(text: LunaUI.TEXT_BULLET.pad()),
                  TextSpan(text: data.$4 == '0.0 B' ? '―' : data.$4),
                ],
              ),
              overflow: TextOverflow.fade,
              maxLines: 2,
              softWrap: false,
              textAlign: TextAlign.right,
            ),
          ),
        ),
      );

  String _status(bool paused, String speed) => paused
      ? 'Paused'
      : speed == '0.0 B/s'
      ? 'Idle'
      : speed;

  Future<void> _onTap(BuildContext context, int speed) async {
    HapticFeedback.lightImpact();
    List values = await SABnzbdDialogs.speedLimit(context, speed);
    if (values[0])
      switch (values[1]) {
        case -1:
          {
            values = await SABnzbdDialogs.customSpeedLimit(context);
            if (values[0])
              SABnzbdAPI.from(LunaProfile.current)
                  .setSpeedLimit(values[1])
                  .then(
                    (_) => showLunaSuccessSnackBar(
                      title: 'Speed Limit Set',
                      message: 'Set to ${values[1]}%',
                    ),
                  )
                  .catchError(
                    (error) => showLunaErrorSnackBar(
                      title: 'Failed to Set Speed Limit',
                      error: error,
                    ),
                  );
            break;
          }
        default:
          SABnzbdAPI.from(LunaProfile.current)
              .setSpeedLimit(values[1])
              .then(
                (_) => showLunaSuccessSnackBar(
                  title: 'Speed Limit Set',
                  message: 'Set to ${values[1]}%',
                ),
              )
              .catchError(
                (error) => showLunaErrorSnackBar(
                  title: 'Failed to Set Speed Limit',
                  error: error,
                ),
              );
      }
  }
}
