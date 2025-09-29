import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/extensions/int/duration.dart';
import 'package:thriftwood/modules/lidarr.dart';

class LidarrDetailsTrackTile extends StatefulWidget {
  final LidarrTrackData data;
  final bool monitored;

  const LidarrDetailsTrackTile({
    super.key,
    required this.data,
    required this.monitored,
  });

  @override
  State<LidarrDetailsTrackTile> createState() => _State();
}

class _State extends State<LidarrDetailsTrackTile> {
  @override
  Widget build(BuildContext context) => LunaBlock(
        title: widget.data.title,
        body: [
          TextSpan(text: widget.data.duration.asTrackDuration(divisor: 1000)),
          widget.data.file(widget.monitored),
        ],
        disabled: !widget.monitored,
        leading: LunaIconButton(
          text: widget.data.trackNumber,
          textSize: LunaUI.FONT_SIZE_H4,
        ),
      );
}
