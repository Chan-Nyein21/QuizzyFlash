// lib/utils/bookmark_storage.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question_model.dart';

class BookmarkStorage {
  static const String _key = 'bookmarked_questions';

  static Future<void> saveBookmark(Question question) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];
    final current = existing.toSet();
    current.add(jsonEncode(question.toJson()));
    await prefs.setStringList(_key, current.toList());
  }

  static Future<void> removeBookmark(Question question) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];
    existing.removeWhere(
      (item) => jsonDecode(item)['question'] == question.question,
    );
    await prefs.setStringList(_key, existing);
  }

  static Future<List<Question>> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data.map((e) => Question.fromJson(jsonDecode(e))).toList();
  }

  static Future<bool> isBookmarked(Question question) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data.any(
      (item) => jsonDecode(item)['question'] == question.question,
    );
  }
}
