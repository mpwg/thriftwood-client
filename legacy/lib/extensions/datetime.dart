import 'package:thriftwood/database/tables/thriftwood.dart';
import 'package:thriftwood/extensions/string/string.dart';
import 'package:thriftwood/vendor.dart';
import 'package:thriftwood/widgets/ui.dart';

extension DateTimeExtension on DateTime {
  String _formatted(String format) {
    return DateFormat(format, 'en').format(this.toLocal());
  }

  DateTime floor() {
    return DateTime(this.year, this.month, this.day);
  }

  String asTimeOnly() {
    if (thriftwoodDatabase.USE_24_HOUR_TIME.read()) return _formatted('Hm');
    return _formatted('jm');
  }

  String asDateOnly({shortenMonth = false}) {
    final format = shortenMonth ? 'MMM dd, y' : 'MMMM dd, y';
    return _formatted(format);
  }

  String asDateTime({
    bool showSeconds = true,
    bool shortenMonth = false,
    String? delimiter,
  }) {
    final format = StringBuffer(shortenMonth ? 'MMM dd, y' : 'MMMM dd, y');
    format.write(delimiter ?? LunaUI.TEXT_BULLET.pad());
    format.write(
      thriftwoodDatabase.USE_24_HOUR_TIME.read() ? 'HH:mm' : 'hh:mm',
    );
    if (showSeconds) format.write(':ss');
    if (!thriftwoodDatabase.USE_24_HOUR_TIME.read()) format.write(' a');

    return _formatted(format.toString());
  }

  String asPoleDate() {
    final year = this.year.toString().padLeft(4, '0');
    final month = this.month.toString().padLeft(2, '0');
    final day = this.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String asAge() {
    final diff = DateTime.now().difference(this);
    if (diff.inSeconds < 15) return 'thriftwood.JustNow'.tr();

    final days = diff.inDays.abs();
    if (days >= 1) {
      final years = (days / 365).floor();
      if (years == 1) return 'thriftwood.OneYearAgo'.tr();
      if (years > 1) return 'thriftwood.YearsAgo'.tr(args: [years.toString()]);

      final months = (days / 30).floor();
      if (months == 1) return 'thriftwood.OneMonthAgo'.tr();
      if (months > 1)
        return 'thriftwood.MonthsAgo'.tr(args: [months.toString()]);

      if (days == 1) return 'thriftwood.OneDayAgo'.tr();
      if (days > 1) return 'thriftwood.DaysAgo'.tr(args: [days.toString()]);
    }

    final hours = diff.inHours.abs();
    if (hours == 1) return 'thriftwood.OneHourAgo'.tr();
    if (hours > 1) return 'thriftwood.HoursAgo'.tr(args: [hours.toString()]);

    final mins = diff.inMinutes.abs();
    if (mins == 1) return 'thriftwood.OneMinuteAgo'.tr();
    if (mins > 1) return 'thriftwood.MinutesAgo'.tr(args: [mins.toString()]);

    final secs = diff.inSeconds.abs();
    if (secs == 1) return 'thriftwood.OneSecondAgo'.tr();
    return 'thriftwood.SecondsAgo'.tr(args: [secs.toString()]);
  }

  String asDaysDifference() {
    final diff = DateTime.now().difference(this);
    final days = diff.inDays.abs();
    if (days == 0) return 'thriftwood.Today'.tr();

    final years = (days / 365).floor();
    if (years == 1) return 'thriftwood.OneYear'.tr();
    if (years > 1) return 'thriftwood.Years'.tr(args: [years.toString()]);

    final months = (days / 30).floor();
    if (months == 1) return 'thriftwood.OneMonth'.tr();
    if (months > 1) return 'thriftwood.Months'.tr(args: [months.toString()]);

    if (days == 1) return 'thriftwood.OneDay'.tr();
    return 'thriftwood.Days'.tr(args: [days.toString()]);
  }
}
