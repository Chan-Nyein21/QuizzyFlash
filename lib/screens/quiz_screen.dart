import 'dart:convert';
import 'package:final_exam_app/screens/review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/question_model.dart';
import '../widgets/quiz_card.dart';
import '../utils/timer_helper.dart';
import '../models/score_model.dart';
import '../utils/score_storage.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final TimerHelper _timerHelper = TimerHelper();
  final AudioPlayer _tickPlayer = AudioPlayer();
  final AudioPlayer _timeUpPlayer = AudioPlayer();

  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _timer = 10;

  List<String?> _selectedAnswers = [];

  bool _answered = false;
  String? _selectedAnswer;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      final selectedTopic = args['topic']!;
      final selectedDifficulty = args['difficulty']!;
      _loadQuestions(selectedTopic, selectedDifficulty);
      _isInitialized = true;
    }
  }

  Future<void> _loadQuestions(String topic, String difficulty) async {
    final String jsonString = await rootBundle.loadString(
      'assets/questions.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);

    setState(() {
      _questions =
          jsonData
              .map((item) => Question.fromJson(item))
              .where(
                (q) =>
                    q.topic.toLowerCase() == topic.toLowerCase() &&
                    q.difficulty.toLowerCase() == difficulty.toLowerCase(),
              )
              .toList();

      if (_questions.isNotEmpty) {
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timerHelper.start(
      duration: 10,
      onTick: (timeLeft) async {
        setState(() {
          _timer = timeLeft;
        });
        await _tickPlayer.play(AssetSource('sounds/tick.mp3'), volume: 0.5);
      },
      onTimeUp: () async {
        await _timeUpPlayer.play(
          AssetSource('sounds/time_up.mp3'),
          volume: 1.0,
        );
        _goToNextQuestion();
      },
    );
  }

  void _submitAnswer(String answer) {
    if (_answered) return;

    _timerHelper.cancel();
    setState(() {
      _answered = true;
      _selectedAnswer = answer;
      _selectedAnswers.add(answer); // ✅ Collect answer

      if (answer == _questions[_currentIndex].correctAnswer) {
        _score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), _goToNextQuestion);
  }

  void _goToNextQuestion() {
    setState(() {
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
        _answered = false;
        _selectedAnswer = null;
        _startTimer();
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
    final TextEditingController _nameController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text("Quiz Completed!"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Your score: $_score / ${_questions.length}"),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Enter your name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final name =
                      _nameController.text.trim().isEmpty
                          ? "Anonymous"
                          : _nameController.text.trim();

                  await ScoreStorage.saveScore(
                    Score(name: name, value: _score),
                  );

                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("Submit"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Close current dialog first

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ReviewScreen(
                            questions: _questions,
                            selectedAnswers: _selectedAnswers,
                          ),
                    ),
                  );

                  // 👇 Reopen the same result dialog when user comes back
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      final TextEditingController _nameController =
                          TextEditingController();
                      return AlertDialog(
                        title: const Text("Quiz Completed!"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Your score: $_score / ${_questions.length}"),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: "Enter your name",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              final name =
                                  _nameController.text.trim().isEmpty
                                      ? "Anonymous"
                                      : _nameController.text.trim();

                              await ScoreStorage.saveScore(
                                Score(name: name, value: _score),
                              );

                              Navigator.pop(context); // Close dialog
                              Navigator.pop(context); // Go home
                            },
                            child: const Text("Submit"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text("Review Answers"),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _timerHelper.cancel();
    _tickPlayer.dispose();
    _timeUpPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty && _isInitialized) {
      return const Scaffold(
        body: Center(
          child: Text("No questions available for this topic & difficulty."),
        ),
      );
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz (${_currentIndex + 1}/${_questions.length})"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Time left: $_timer sec",
              style: const TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              backgroundColor: Colors.teal.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
            const SizedBox(height: 20),
            QuizCard(
              question: question,
              selectedAnswer: _selectedAnswer,
              answered: _answered,
              onAnswerSelected: _submitAnswer,
            ),
          ],
        ),
      ),
    );
  }
}
