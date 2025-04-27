import 'package:flutter/material.dart';

class TopicScreen extends StatefulWidget {
  const TopicScreen({super.key});

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  String selectedTopic = 'General Knowledge';
  String selectedDifficulty = 'Easy';

  final List<String> topics = [
    'General Knowledge',
    'Science',
    'Technology',
    'Movies',
    'Geography',
  ];

  final List<String> difficulties = ['Easy', 'Medium', 'Hard'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Topic & Difficulty"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Topic",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedTopic,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items:
                  topics.map((topic) {
                    return DropdownMenuItem(value: topic, child: Text(topic));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTopic = value!;
                });
              },
            ),
            const SizedBox(height: 30),
            const Text(
              "Select Difficulty",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedDifficulty,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items:
                  difficulties.map((level) {
                    return DropdownMenuItem(value: level, child: Text(level));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDifficulty = value!;
                });
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/quiz',
                  arguments: {
                    'topic': selectedTopic,
                    'difficulty': selectedDifficulty,
                  },
                );
              },
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              label: const Text(
                "Start Quiz",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
