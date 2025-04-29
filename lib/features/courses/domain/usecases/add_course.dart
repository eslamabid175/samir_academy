import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';

class AddCourse implements UseCase<void, Course> {
  final CourseRepository repository;

  AddCourse(this.repository);

  @override
  Future<Either<Failure, void>> call(Course course) async {
    return await repository.addCourse(course);
  }
}