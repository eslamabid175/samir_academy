import 'package:dartz/dartz.dart';
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
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      // If userModel is null, it means no user is logged in or an error occurred during fetch
      // Return Right(null) to indicate no authenticated user found
      return Right(userModel);
    } catch (e) {
      // Catch potential exceptions from the data source (though it's designed not to throw here)
      // Return a failure if an unexpected error occurs
      return Left(AuthFailure('Failed to check current user status: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final userModel = await remoteDataSource.signInWithGoogle();
      return Right(userModel);
    } on AuthFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AuthFailure('Authentication failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on AuthFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AuthFailure('Sign out failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser() async {
    try {
      await remoteDataSource.deleteUser();
      return const Right(null);
    } on AuthFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AuthFailure('Failed to delete user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveUser(UserEntity user) async {
    try {
      await remoteDataSource.saveUser(user as UserModel);
      return const Right(null);
    } on AuthFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Failed to save user data: ${e.toString()}'));
    }
  }
}

