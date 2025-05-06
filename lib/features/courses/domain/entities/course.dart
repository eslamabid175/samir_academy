import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String imageUrl;
  final List<String> units; // Keep for compatibility or remove if strictly using subcollections
  final List<String> classrooms; // Keep for compatibility or remove if strictly using subcollections
  // Add timestamps if needed in the entity
  // final DateTime createdAt;
  // final DateTime updatedAt;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.imageUrl,
    this.units = const [],
    this.classrooms = const [],
    // required this.createdAt,
    // required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        categoryId,
        imageUrl,
        units,
        classrooms,
        // createdAt,
        // updatedAt,
      ];
}

