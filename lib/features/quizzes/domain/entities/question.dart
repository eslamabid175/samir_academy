import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String id;
  final String quizId;
  final String text;
  final String type;  // 'multiple_choice', 'multiple_answer', 'true_false', etc.
  final List<String> options;
  final dynamic correctAnswer;  // Could be a string, a list of strings, or a boolean
  final int points;
  final int order;
  final String? explanation;  // Optional explanation for the answer
  final DateTime createdAt;
  final DateTime updatedAt;

  const Question({
    required this.id,
    required this.quizId,
    required this.text,
    required this.type,
    required this.options,
    required this.correctAnswer,
    required this.points,
    required this.order,
    required this.explanation,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    quizId,
    text,
    type,
    options,
    correctAnswer,
    points,
    order,
    explanation,
    createdAt,
    updatedAt,
  ];
}
