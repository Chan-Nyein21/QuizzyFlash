import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/question_model.dart';
import '../widgets/quiz_card.dart';
import '../utils/timer_helper.dart';
import '../utils/daily_quiz_helper.dart';

class DailyQuizScreen extends StatefulWidget {
  const DailyQuizScreen({super.key});

  @override
  State<DailyQuizScreen> createState() => _DailyQuizScreenState();
}

class _DailyQuizScreenState extends State<DailyQuizScreen> {
  final TimerHelper _timerHelper = TimerHelper();
  final AudioPlayer _tickPlayer = AudioPlayer();
  final AudioPlayer _timeUpPlayer = AudioPlayer();

  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _timer = 10;

  bool _answered = false;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _loadDailyQuiz();
  }

  Future<void> _loadDailyQuiz() async {
    final questions = await DailyQuizHelper.getTodayQuiz();
    setState(() {
      _questions = questions;
    });

    if (questions.isNotEmpty) {
      _startTimer();
    }
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
        await _timeUpPlayer.play(AssetSource('sounds/time_up.mp3'));
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text("Daily Quiz Completed!"),
            content: Text("Your score: $_score / ${_questions.length}"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to home
                },
                child: const Text("Go Home"),
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
    if (_questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Quiz (${_currentIndex + 1}/${_questions.length})"),
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
