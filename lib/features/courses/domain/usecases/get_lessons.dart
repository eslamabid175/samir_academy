import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:samir_academy/core/error/failures.dart';
import 'package:samir_academy/core/usecases/usecase.dart';
import '../entities/lesson.dart';
import '../repositories/course_repository.dart';

class GetLessons implements UseCase< List<Lesson>, GetLessonsParams> {
  final CourseRepository repository;

  GetLessons(this.repository);

  @override
  Future<Either<Failure, List<Lesson>>> call(GetLessonsParams params) async {
    return await repository.getLessons(params.courseId, params.unitId);
  }
}

class GetLessonsParams extends Equatable {
  final String courseId;
  final String unitId;

  const GetLessonsParams({required this.courseId, required this.unitId});

  @override
  List<Object?> get props => [courseId, unitId];
}

