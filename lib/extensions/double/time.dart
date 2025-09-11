import 'package:thriftwood/core.dart';

extension DoubleAsTimeExtension on double? {
  String asTimeAgo() {
    if (this == null || this! < 0) return LunaUI.TEXT_EMDASH;

    double hours = this!;
    double minutes = (this! * 60);
    double days = (this! / 24);

    if (minutes <= 2) {
      return 'thriftwood.JustNow'.tr();
    }

    if (minutes <= 120) {
      return 'thriftwood.MinutesAgo'.tr(args: [minutes.round().toString()]);
    }

    if (hours <= 48) {
      return 'thriftwood.HoursAgo'.tr(args: [hours.toStringAsFixed(1)]);
    }

    return 'thriftwood.DaysAgo'.tr(args: [days.round().toString()]);
  }
}
