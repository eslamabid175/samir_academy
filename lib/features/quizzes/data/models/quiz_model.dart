import '../../domain/entities/quiz.dart';

class QuizModel extends Quiz {
  const QuizModel({
    required String id,
    required String title,
    required String description,
    required String courseId,
    required String courseTitle,
    required int questionCount,
    required int duration,
    required int attempts,
    required double passingScore,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          title: title,
          description: description,
          courseId: courseId,
          courseTitle: courseTitle,
          questionCount: questionCount,
          duration: duration,
          attempts: attempts,
          passingScore: passingScore,
          isActive: isActive,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      courseId: json['courseId'],
      courseTitle: json['courseTitle'],
      questionCount: json['questionCount'],
      duration: json['duration'],
      attempts: json['attempts'] ?? 0,
      passingScore: (json['passingScore'] as num).toDouble(),
      isActive: json['isActive'] ?? true,
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
      'title': title,
      'description': description,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'questionCount': questionCount,
      'duration': duration,
      'attempts': attempts,
      'passingScore': passingScore,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory QuizModel.fromEntity(Quiz quiz) {
    return QuizModel(
      id: quiz.id,
      title: quiz.title,
      description: quiz.description,
      courseId: quiz.courseId,
      courseTitle: quiz.courseTitle,
      questionCount: quiz.questionCount,
      duration: quiz.duration,
      attempts: quiz.attempts,
      passingScore: quiz.passingScore,
      isActive: quiz.isActive,
      createdAt: quiz.createdAt,
      updatedAt: quiz.updatedAt,
    );
  }
}
