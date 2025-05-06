import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:samir_academy/core/error/failures.dart';
import 'package:samir_academy/core/usecases/usecase.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';

class GetCourseDetails implements UseCase< Course, GetCourseDetailsParams> {
  final CourseRepository repository;

  GetCourseDetails(this.repository);

  @override
  Future<Either<Failure, Course>> call(GetCourseDetailsParams params) async {
    return await repository.getCourseDetails(params.courseId);
  }
}

class GetCourseDetailsParams extends Equatable {
  final String courseId;

  const GetCourseDetailsParams({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

