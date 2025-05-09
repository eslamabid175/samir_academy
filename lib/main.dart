import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:samir_academy/core/navigation/app_router.dart';
import 'package:samir_academy/core/navigation/routes.dart';
import 'package:samir_academy/presentation/bloc/settings/settings_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/books/presentation/bloc/books_bloc.dart';
import 'features/courses/presentation/bloc/course_bloc.dart';
import 'features/onboarding/data/dataSource/onboarding_local_data_source.dart';
import 'features/quizzes/presentation/bloc/quizzes_bloc.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter(); // Initialize Hive
  await Hive.openBox('local_storage'); // Open Hive box (replace with your box name)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  await di.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<CourseBloc>()),
        //..add(LoadSettings())), means that the LoadSettings event is dispatched when the SettingsBloc is created.
        // This is a good practice to load initial settings when the app starts.
        // This will trigger the LoadSettings event when the SettingsBloc is created.
        BlocProvider(create: (_) => di.sl<SettingsBloc>()..add(LoadSettings())),
        BlocProvider(create: (_) => di.sl<BooksBloc>()),
        BlocProvider(create: (_) => di.sl<QuizzesBloc>()),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: settingsState.locale,
            title: 'Samir Academy',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.dark,
            ),
            themeMode: settingsState.themeMode,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: '/',
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: di.sl<OnboardingLocalDataSource>().getOnboardingStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          print('❌ Error getting onboarding status: ${snapshot.error}');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.onboarding,
                    (route) => false,
              );
            }
          });
        } else {
          final bool onboardingCompleted = snapshot.data ?? false;
          print('✅ Onboarding completed: $onboardingCompleted');

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              final routeName =
              onboardingCompleted ? AppRoutes.preHome : AppRoutes.onboarding;
              Navigator.of(context).pushNamedAndRemoveUntil(
                routeName,
                    (route) => false,
              );
            }
          });
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}