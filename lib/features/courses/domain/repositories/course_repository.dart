import 'package:dartz/dartz.dart' as e;
import 'package:samir_academy/core/error/failures.dart';
import '../entities/course.dart';
import '../entities/unit.dart';
import '../entities/lesson.dart';

abstract class CourseRepository {
  Future<e.Either<Failure, List<Course>>> getCourses({String? categoryId});
  Future<e.Either<Failure, Course>> getCourseDetails(String courseId);
  Future<e.Either<Failure, List<Unit>>> getUnits(String courseId);
  Future<e.Either<Failure, List<Lesson>>> getLessons(String courseId, String unitId);
  Future<e.Either<Failure, Lesson>> getLessonDetails(String courseId, String unitId, String lessonId); // Added

  Future<e.Either<Failure, void>> addCourse(Course course);
  Future<e.Either<Failure, void>> addUnit(String courseId, Unit unit);
  Future<e.Either<Failure, void>> addLesson(String courseId, String unitId, Lesson lesson);

  // Keep addClassroom if still relevant, otherwise remove
 //  Future<e.Either<Failure, void>> addClassroom(String courseId, String classroomId);
}

