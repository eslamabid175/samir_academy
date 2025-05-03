import 'package:get_it/get_it.dart';

import 'features/auth/data/dataSources/remoteDataSource/auth_remote_data_source.dart';
import 'features/auth/data/repositoriesImpl/auth_repo_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/save_user.dart';
import 'features/auth/domain/usecases/sign_in_with_google.dart';
import 'features/auth/domain/usecases/update_user_admin_status.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/courses/data/dataSource/course_remote_data_source.dart';
import 'features/courses/data/repoimpl/course_repository_impl.dart';
import 'features/courses/domain/repositories/course_repository.dart';
import 'features/courses/domain/usecases/add_classroom.dart';
import 'features/courses/domain/usecases/add_course.dart';
import 'features/courses/domain/usecases/add_unit.dart';
import 'features/courses/domain/usecases/get_courses.dart';
import 'features/courses/presentation/bloc/course_bloc.dart';
import 'features/onboarding/data/dataSource/onboarding_local_data_source.dart';
import 'features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'features/onboarding/domain/repositories/onboarding_repository.dart';
import 'features/onboarding/domain/usecases/get_onboarding_status.dart';
import 'features/onboarding/domain/usecases/set_onboarding_status.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(() => AuthBloc(signInWithGoogle: sl(), saveUser: sl(), updateUserAdminStatus: sl()));
  sl.registerFactory(() => CourseBloc(getCourses: sl()));

  // Use Cases
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SaveUser(sl()));
  sl.registerLazySingleton(() => GetCourses(sl()));
  sl.registerLazySingleton(() => AddCourse(sl()));
  sl.registerLazySingleton(() => AddUnit(sl()));
  sl.registerLazySingleton(() => AddClassroom(sl()));
  sl.registerLazySingleton(() => GetOnboardingStatus(sl()));
  sl.registerLazySingleton(() => SetOnboardingCompleted(sl()));
  sl.registerLazySingleton(() => UpdateUserAdminStatus(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<CourseRepository>(
          () => CourseRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<OnboardingRepository>(
          () => OnboardingRepositoryImpl(localDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl());
  sl.registerLazySingleton<CourseRemoteDataSource>(
          () => CourseRemoteDataSourceImpl());
  sl.registerLazySingleton<OnboardingLocalDataSource>(
          () => OnboardingLocalDataSourceImpl());
}
