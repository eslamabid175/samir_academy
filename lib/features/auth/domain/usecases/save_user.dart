import 'package:dartz/dartz.dart';
import 'package:samir_academy/features/auth/domain/entities/user_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SaveUser implements UseCase<void, UserEntity> {
  final AuthRepository repository;

  SaveUser(this.repository);

  @override
  Future<Either<Failure, void>> call(UserEntity user) async {
    return await repository.saveUser(user);
  }
}