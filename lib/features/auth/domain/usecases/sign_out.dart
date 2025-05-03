import 'package:dartz/dartz.dart';
import 'package:samir_academy/core/error/failures.dart';
import 'package:samir_academy/features/auth/domain/repositories/auth_repository.dart';
import 'package:samir_academy/features/auth/domain/usecases/sign_in_with_google.dart';

import '../../../../core/usecases/usecase.dart';
import 'delete_user.dart';

class SignOut implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SignOut(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.signOut();
  }
}

