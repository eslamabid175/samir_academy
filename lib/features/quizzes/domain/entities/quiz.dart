import 'package:equatable/equatable.dart';

class Quiz extends Equatable {
  final String id;
  final String title;
  final String description;
  final String courseId;
  final String courseTitle;
  final int questionCount;
  final int duration;  // in minutes
  final int attempts;  // max allowed attempts, 0 = unlimited
  final double passingScore;  // percentage to pass
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.courseTitle,
    required this.questionCount,
    required this.duration,
    required this.attempts,
    required this.passingScore,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    courseId,
    courseTitle,
    questionCount,
    duration,
    attempts,
    passingScore,
    isActive,
    createdAt,
    updatedAt,
  ];
}
