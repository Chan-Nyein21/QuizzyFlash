import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../widgets/flashcard_widget.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  List<Map<String, String>> _flashcards = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
    final String jsonString = await rootBundle.loadString(
      'assets/questions.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);

    setState(() {
      _flashcards =
          jsonData.map((item) {
            return {
              'question': item['question'] as String,
              'answer': item['correct_answer'] as String,
            };
          }).toList();
    });
  }

  void _nextCard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _flashcards.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_flashcards.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final flashcard = _flashcards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flashcards"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlashcardWidget(
              key: ValueKey(
                _currentIndex,
              ), // 👈 Forces rebuild for each new card
              question: flashcard['question']!,
              answer: flashcard['answer']!,
              showFront: true, // 👈 Always show question first
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _nextCard,
              icon: const Icon(Icons.navigate_next),
              label: const Text("Next Card"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
