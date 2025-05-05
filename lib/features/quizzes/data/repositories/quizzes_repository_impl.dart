import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/quiz_result.dart';
import '../../domain/repositories/quizzes_repository.dart';
import '../datasources/quizzes_remote_data_source.dart';
import '../datasources/quizzes_local_data_source.dart';
import '../models/quiz_result_model.dart';

class QuizzesRepositoryImpl implements QuizzesRepository {
  final QuizzesRemoteDataSource remoteDataSource;
  final QuizzesLocalDataSource localDataSource;

  QuizzesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Quiz>>> getQuizzes() async {
    try {
      final remoteQuizzes = await remoteDataSource.getQuizzes();
      await localDataSource.cacheQuizzes(remoteQuizzes);
      return Right(remoteQuizzes);
    } on ServerFailure catch (e) {
      try {
        // If remote fetch fails, try to get from local cache
        final localQuizzes = await localDataSource.getCachedQuizzes();
        return Right(localQuizzes);
      } catch (_) {
        return Left(ServerFailure(   e.message));
      }
    } catch (e) {
      return Left(ServerFailure(   e.toString()));
    }
  }

  @override
  Future<Either<Failure, Quiz>> getQuizDetails(String quizId) async {
    try {
      final remoteQuiz = await remoteDataSource.getQuizDetails(quizId);
      await localDataSource.cacheQuizDetails(remoteQuiz);
      return Right(remoteQuiz);
    } on ServerFailure catch (e) {
      try {
        // If remote fetch fails, try to get from local cache
        final localQuiz = await localDataSource.getCachedQuizDetails(quizId);
        if (localQuiz != null) {
          return Right(localQuiz);
        } else {
          return Left(ServerFailure(   e.message));
        }
      } catch (_) {
        return Left(ServerFailure(   e.message));
      }
    } catch (e) {
      return Left(ServerFailure(   e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Question>>> getQuizQuestions(String quizId) async {
    try {
      final remoteQuestions = await remoteDataSource.getQuizQuestions(quizId);
      await localDataSource.cacheQuizQuestions(quizId, remoteQuestions);
      return Right(remoteQuestions);
    } on ServerFailure catch (e) {
      try {
        // If remote fetch fails, try to get from local cache
        final localQuestions = await localDataSource.getCachedQuizQuestions(quizId);
        if (localQuestions != null) {
          return Right(localQuestions);
        } else {
          return Left(ServerFailure(   e.message));
        }
      } catch (_) {
        return Left(ServerFailure(   e.message));
      }
    } catch (e) {
      return Left(ServerFailure(   e.toString()));
    }
  }

  @override
  Future<Either<Failure, QuizResult>> submitQuizAnswer(QuizResult result) async {
    try {
      final resultModel = QuizResultModel.fromEntity(result);
      final submittedResult = await remoteDataSource.submitQuizAnswer(resultModel);
      
      // Update the local cache of results for this user
      final userId = result.userId;
      try {
        final cachedResults = await localDataSource.getCachedQuizResults(userId);
        if (cachedResults != null) {
          // Add this result to the cached results or update if it exists
          final index = cachedResults.indexWhere((r) => r.id == submittedResult.id);
          if (index >= 0) {
            cachedResults[index] = submittedResult;
          } else {
            cachedResults.add(submittedResult);
          }
          await localDataSource.cacheQuizResults(userId, cachedResults);
        } else {
          await localDataSource.cacheQuizResults(userId, [submittedResult]);
        }
      } catch (_) {
        // Ignore cache errors
      }
      
      // Clear the draft answers for this quiz
      try {
        await localDataSource.saveDraftQuizAnswers(result.quizId, {});
      } catch (_) {
        // Ignore cache errors
      }
      
      return Right(submittedResult);
    } catch (e) {
      return Left(ServerFailure(   e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<QuizResult>>> getUserQuizResults(String userId) async {
    try {
      final remoteResults = await remoteDataSource.getUserQuizResults(userId);
      await localDataSource.cacheQuizResults(userId, remoteResults);
      return Right(remoteResults);
    } on ServerFailure catch (e) {
      try {
        // If remote fetch fails, try to get from local cache
        final localResults = await localDataSource.getCachedQuizResults(userId);
        if (localResults != null) {
          return Right(localResults);
        } else {
          return Right([]);  // Return empty list if no cached results
        }
      } catch (_) {
        return Left(ServerFailure(   e.message));
      }
    } catch (e) {
      return Left(ServerFailure(   e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveDraftQuizAnswers(String quizId, Map<String, dynamic> answers) async {
    try {
      await localDataSource.saveDraftQuizAnswers(quizId, answers);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(   e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDraftQuizAnswers(String quizId) async {
    try {
      final draftAnswers = await localDataSource.getDraftQuizAnswers(quizId);
      return Right(draftAnswers ?? {});
    } catch (e) {
      return Left(ServerFailure(   e.toString()));
    }
  }
}
