// SWIFT-FIRST MIGRATION: Temporary compatibility enum
// This file provides minimal compatibility for remaining Flutter code
// Dashboard has been migrated to Swift in Phase 3 - this is transitional only

enum CalendarStartingType {
  CALENDAR,
  SCHEDULE;

  String get key => name.toLowerCase();

  static CalendarStartingType fromKey(String key) {
    return CalendarStartingType.values.firstWhere(
      (e) => e.key == key.toLowerCase(),
      orElse: () => CalendarStartingType.CALENDAR,
    );
  }
}

// Minimal Hive adapter for compatibility
class CalendarStartingTypeAdapter {
  // Empty implementation - data will come from Swift
}
