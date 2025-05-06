import 'package:dartz/dartz.dart' as e;
import 'package:equatable/equatable.dart';
import 'package:samir_academy/core/error/failures.dart';
import 'package:samir_academy/core/usecases/usecase.dart';
import '../entities/unit.dart';
import '../repositories/course_repository.dart';

class GetUnits implements UseCase<List<Unit>, GetUnitsParams> {
  final CourseRepository repository;

  GetUnits(this.repository);

  @override
  Future<e.Either<Failure, List<Unit>>> call(GetUnitsParams params) async {
    return await repository.getUnits(params.courseId);
  }
}

class GetUnitsParams extends Equatable {
  final String courseId;

  const GetUnitsParams({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

