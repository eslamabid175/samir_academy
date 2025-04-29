import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

import '../../../../core/usecases/usecase.dart';
import '../repositories/course_repository.dart';

class AddUnit implements UseCase<void, AddUnitParams> {
  final CourseRepository repository;

  AddUnit(this.repository);

  @override
  Future<Either<Failure, void>> call(AddUnitParams params) async {
    return await repository.addUnit(params.courseId, params.unitId);
  }
}

class AddUnitParams {
  final String courseId;
  final String unitId;

  AddUnitParams({required this.courseId, required this.unitId});
}