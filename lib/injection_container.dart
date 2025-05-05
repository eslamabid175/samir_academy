import 'package:get_it/get_it.dart';
import 'package:samir_academy/presentation/bloc/settings/settings_bloc.dart';
import 'features/auth/data/dataSources/remoteDataSource/auth_remote_data_source.dart';
import 'features/auth/data/repositoriesImpl/auth_repo_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user.dart'; // Import GetCurrentUser use case
import 'features/auth/domain/usecases/save_user.dart';
import 'features/auth/domain/usecases/sign_in_with_google.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/books/data/datasources/books_local_data_source.dart';
import 'features/books/data/datasources/books_remote_data_source.dart';
import 'features/books/data/repositories/books_repository_impl.dart';
import 'features/books/domain/repositories/books_repository.dart';
import 'features/books/domain/usecases/add_bookmark_usecase.dart';
import 'features/books/domain/usecases/add_note_usecase.dart';
import 'features/books/domain/usecases/get_book_details_usecase.dart';
import 'features/books/domain/usecases/get_books_usecase.dart';
import 'features/books/presentation/bloc/books_bloc.dart';
import 'features/courses/data/dataSource/course_remote_data_source.dart';
import 'features/courses/data/repoimpl/course_repository_impl.dart';
import 'features/courses/domain/repositories/course_repository.dart';
import 'features/courses/domain/usecases/add_category.dart';
import 'features/courses/domain/usecases/add_course.dart';
import 'features/courses/domain/usecases/add_lesson.dart';
import 'features/courses/domain/usecases/add_unit.dart';
import 'features/courses/domain/usecases/get_categories.dart';
import 'features/courses/domain/usecases/get_course_details.dart';
import 'features/courses/domain/usecases/get_courses.dart';
import 'features/courses/domain/usecases/get_lesson_details.dart';
import 'features/courses/domain/usecases/get_lessons.dart';
import 'features/courses/domain/usecases/get_units.dart';
import 'features/courses/presentation/bloc/course_bloc.dart';
import 'features/onboarding/data/dataSource/onboarding_local_data_source.dart';
import 'features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'features/onboarding/domain/repositories/onboarding_repository.dart';
import 'features/onboarding/domain/usecases/get_onboarding_status.dart';
import 'features/onboarding/domain/usecases/set_onboarding_status.dart';
import 'features/quizzes/data/datasources/quizzes_local_data_source.dart';
import 'features/quizzes/data/datasources/quizzes_remote_data_source.dart';
import 'features/quizzes/data/repositories/quizzes_repository_impl.dart';
import 'features/quizzes/domain/repositories/quizzes_repository.dart';
import 'features/quizzes/domain/usecases/get_quizzes_usecase.dart';
import 'features/quizzes/domain/usecases/submit_quiz_answer_usecase.dart';
import 'features/quizzes/presentation/bloc/quizzes_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Auth Use Cases
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SaveUser(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl())); // Register GetCurrentUser use case

  // Register AuthBloc
  sl.registerFactory(() => AuthBloc(
        signInWithGoogle: sl(),
        saveUser: sl(),
        signOut: sl(),
        getCurrentUser: sl(), // Inject GetCurrentUser use case
      )..add(CheckAuthStatusEvent()) // Add event to check status on creation
  );

  // Course Use Cases
  sl.registerLazySingleton(() => GetCourses(sl()));
  sl.registerLazySingleton(() => GetCourseDetails(sl()));
  sl.registerLazySingleton(() => GetUnits(sl()));
  sl.registerLazySingleton(() => GetLessons(sl()));
  sl.registerLazySingleton(() => GetLessonDetails(sl()));
  sl.registerLazySingleton(() => AddCourse(sl()));
  sl.registerLazySingleton(() => AddUnit(sl()));
  sl.registerLazySingleton(() => AddLesson(sl()));
  sl.registerLazySingleton(() => AddCategory(sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));

  // Register CourseBloc
  sl.registerFactory(() => CourseBloc(
        getCourses: sl(),
        getCourseDetails: sl(),
        getUnits: sl(),
        getLessons: sl(),
        getLessonDetails: sl(),
        getCategories: sl(),
        addCourse: sl(),
        addUnit: sl(),
        addLesson: sl(),
    addCategory: sl(),

      ));

  // Onboarding Use Cases
  sl.registerLazySingleton(() => GetOnboardingStatus(sl()));
  sl.registerLazySingleton(() => SetOnboardingCompleted(sl()));

  // Register SettingsBloc
  sl.registerFactory(() => SettingsBloc());

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




  //! Features - Books
  // Bloc
  sl.registerFactory(
        () => BooksBloc(
      getBooksUseCase: sl(),
      getBookDetailsUseCase: sl(),
      addBookmarkUseCase: sl(),
      addNoteUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetBooksUseCase(sl()));
  sl.registerLazySingleton(() => GetBookDetailsUseCase(sl()));
  sl.registerLazySingleton(() => AddBookmarkUseCase(sl()));
  sl.registerLazySingleton(() => AddNoteUseCase(sl()));

  // Repository
  sl.registerLazySingleton<BooksRepository>(
        () => BooksRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<BooksRemoteDataSource>(
        () => BooksRemoteDataSourceImpl(
      firestore: sl(),
    ),
  );
  sl.registerLazySingleton<BooksLocalDataSource>(
        () => BooksLocalDataSourceImpl(
      box: sl(),
    ),
  );

  //! Features - Quizzes
  // Bloc
  sl.registerFactory(
        () => QuizzesBloc(
      getQuizzesUseCase: sl(),
      submitQuizAnswerUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() =>  GetQuizzesUseCase(sl()));
  sl.registerLazySingleton(() => SubmitQuizAnswerUseCase(sl()));

  // Repository
  sl.registerLazySingleton<QuizzesRepository>(
        () => QuizzesRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<QuizzesRemoteDataSource>(
        () => QuizzesRemoteDataSourceImpl(
      firestore: sl(),
    ),
  );
  sl.registerLazySingleton<QuizzesLocalDataSource>(
        () => QuizzesLocalDataSourceImpl(
      box: sl(),
    ),
  );


}

