// lib/screens/favorites_screen.dart

import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../utils/bookmark_storage.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Question>> _bookmarkedQuestions;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  void _loadBookmarks() {
    _bookmarkedQuestions = BookmarkStorage.loadBookmarks();
  }

  Future<void> _removeBookmark(Question question) async {
    await BookmarkStorage.removeBookmark(question);
    setState(_loadBookmarks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Question>>(
        future: _bookmarkedQuestions,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final questions = snapshot.data!;

          if (questions.isEmpty) {
            return const Center(child: Text("No bookmarked questions yet!"));
          }

          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final q = questions[index];
              return ListTile(
                title: Text(q.question),
                subtitle: Text(
                  "Topic: ${q.topic} | Difficulty: ${q.difficulty}",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _removeBookmark(q),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
