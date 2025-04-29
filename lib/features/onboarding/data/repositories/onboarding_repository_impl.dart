import '../dataSource/onboarding_local_data_source.dart';
import '../../domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> getOnboardingStatus() async {
    return await localDataSource.getOnboardingStatus();
  }

  @override
  Future<void> setOnboardingCompleted() async {
    await localDataSource.setOnboardingCompleted();
  }
}