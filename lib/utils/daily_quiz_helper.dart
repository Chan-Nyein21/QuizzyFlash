import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question_model.dart';

class DailyQuizHelper {
  static Future<List<Question>> getTodayQuiz() async {
    final prefs = await SharedPreferences.getInstance();

    // Create a unique key using today’s date (YYYY-MM-DD)
    final todayKey =
        'daily_quiz_${DateTime.now().toIso8601String().substring(0, 10)}';

    if (prefs.containsKey(todayKey)) {
      // Return the saved quiz for today
      final savedJson = prefs.getString(todayKey)!;
      final List<dynamic> data = json.decode(savedJson);
      return data.map((e) => Question.fromJson(e)).toList();
    }

    // Load all questions from JSON asset
    final String jsonString = await rootBundle.loadString(
      'assets/questions.json',
    );
    final List<dynamic> allQuestions = json.decode(jsonString);

    // Shuffle and select 3 random questions
    allQuestions.shuffle();
    final List<Question> selected =
        allQuestions.take(3).map((e) => Question.fromJson(e)).toList();

    // Save them for today
    final encoded = json.encode(selected.map((q) => q.toJson()).toList());
    await prefs.setString(todayKey, encoded);

    return selected;
  }
}
