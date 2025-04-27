import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../utils/bookmark_storage.dart';

class QuizCard extends StatefulWidget {
  final Question question;
  final String? selectedAnswer;
  final bool answered;
  final Function(String) onAnswerSelected;

  const QuizCard({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.answered,
    required this.onAnswerSelected,
  });

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkBookmark();
  }

  @override
  void didUpdateWidget(covariant QuizCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.question != widget.question.question) {
      _checkBookmark();
    }
  }

  void _checkBookmark() async {
    final bookmarked = await BookmarkStorage.isBookmarked(widget.question);
    if (mounted) {
      setState(() {
        _isBookmarked = bookmarked;
      });
    }
  }

  void _toggleBookmark() async {
    if (_isBookmarked) {
      await BookmarkStorage.removeBookmark(widget.question);
    } else {
      await BookmarkStorage.saveBookmark(widget.question);
    }
    if (mounted) {
      setState(() {
        _isBookmarked = !_isBookmarked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder:
          (child, animation) =>
              FadeTransition(opacity: animation, child: child),
      child: Column(
        key: ValueKey(widget.question.question),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.question.question,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.teal,
                ),
                onPressed: _toggleBookmark,
              ),
            ],
          ),
          const SizedBox(height: 30),
          ...widget.question.options.map((option) {
            bool isSelected = option == widget.selectedAnswer;
            bool isCorrect = option == widget.question.correctAnswer;

            Color optionColor = Colors.teal;
            if (widget.answered && isSelected) {
              optionColor = isCorrect ? Colors.green : Colors.red;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      widget.answered && isSelected ? optionColor : Colors.teal,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => widget.onAnswerSelected(option),
                child: Text(option),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
