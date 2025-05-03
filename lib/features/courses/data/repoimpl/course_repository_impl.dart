import 'package:dartz/dartz.dart';
import 'package:samir_academy/core/error/failures.dart';
import 'package:samir_academy/features/courses/data/models/lesson_model.dart';
import 'package:samir_academy/features/courses/data/models/unit_model.dart';
import 'package:samir_academy/features/courses/domain/entities/lesson.dart';
import 'package:samir_academy/features/courses/domain/entities/unit.dart' as u;
import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../dataSource/course_remote_data_source.dart';
import '../models/course_model.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;

  CourseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Course>>> getCourses({String? categoryId}) async {
    try {
      // Pass empty string if categoryId is null, as datasource expects non-nullable
      final courseModels = await remoteDataSource.getCourses(categoryId ?? '');
      return Right(courseModels);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Course>> getCourseDetails(String courseId) async {
    try {
      final courseModel = await remoteDataSource.getCourseDetails(courseId);
      return Right(courseModel);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<u.Unit>>> getUnits(String courseId) async {
    try {
      final unitModels = await remoteDataSource.getUnits(courseId);
      return Right(unitModels);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // --- FIX: Pass courseId to remoteDataSource.getLessons ---
  @override
  Future<Either<Failure, List<Lesson>>> getLessons(String courseId, String unitId) async {
    try {
      // Pass both courseId and unitId to the data source method
      final lessonModels = await remoteDataSource.getLessons(courseId, unitId);
      return Right(lessonModels);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // --- FIX: Pass courseId and unitId to remoteDataSource.getLessonDetails ---
  @override
  Future<Either<Failure, Lesson>> getLessonDetails(String courseId, String unitId, String lessonId) async {
    try {
      // Pass all required IDs to the data source method
      final lessonModel = await remoteDataSource.getLessonDetails(courseId, unitId, lessonId);
      return Right(lessonModel);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addCourse(Course course) async {
    try {
      final courseModel = CourseModel(
        id: course.id, // ID might be ignored by datasource addCourse
        title: course.title,
        description: course.description,
        categoryId: course.categoryId,
        imageUrl: course.imageUrl,
      );
      await remoteDataSource.addCourse(courseModel);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addUnit(String courseId, u.Unit unit) async {
    try {
      final unitModel = UnitModel(
        id: unit.id, // ID might be ignored by datasource addUnit
        title: unit.title,
        order: unit.order,
        courseId: courseId, // Pass the courseId here
      );
      await remoteDataSource.addUnit(unitModel);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addLesson(String courseId, String unitId, Lesson lesson) async {
    try {
      // Pass courseId and unitId when creating LessonModel
      final lessonModel = LessonModel(
        id: lesson.id, // ID might be ignored by datasource addLesson
        title: lesson.title,
        description: lesson.description,
        youtubeVideoId: lesson.youtubeVideoId,
        order: lesson.order,
        courseId: courseId, // Pass the courseId here
        unitId: unitId,     // Pass the unitId here
      );
      await remoteDataSource.addLesson(lessonModel);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

//   @override
//   Future<Either<Failure, void>> addClassroom(String courseId, String classroomId) {
// try {
//       return remoteDataSource.addClassroom(courseId, classroomId);
//     } on ServerFailure catch (e) {
//       return Left(ServerFailure(e.message));
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }
}

