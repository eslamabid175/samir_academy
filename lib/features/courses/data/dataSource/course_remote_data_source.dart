import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getCourses();
  Future<void> addCourse(CourseModel course);
  Future<void> addUnit(String courseId, String unitId);
  Future<void> addClassroom(String courseId, String classroomId);
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<CourseModel>> getCourses() async {
    try {
      final snapshot = await _firestore.collection('courses').get();
      return snapshot.docs.map((doc) => CourseModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> addCourse(CourseModel course) async {
    try {
      await _firestore
          .collection('courses')
          .doc(course.id)
          .set(course.toFirestore());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> addUnit(String courseId, String unitId) async {
    try {
      await _firestore.collection('courses').doc(courseId).update({
        'units': FieldValue.arrayUnion([unitId]),
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> addClassroom(String courseId, String classroomId) async {
    try {
      await _firestore.collection('courses').doc(courseId).update({
        'classrooms': FieldValue.arrayUnion([classroomId]),
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}