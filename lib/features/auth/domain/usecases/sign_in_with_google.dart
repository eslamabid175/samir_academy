import 'package:dartz/dartz.dart';
import 'package:samir_academy/core/error/failures.dart';
import 'package:samir_academy/core/usecases/usecase.dart';
import 'package:samir_academy/features/auth/domain/entities/user_entity.dart';
import 'package:samir_academy/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogle implements UseCase<UserEntity, NoParams>{

 final AuthRepository authRepository;
 SignInWithGoogle(this.authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
return await authRepository.signInWithGoogle();
  }

}

class NoParams {
}