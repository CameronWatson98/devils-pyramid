/// Utility functions for generating deterministic seeds from dates
/// for daily puzzle generation.

/// Generates a deterministic integer seed from a date.
///
/// The same date will always produce the same seed, ensuring
/// all users get the same daily puzzle on the same calendar day.
///
/// Example: February 15, 2026 → 20260215
int generateDailySeed(DateTime date) {
  final utc = date.toUtc();
  return utc.year * 10000 + utc.month * 100 + utc.day;
}

/// Formats a date as a string key for storage.
///
/// Returns format: "YYYY-MM-DD"
/// Example: February 15, 2026 → "2026-02-15"
String formatDateKey(DateTime date) {
  final utc = date.toUtc();
  return '${utc.year}-${utc.month.toString().padLeft(2, '0')}-${utc.day.toString().padLeft(2, '0')}';
}

/// Gets the current date in UTC, normalized to midnight.
///
/// This ensures consistent date comparisons regardless of time of day.
DateTime getTodayUtc() {
  final now = DateTime.now().toUtc();
  return DateTime.utc(now.year, now.month, now.day);
}
