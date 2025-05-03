import 'package:dartz/dartz.dart' as e;
import 'package:equatable/equatable.dart';
import 'package:samir_academy/core/error/failures.dart';
import 'package:samir_academy/core/usecases/usecase.dart';
import '../entities/unit.dart';
import '../repositories/course_repository.dart';

class AddUnit implements UseCase< void, AddUnitParams> {
  final CourseRepository repository;

  AddUnit(this.repository);

  @override
  Future<e.Either<Failure, void>> call(AddUnitParams params) async {
    // Create a Unit entity from params
    final unit = Unit(
      id: '', // Firestore will generate ID
      title: params.title,
      order: params.order,
      courseId: params.courseId,
    );
    return await repository.addUnit(params.courseId, unit);
  }
}

class AddUnitParams extends Equatable {
  final String courseId;
  final String title;
  final int order;

  const AddUnitParams({
    required this.courseId,
    required this.title,
    required this.order,
  });

  @override
  List<Object?> get props => [courseId, title, order];
}

