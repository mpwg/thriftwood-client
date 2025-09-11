import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/radarr.dart';

extension LunaRadarrHealthCheckTypeExtension on RadarrHealthCheckType? {
  Color get lunaColour {
    switch (this) {
      case RadarrHealthCheckType.NOTICE:
        return LunaColours.blue;
      case RadarrHealthCheckType.WARNING:
        return LunaColours.orange;
      case RadarrHealthCheckType.ERROR:
        return LunaColours.red;
      default:
        return Colors.white;
    }
  }
}
