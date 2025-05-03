import 'package:dartz/dartz.dart';
import 'package:samir_academy/core/error/failures.dart';
import 'package:samir_academy/features/auth/domain/entities/user_entity.dart';
import 'package:samir_academy/features/auth/domain/repositories/auth_repository.dart';
import 'package:samir_academy/features/auth/domain/usecases/sign_in_with_google.dart';

import '../../../../core/usecases/usecase.dart';

class GetCurrentUser implements UseCase<UserEntity?, NoParams> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}

