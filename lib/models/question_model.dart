class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String topic;
  final String difficulty;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.topic,
    required this.difficulty,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswer: json['correct_answer'] as String,
      topic: json['topic'] as String,
      difficulty: json['difficulty'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correct_answer': correctAnswer,
      'topic': topic,
      'difficulty': difficulty,
    };
  }
}
