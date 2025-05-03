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
      // No need to check for empty fields here if UserModel.fromFirestore handles it
      return Right(userModel);
    } on AuthFailure catch (e) {
      // Catch specific AuthFailure from the data source
      return Left(e);
    } catch (e) {
      // Catch generic errors
      return Left(AuthFailure('Authentication failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null); // Indicate success with Right(null)
    } on AuthFailure catch (e) {
      // Catch specific AuthFailure from the data source if thrown
      return Left(e);
    } catch (e) {
      // Catch generic errors during sign out
      return Left(AuthFailure('Sign out failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser() async {
    try {
      await remoteDataSource.deleteUser(); // Corrected method name call
      return const Right(null);
    } on AuthFailure catch (e) {
      // Catch specific AuthFailure from the data source
      return Left(e);
    } catch (e) {
      return Left(AuthFailure('Failed to delete user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveUser(UserEntity user) async {
    try {
      // Ensure the user object is cast correctly if needed, but it should be UserModel
      await remoteDataSource.saveUser(user as UserModel);
      return const Right(null);
    } on AuthFailure catch (e) {
      // Catch specific AuthFailure from the data source
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Failed to save user data: ${e.toString()}'));
    }
  }
}

