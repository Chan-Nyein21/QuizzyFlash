import 'package:flutter/material.dart';
import '../models/score_model.dart';
import '../utils/score_storage.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late Future<List<Score>> _scoresFuture;

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  void _loadScores() {
    _scoresFuture = ScoreStorage.getTopScores();
  }

  Future<void> _clearScores() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Clear Leaderboard"),
            content: const Text(
              "Are you sure you want to delete all saved scores?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Delete"),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await ScoreStorage.clearScores();
      setState(_loadScores);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearScores,
            tooltip: 'Clear All Scores',
          ),
        ],
      ),
      body: FutureBuilder<List<Score>>(
        future: _scoresFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final scores = snapshot.data!;

          if (scores.isEmpty) {
            return const Center(
              child: Text("No scores yet!", style: TextStyle(fontSize: 18)),
            );
          }

          return ListView.builder(
            itemCount: scores.length,
            itemBuilder: (context, index) {
              final score = scores[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text("#${index + 1}"),
                  backgroundColor: Colors.teal.shade200,
                ),
                title: Text(score.name),
                trailing: Text("${score.value} pts"),
              );
            },
          );
        },
      ),
    );
  }
}
