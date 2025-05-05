import '../../domain/entities/quiz_result.dart';

class QuizResultModel extends QuizResult {
  const QuizResultModel({
    required String id,
    required String userId,
    required String quizId,
    required String quizTitle,
    required Map<String, dynamic> answers,
    double? score,
    int? totalQuestions,
    int? correctAnswers,
    required DateTime startedAt,
    DateTime? completedAt,
  }) : super(
          id: id,
          userId: userId,
          quizId: quizId,
          quizTitle: quizTitle,
          answers: answers,
          score: score,
          totalQuestions: totalQuestions,
          correctAnswers: correctAnswers,
          startedAt: startedAt,
          completedAt: completedAt,
        );

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      id: json['id'],
      userId: json['userId'],
      quizId: json['quizId'],
      quizTitle: json['quizTitle'],
      answers: Map<String, dynamic>.from(json['answers'] ?? {}),
      score: json['score'] != null ? (json['score'] as num).toDouble() : null,
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      startedAt: json['startedAt'] != null
          ? (json['startedAt'] is DateTime
              ? json['startedAt']
              : DateTime.parse(json['startedAt'].toString()))
          : DateTime.now(),
      completedAt: json['completedAt'] != null
          ? (json['completedAt'] is DateTime
              ? json['completedAt']
              : DateTime.parse(json['completedAt'].toString()))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'quizId': quizId,
      'quizTitle': quizTitle,
      'answers': answers,
      'score': score,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory QuizResultModel.fromEntity(QuizResult result) {
    return QuizResultModel(
      id: result.id,
      userId: result.userId,
      quizId: result.quizId,
      quizTitle: result.quizTitle,
      answers: result.answers,
      score: result.score,
      totalQuestions: result.totalQuestions,
      correctAnswers: result.correctAnswers,
      startedAt: result.startedAt,
      completedAt: result.completedAt,
    );
  }

  QuizResultModel copyWith({
    String? id,
    String? userId,
    String? quizId,
    String? quizTitle,
    Map<String, dynamic>? answers,
    double? score,
    int? totalQuestions,
    int? correctAnswers,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return QuizResultModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      quizId: quizId ?? this.quizId,
      quizTitle: quizTitle ?? this.quizTitle,
      answers: answers ?? this.answers,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
