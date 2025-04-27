import 'package:flutter/material.dart';
import '../models/question_model.dart';

class ReviewScreen extends StatelessWidget {
  final List<Question> questions;
  final List<String?> selectedAnswers;

  const ReviewScreen({
    super.key,
    required this.questions,
    required this.selectedAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Answers"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final userAnswer = selectedAnswers[index];
          // ignore: unused_local_variable
          final isCorrect = userAnswer == question.correctAnswer;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Q${index + 1}: ${question.question}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...question.options.map((option) {
                    final isSelected = option == userAnswer;
                    final isAnswer = option == question.correctAnswer;

                    Color? bgColor;
                    if (isAnswer) {
                      bgColor = Colors.green[100];
                    } else if (isSelected && !isAnswer) {
                      bgColor = Colors.red[100];
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          if (isAnswer)
                            const Icon(Icons.check, color: Colors.green),
                          if (isSelected && !isAnswer)
                            const Icon(Icons.close, color: Colors.red),
                          if (!isAnswer && !isSelected)
                            const SizedBox(width: 24),
                          const SizedBox(width: 8),
                          Flexible(child: Text(option)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
