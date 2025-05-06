import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:samir_academy/core/error/failures.dart';
import 'package:samir_academy/core/usecases/usecase.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';

class GetCourses implements UseCase<List<Course>, GetCoursesParams> {
  final CourseRepository repository;

  GetCourses(this.repository);

  @override
  Future<Either<Failure, List<Course>>> call(GetCoursesParams params) async {
    return await repository.getCourses(categoryId: params.categoryId);
  }
}

class GetCoursesParams extends Equatable {
  final String? categoryId;

  const GetCoursesParams({this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}