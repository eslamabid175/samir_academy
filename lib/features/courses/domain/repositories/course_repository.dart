import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/course.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<Course>>> getCourses();
  Future<Either<Failure, void>> addCourse(Course course);
  Future<Either<Failure, void>> addUnit(String courseId, String unitId);
  Future<Either<Failure, void>> addClassroom(String courseId, String classroomId);
}