import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/quiz.dart';
import '../entities/question.dart';
import '../entities/quiz_result.dart';

abstract class QuizzesRepository {
  Future<Either<Failure, List<Quiz>>> getQuizzes();
  Future<Either<Failure, Quiz>> getQuizDetails(String quizId);
  Future<Either<Failure, List<Question>>> getQuizQuestions(String quizId);
  Future<Either<Failure, QuizResult>> submitQuizAnswer(QuizResult result);
  Future<Either<Failure, List<QuizResult>>> getUserQuizResults(String userId);
  Future<Either<Failure, void>> saveDraftQuizAnswers(String quizId, Map<String, dynamic> answers);
  Future<Either<Failure, Map<String, dynamic>>> getDraftQuizAnswers(String quizId);
}
