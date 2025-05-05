import 'package:dartz/dartz.dart';
import 'package:samir_academy/core/error/failures.dart';
import 'package:samir_academy/core/usecases/usecase.dart';
import 'package:samir_academy/features/courses/domain/entities/category.dart';

import '../../../auth/domain/usecases/sign_in_with_google.dart';
import '../repositories/course_repository.dart';

// Or modify CourseRepository if categories are managed there
// import '../repositories/course_repository.dart';

class GetCategories implements UseCase<List<Category>, NoParams> {
  final CourseRepository repository;

  GetCategories(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) async {
    return await repository.getCategories();
  }
}

