import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart'; // Added for value equality
import '../../domain/entities/course.dart';

class CourseModel extends Course {
  const CourseModel({
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
          imageUrl: imageUrl,
          units: units,
          classrooms: classrooms,
        );

  // Renamed fromFirestore to fromSnapshot
  factory CourseModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CourseModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      categoryId: data['categoryId'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      units: List<String>.from(data['units'] ?? []),
      classrooms: List<String>.from(data['classrooms'] ?? []),
    );
  }

  // Renamed toFirestore to toJson
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'imageUrl': imageUrl,
      'units': units,
      'classrooms': classrooms,
      // ID is typically not included when writing to Firestore using .add()
      // or when updating, as it's part of the document path.
    };
  }
}

