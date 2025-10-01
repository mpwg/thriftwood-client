// SWIFT-FIRST MIGRATION: Temporary compatibility enum
// This file provides minimal compatibility for remaining Flutter code
// Dashboard has been migrated to Swift in Phase 3 - this is transitional only

enum CalendarStartingSize {
  ONE_WEEK,
  TWO_WEEKS,
  ONE_MONTH;

  String get key => name.toLowerCase();

  static CalendarStartingSize fromKey(String key) {
    return CalendarStartingSize.values.firstWhere(
      (e) => e.key == key.toLowerCase(),
      orElse: () => CalendarStartingSize.ONE_WEEK,
    );
  }
}

// Minimal Hive adapter for compatibility
class CalendarStartingSizeAdapter {
  // Empty implementation - data will come from Swift
}
