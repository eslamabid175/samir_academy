import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/usecases/sign_in_with_google.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingStatus implements UseCase<bool, NoParams> {
  final OnboardingRepository repository;

  GetOnboardingStatus(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    try {
      final status = await repository.getOnboardingStatus();
      return Right(status);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}