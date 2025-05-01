import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String imageUrl;
  final List<String> units;
  final List<String> classrooms;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.imageUrl,
    this.units = const [],
    this.classrooms = const [],
  });

  @override
  List<Object> get props => [id, title, description, categoryId ,imageUrl,units, classrooms];
}