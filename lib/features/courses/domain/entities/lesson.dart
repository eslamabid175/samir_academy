import 'package:equatable/equatable.dart';

class Lesson extends Equatable {
  final String id;
  final String title;
  final String description;
  final String youtubeVideoId;
  final int order;
  final String courseId;
  final String unitId;
  // Add timestamps if needed
  // final DateTime createdAt;
  // final DateTime updatedAt;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeVideoId,
    required this.order,
    required this.courseId,
    required this.unitId,
    // required this.createdAt,
    // required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, title, description,courseId,courseId, youtubeVideoId, order];
}

