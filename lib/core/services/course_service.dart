// lib/features/courses/data/services/course_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../../features/courses/domain/entities/course.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Stream courses for a specific category
  Stream<List<Course>> streamCourses(String categoryId) {
    return _firestore
        .collection('categories')
        .doc(categoryId)
        .collection('courses')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Course(
          id: doc.id,
          title: data['title'],
          description: data['description'],
          categoryId: categoryId,
          imageUrl: data['imageUrl'],
        );
      }).toList();
    });
  }

  // Add new course with image
  Future<void> addCourse({
    required String categoryId,
    required String title,
    required String description,
    required File imageFile,
  }) async {
    // Upload image
    final storageRef = _storage.ref().child('courses/${DateTime.now()}.jpg');
    await storageRef.putFile(imageFile);
    final imageUrl = await storageRef.getDownloadURL();

    // Save course
    await _firestore
        .collection('categories')
        .doc(categoryId)
        .collection('courses')
        .add({
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now(),
    });
  }
}