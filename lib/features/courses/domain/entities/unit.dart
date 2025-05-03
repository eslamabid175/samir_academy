import 'package:equatable/equatable.dart';

class Unit extends Equatable {
  final String id;
  final String title;
  final int order;
  final String courseId;
  // Add timestamps if needed
  // final DateTime createdAt;
  // final DateTime updatedAt;

  const Unit({
    required this.id,
    required this.title,
    required this.order,
    required this.courseId,
    // required this.createdAt,
    // required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, title, order, courseId];
}

