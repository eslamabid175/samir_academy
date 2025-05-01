import 'dart:ffi';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, void>> deleteUser();
  Future<Either<Failure, void>> saveUser(UserEntity user);
  Future<Either<Failure, void>> updateUserAdminStatus(String userId, bool isAdmin);
}
