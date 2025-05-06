import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/quiz.dart';
import '../repositories/quizzes_repository.dart';

class GetQuizzesUseCase {
  final QuizzesRepository repository;

  GetQuizzesUseCase(this.repository);

  Future<Either<Failure, List<Quiz>>> execute() async {
    return await repository.getQuizzes();
  }
}
