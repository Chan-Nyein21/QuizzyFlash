// lib/utils/score_storage.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/score_model.dart';

class ScoreStorage {
  static const _key = 'leaderboard';

  /// Save a new score to the leaderboard
  static Future<void> saveScore(Score score) async {
    final prefs = await SharedPreferences.getInstance();

    // Load existing scores
    final List<String> existing = prefs.getStringList(_key) ?? [];
    final List<Score> scores =
        existing.map((s) => Score.fromJson(json.decode(s))).toList();

    // Add new score and sort
    scores.add(score);
    scores.sort((a, b) => b.value.compareTo(a.value)); // Highest first
    final topScores = scores.take(5).toList(); // Keep top 5

    // Save back to shared preferences
    final encoded = topScores.map((s) => json.encode(s.toJson())).toList();
    await prefs.setStringList(_key, encoded);
  }

  /// Get top scores from local storage
  static Future<List<Score>> getTopScores() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data = prefs.getStringList(_key) ?? [];
    return data.map((s) => Score.fromJson(json.decode(s))).toList();
  }

  static Future<void> clearScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
