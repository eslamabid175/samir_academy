import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/usecases/sign_in_with_google.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';

class GetCourses implements UseCase<List<Course>, NoParams> {
  final CourseRepository repository;

  GetCourses(this.repository);

  @override
  Future<Either<Failure, List<Course>>> call(NoParams params) async {
    return await repository.getCourses();
  }
}