import 'dart:convert';
import 'package:devils_pyramid/models/daily_challenge_data.dart';
import 'package:devils_pyramid/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for persisting daily challenge state using SharedPreferences.
class DailyChallengeStorage {
  static const String _key = 'daily_challenge_data';

  final SharedPreferences _prefs;

  DailyChallengeStorage(this._prefs);

  /// Saves the daily challenge data to local storage
  Future<void> saveDailyChallenge(DailyChallengeData data) async {
    try {
      final json = data.toJson();
      final jsonString = jsonEncode(json);
      await _prefs.setString(_key, jsonString);
    } catch (e, stack) {
      logger.e('Failed to save daily challenge', error: e, stackTrace: stack);
    }
  }

  /// Loads the daily challenge data from local storage
  ///
  /// Returns null if no data exists or if the data is corrupt
  Future<DailyChallengeData?> loadDailyChallenge() async {
    try {
      final jsonString = _prefs.getString(_key);
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return DailyChallengeData.fromJson(json);
    } catch (e, stack) {
      logger.w('Failed to load daily challenge, returning null', error: e, stackTrace: stack);
      return null;
    }
  }

  /// Clears old challenge data if it doesn't match the current date
  Future<void> clearOldChallenges(String currentDate) async {
    try {
      final saved = await loadDailyChallenge();
      if (saved != null && saved.date != currentDate) {
        await _prefs.remove(_key);
      }
    } catch (e, stack) {
      logger.w('Failed to clear old challenges', error: e, stackTrace: stack);
    }
  }

  /// Checks if there's a saved challenge for today
  Future<bool> hasChallengeForToday(String todayDate) async {
    final saved = await loadDailyChallenge();
    return saved != null && saved.date == todayDate;
  }
}
