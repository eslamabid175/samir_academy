import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/course.dart';

class CourseModel extends Course {
  CourseModel({
    required String id,
    required String title,
    required String description,
    required String categoryId,
    required String imageUrl,
    List<String> units = const [],
    List<String> classrooms = const [],
  }) : super(
    id: id,
    title: title,
    description: description,
    categoryId: categoryId,
    imageUrl:imageUrl,
    units: units,
    classrooms: classrooms,
  );

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      categoryId: json['categoryId'],
      imageUrl: json['imageUrl'],
      units: List<String>.from(json['units'] ?? []),
      classrooms: List<String>.from(json['classrooms'] ?? []),
    );
  }

  factory CourseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseModel(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      categoryId: data['categoryId'],
      imageUrl: data['imageUrl'],
      units: List<String>.from(data['units'] ?? []),
      classrooms: List<String>.from(data['classrooms'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'categoryId':categoryId,
      'imageUrl':imageUrl,
      'units': units,
      'classrooms': classrooms,
    };
  }
}