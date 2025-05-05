import '../../domain/entities/question.dart';

class QuestionModel extends Question {
  const QuestionModel({
    required String id,
    required String quizId,
    required String text,
    required String type,
    required List<String> options,
    required dynamic correctAnswer,
    required int points,
    required int order,
    required String? explanation,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          quizId: quizId,
          text: text,
          type: type,
          options: options,
          correctAnswer: correctAnswer,
          points: points,
          order: order,
          explanation: explanation,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      quizId: json['quizId'],
      text: json['text'],
      type: json['type'],
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'],
      points: json['points'] ?? 1,
      order: json['order'] ?? 0,
      explanation: json['explanation'],
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is DateTime
              ? json['createdAt']
              : DateTime.parse(json['createdAt'].toString()))
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is DateTime
              ? json['updatedAt']
              : DateTime.parse(json['updatedAt'].toString()))
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizId': quizId,
      'text': text,
      'type': type,
      'options': options,
      'correctAnswer': correctAnswer,
      'points': points,
      'order': order,
      'explanation': explanation,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory QuestionModel.fromEntity(Question question) {
    return QuestionModel(
      id: question.id,
      quizId: question.quizId,
      text: question.text,
      type: question.type,
      options: question.options,
      correctAnswer: question.correctAnswer,
      points: question.points,
      order: question.order,
      explanation: question.explanation,
      createdAt: question.createdAt,
      updatedAt: question.updatedAt,
    );
  }
}
