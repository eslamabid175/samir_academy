import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:samir_academy/core/error/failures.dart';
import 'package:samir_academy/core/usecases/usecase.dart';
import '../entities/lesson.dart';
import '../repositories/course_repository.dart';

class GetLessonDetails implements UseCase< Lesson, GetLessonDetailsParams> {
  final CourseRepository repository;

  GetLessonDetails(this.repository);

  @override
  Future<Either<Failure, Lesson>> call(GetLessonDetailsParams params) async {
    return await repository.getLessonDetails(params.courseId, params.unitId, params.lessonId);
  }
}

class GetLessonDetailsParams extends Equatable {
  final String courseId;
  final String unitId;
  final String lessonId;

  const GetLessonDetailsParams({
    required this.courseId,
    required this.unitId,
    required this.lessonId,
  });

  @override
  List<Object?> get props => [courseId, unitId, lessonId];
}

