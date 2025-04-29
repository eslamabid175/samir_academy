import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../dataSource/course_remote_data_source.dart';
import '../models/course_model.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;

  CourseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Course>>> getCourses() async {
    try {
      final courseModels = await remoteDataSource.getCourses();
      return Right(courseModels);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addCourse(Course course) async {
    try {
      await remoteDataSource.addCourse(course as CourseModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addUnit(String courseId, String unitId) async {
    try {
      await remoteDataSource.addUnit(courseId, unitId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addClassroom(String courseId, String classroomId) async {
    try {
      await remoteDataSource.addClassroom(courseId, classroomId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}