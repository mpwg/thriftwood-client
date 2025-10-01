// SWIFT-FIRST MIGRATION: Temporary compatibility enum
// This file provides minimal compatibility for remaining Flutter code
// Dashboard has been migrated to Swift in Phase 3 - this is transitional only

enum CalendarStartingDay {
  MONDAY,
  TUESDAY,
  WEDNESDAY,
  THURSDAY,
  FRIDAY,
  SATURDAY,
  SUNDAY;

  String get key => name.toLowerCase();

  static CalendarStartingDay fromKey(String key) {
    return CalendarStartingDay.values.firstWhere(
      (e) => e.key == key.toLowerCase(),
      orElse: () => CalendarStartingDay.MONDAY,
    );
  }
}

// Minimal Hive adapter for compatibility
class CalendarStartingDayAdapter {
  // Empty implementation - data will come from Swift
}
