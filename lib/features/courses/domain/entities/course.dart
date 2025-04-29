import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<String> units;
  final List<String> classrooms;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    this.units = const [],
    this.classrooms = const [],
  });

  @override
  List<Object> get props => [id, title, description, units, classrooms];
}