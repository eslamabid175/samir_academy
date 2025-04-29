import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/usecases/sign_in_with_google.dart';
import '../repositories/onboarding_repository.dart';

class SetOnboardingCompleted implements UseCase<void, NoParams> {
  final OnboardingRepository repository;

  SetOnboardingCompleted(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      await repository.setOnboardingCompleted();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}