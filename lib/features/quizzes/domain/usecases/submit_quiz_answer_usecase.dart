import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failures.dart';
import '../entities/quiz_result.dart';
import '../repositories/quizzes_repository.dart';

class SubmitQuizAnswerUseCase {
  final QuizzesRepository repository;

  SubmitQuizAnswerUseCase(this.repository);

  Future<Either<Failure, QuizResult>> execute(SubmitQuizParams params) async {
    // Create a result object
    final result = QuizResult(
      id: params.resultId ?? const Uuid().v4(),
      userId: params.userId,
      quizId: params.quizId,
      quizTitle: params.quizTitle,
      answers: params.answers,
      score: params.score,
      totalQuestions: params.totalQuestions,
      correctAnswers: params.correctAnswers,
      startedAt: params.startedAt ?? DateTime.now(),
      completedAt: params.completedAt,
    );
    
    return await repository.submitQuizAnswer(result);
  }
}

class SubmitQuizParams {
  final String? resultId;
  final String userId;
  final String quizId;
  final String quizTitle;
  final Map<String, dynamic> answers;
  final double? score;
  final int? totalQuestions;
  final int? correctAnswers;
  final DateTime? startedAt;
  final DateTime? completedAt;

  SubmitQuizParams({
    this.resultId,
    required this.userId,
    required this.quizId,
    required this.quizTitle,
    required this.answers,
    this.score,
    this.totalQuestions,
    this.correctAnswers,
    this.startedAt,
    this.completedAt,
  });
}
