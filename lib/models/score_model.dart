// lib/models/score_model.dart

class Score {
  final String name;
  final int value;

  Score({required this.name, required this.value});

  // Convert a Score to a JSON map
  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value};
  }

  // Create a Score from a JSON map
  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(name: json['name'], value: json['value']);
  }
}
