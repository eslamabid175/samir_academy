import 'package:equatable/equatable.dart';

class QuizResult extends Equatable {
  final String id;
  final String userId;
  final String quizId;
  final String quizTitle;
  final Map<String, dynamic> answers;  // Map of questionId to answer
  final double? score;  // Percentage score
  final int? totalQuestions;
  final int? correctAnswers;
  final DateTime startedAt;
  final DateTime? completedAt;

  const QuizResult({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.quizTitle,
    required this.answers,
    this.score,
    this.totalQuestions,
    this.correctAnswers,
    required this.startedAt,
    this.completedAt,
  });

  // Check if the quiz is completed
  bool get isCompleted => completedAt != null;

  // Calculate duration in minutes
  int get durationInMinutes {
    if (completedAt == null) return 0;
    return completedAt!.difference(startedAt).inMinutes;
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    quizId,
    quizTitle,
    answers,
    score,
    totalQuestions,
    correctAnswers,
    startedAt,
    completedAt,
  ];
}
