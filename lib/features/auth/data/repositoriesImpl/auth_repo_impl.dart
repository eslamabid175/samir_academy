import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:samir_academy/features/auth/domain/entities/user_entity.dart';
import 'package:samir_academy/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/error/failures.dart';
import '../dataSources/remoteDataSource/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final userModel = await remoteDataSource.signInWithGoogle();
      if (userModel.id.isEmpty || userModel.email.isEmpty) {
        return Left(AuthFailure('Invalid user data received'));
      }
      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Firebase authentication failed'));
    } catch (e) {
      if (e.toString().contains('cancelled')) {
        return Left(const AuthFailure('Sign-in was cancelled'));
      }
      return Left(AuthFailure('Authentication failed: ${e.toString()}'));
    }
  }

  // @override
  // Future<Either<Failure, void>> signOut() async {
  //   try {
  //     await remoteDataSource.signOut();
  //     return const Right(null);
  //   } catch (e) {
  //     return Left(AuthFailure('Failed to sign out: ${e.toString()}'));
  //   }
  // }

  @override
  Future<Either<Failure, void>> deleteUser() async {
    try {
      await remoteDataSource.deleteUSer();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Failed to delete user: ${e.toString()}'));
    }
  }


  @override
  Future<Either<Failure, void>> saveUser(UserEntity user) async {
    try {
      await remoteDataSource.saveUser(user as UserModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
