import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samir_academy/features/courses/data/models/course_model.dart';
import 'package:samir_academy/features/courses/data/models/lesson_model.dart';
import 'package:samir_academy/features/courses/data/models/unit_model.dart';

import '../models/category_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getCourses(String categoryId); // Changed categoryId to non-nullable based on usage
  Future<CourseModel> getCourseDetails(String courseId);
  Future<List<UnitModel>> getUnits(String courseId);
  // Updated interface to accept courseId for getLessons
  Future<List<LessonModel>> getLessons(String courseId, String unitId);
  // Updated interface to accept courseId for getLessonDetails
  Future<LessonModel> getLessonDetails(String courseId, String unitId, String lessonId);
  Future<void> addCourse(CourseModel course);
  Future<void> addUnit(UnitModel unit);
  Future<void> addLesson(LessonModel lesson);
  Future<List<CategoryModel>> getCategories();
  Future<void> addCategory(CategoryModel category);
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'categories'; // Define collection name

  @override
  Future<List<CourseModel>> getCourses(String categoryId) async {
    try {
      Query query = _firestore.collection('courses');
      if (categoryId.isNotEmpty) { // Allow fetching all courses if categoryId is empty
        query = query.where('categoryId', isEqualTo: categoryId);
      }
      final snapshot = await query.get();
      return snapshot.docs.map((doc) => CourseModel.fromSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching courses: $e');
      throw Exception('Failed to fetch courses: $e');
    }
  }

  @override
  Future<CourseModel> getCourseDetails(String courseId) async {
    try {
      final snapshot = await _firestore.collection('courses').doc(courseId).get();
      if (!snapshot.exists) {
        throw Exception('Course not found with ID: $courseId');
      }
      return CourseModel.fromSnapshot(snapshot);
    } catch (e) {
      print('Error fetching course details for ID $courseId: $e');
      throw Exception('Failed to fetch course details: $e');
    }
  }

  @override
  Future<List<UnitModel>> getUnits(String courseId) async {
    try {
      final snapshot = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('units')
          .orderBy('order')
          .get();
      return snapshot.docs.map((doc) => UnitModel.fromSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching units for course $courseId: $e');
      throw Exception('Failed to fetch units: $e');
    }
  }

  // --- FIX for getLessons ---
  @override
  Future<List<LessonModel>> getLessons(String courseId, String unitId) async {
    // Use direct path instead of collectionGroup query
    try {
      final snapshot = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('units')
          .doc(unitId)
          .collection('lessons')
          .orderBy('order')
          .get();
      return snapshot.docs.map((doc) => LessonModel.fromSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching lessons for course $courseId, unit $unitId: $e');
      // Provide more context in the error message
      throw Exception('Failed to fetch lessons for unit $unitId: $e');
    }
  }

  // --- FIX for getLessonDetails ---
  @override
  Future<LessonModel> getLessonDetails(String courseId, String unitId, String lessonId) async {
    // Use direct path instead of collectionGroup query
    try {
      final snapshot = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('units')
          .doc(unitId)
          .collection('lessons')
          .doc(lessonId)
          .get();

      if (!snapshot.exists) {
        throw Exception('Lesson not found with ID: $lessonId in unit $unitId');
      }
      return LessonModel.fromSnapshot(snapshot);
    } catch (e) {
      print('Error fetching lesson details for lesson $lessonId: $e');
      throw Exception('Failed to fetch lesson details: $e');
    }
  }

  @override
  Future<void> addCourse(CourseModel course) async {
    try {
      if (course.title.isEmpty) {
        throw Exception('Course title cannot be empty');
      }
      if (course.categoryId.isEmpty) {
        throw Exception('Category ID cannot be empty');
      }

      print('Attempting to add course to Firestore: ${course.toJson()}');

      // Check if a course with same title exists
      final existingCourses = await _firestore
          .collection('courses')
          .where('title', isEqualTo: course.title)
          .where('categoryId', isEqualTo: course.categoryId)
          .get();

      if (existingCourses.docs.isNotEmpty) {
        throw Exception('A course with this title already exists in this category');
      }

      final docRef = await _firestore.collection('courses').add(course.toJson());
      print('Course added successfully with ID: ${docRef.id}');

    } on FirebaseException catch (e) {
      print('FirebaseException adding course: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'permission-denied':
          throw Exception('You do not have permission to add courses');
        case 'unavailable':
          throw Exception('Service temporarily unavailable. Please try again later');
        default:
          throw Exception('Failed to add course: ${e.message}');
      }
    } catch (e) {
      print('Error adding course: $e');
      throw Exception('Failed to add course: $e');
    }
  }

  @override
  Future<void> addUnit(UnitModel unit) async {
    try {
      if (unit.courseId.isEmpty) {
        throw Exception('Course ID cannot be empty');
      }
      if (unit.title.isEmpty) {
        throw Exception('Unit title cannot be empty');
      }

      final courseRef = _firestore.collection('courses').doc(unit.courseId);

      // Verify course exists
      final courseDoc = await courseRef.get();
      if (!courseDoc.exists) {
        throw Exception('Course not found with ID: ${unit.courseId}');
      }

      // Check for duplicate unit titles in same course
      final existingUnits = await courseRef
          .collection('units')
          .where('title', isEqualTo: unit.title)
          .get();

      if (existingUnits.docs.isNotEmpty) {
        throw Exception('A unit with this title already exists in this course');
      }

      final unitRef = await courseRef.collection('units').add(unit.toJson());
      print('Unit added successfully with ID: ${unitRef.id}');

    } on FirebaseException catch (e) {
      print('FirebaseException adding unit: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'not-found':
          throw Exception('Course not found');
        case 'permission-denied':
          throw Exception('You do not have permission to add units to this course');
        default:
          throw Exception('Failed to add unit: ${e.message}');
      }
    } catch (e) {
      print('Error adding unit: $e');
      throw Exception('Failed to add unit: $e');
    }
  }

  // --- FIX for addLesson ---
  @override
  Future<void> addLesson(LessonModel lesson) async {
    try {
      if (lesson.courseId.isEmpty || lesson.unitId.isEmpty) {
        throw Exception('Course ID and Unit ID are required');
      }
      if (lesson.title.isEmpty) {
        throw Exception('Lesson title cannot be empty');
      }
      if (lesson.youtubeVideoId.isEmpty) {
        throw Exception('YouTube video ID cannot be empty');
      }

      final unitRef = _firestore
          .collection('courses')
          .doc(lesson.courseId)
          .collection('units')
          .doc(lesson.unitId);

      // Verify unit exists
      final unitDoc = await unitRef.get();
      if (!unitDoc.exists) {
        throw Exception('Unit not found with ID: ${lesson.unitId}');
      }

      // Check for duplicate lesson titles in same unit
      final existingLessons = await unitRef
          .collection('lessons')
          .where('title', isEqualTo: lesson.title)
          .get();

      if (existingLessons.docs.isNotEmpty) {
        throw Exception('A lesson with this title already exists in this unit');
      }

      final lessonRef = await unitRef.collection('lessons').add(lesson.toJson());
      print('Lesson added successfully with ID: ${lessonRef.id}');

    } on FirebaseException catch (e) {
      print('FirebaseException adding lesson: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'not-found':
          throw Exception('Course or unit not found');
        case 'permission-denied':
          throw Exception('You do not have permission to add lessons to this unit');
        case 'unavailable':
          throw Exception('Service temporarily unavailable. Please try again later');
        default:
          throw Exception('Failed to add lesson: ${e.message}');
      }
    } catch (e) {
      print('Error adding lesson: $e');
      throw Exception('Failed to add lesson: $e');
    }
  }


  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await _firestore.collection(_collectionPath).orderBy('name').get(); // Order by name for consistency
      return snapshot.docs
          .map((doc) => CategoryModel.fromSnapshot(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching categories: $e');
      // Consider throwing a specific exception type if needed
      throw Exception('Failed to fetch categories: $e');
    }
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    try {
      if (category.name.isEmpty) {
        throw Exception('Category name cannot be empty');
      }
      if (category.imageUrl.isEmpty || !Uri.parse(category.imageUrl).isAbsolute) {
        throw Exception('A valid category image URL is required');
      }

      // Check if a category with the same name already exists (case-insensitive check)
      final existingCategories = await _firestore
          .collection(_collectionPath)
          .where('name_lowercase', isEqualTo: category.name.toLowerCase())
          .limit(1)
          .get();

      if (existingCategories.docs.isNotEmpty) {
        throw Exception('A category with this name already exists.');
      }

      // Add category name in lowercase for case-insensitive checks
      final categoryData = category.toJson();
      categoryData['name_lowercase'] = category.name.toLowerCase();

      final docRef = await _firestore.collection(_collectionPath).add(categoryData);
      print('Category added successfully with ID: ${docRef.id}');

    } on FirebaseException catch (e) {
      print('FirebaseException adding category: ${e.code} - ${e.message}');
      // Handle specific Firebase errors if necessary
      throw Exception('Failed to add category: ${e.message}');
    } catch (e) {
      print('Error adding category: $e');
      throw Exception('Failed to add category: $e');
    }
  }

}
