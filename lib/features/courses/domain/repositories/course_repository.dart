import 'package:dartz/dartz.dart' show Either;
import 'package:samir_academy/core/error/failures.dart';
import '../entities/category.dart';
import '../entities/course.dart';
import '../entities/unit.dart';
import '../entities/lesson.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<Course>>> getCourses({String? categoryId});
  Future<Either<Failure, Course>> getCourseDetails(String courseId);
  Future<Either<Failure, List<Unit>>> getUnits(String courseId);
  Future<Either<Failure, List<Lesson>>> getLessons(String courseId, String unitId);
  Future<Either<Failure, Lesson>> getLessonDetails(String courseId, String unitId, String lessonId); // Added

  Future<Either<Failure, void>> addCourse(Course course);
  Future<Either<Failure, void>> addUnit(String courseId, Unit unit);
  Future<Either<Failure, void>> addLesson(String courseId, String unitId, Lesson lesson);

  // Fetches all available categories
  Future<Either<Failure, List<Category>>> getCategories();

  // Adds a new category
  Future<Either<Failure, void>> addCategory(Category category);

// Optional: Methods for updating or deleting categories could be added here
// Future<Either<Failure, void>> updateCategory(Category category);
// Future<Either<Failure, void>> deleteCategory(String categoryId);
  // Keep addClassroom if still relevant, otherwise remove
 //  Future<Either<Failure, void>> addClassroom(String courseId, String classroomId);
}

