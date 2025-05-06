import 'package:dartz/dartz.dart';
import 'package:samir_academy/core/error/failures.dart';
import 'package:samir_academy/core/usecases/usecase.dart';
import 'package:samir_academy/features/auth/domain/usecases/sign_in_with_google.dart';

import '../repositories/auth_repository.dart';

class DeleteUser implements UseCase<void,NoParams>{
  final AuthRepository _authRepository;

  DeleteUser(this._authRepository);
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
return await _authRepository.deleteUser();
  }

}
