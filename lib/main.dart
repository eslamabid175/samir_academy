import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samir_academy/core/navigation/app_router.dart'; // Import AppRouter
import 'package:samir_academy/core/navigation/routes.dart'; // Import AppRoutes
import 'package:samir_academy/presentation/bloc/settings/settings_bloc.dart'; // Import SettingsBloc
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/courses/presentation/bloc/course_bloc.dart';
import 'features/onboarding/data/dataSource/onboarding_local_data_source.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        BlocProvider(create: (_) => di.sl<SettingsBloc>()..add(LoadSettings())), // Use dependency injection
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: settingsState.locale, // Use locale from SettingsBloc
            title: "Samir Academy", // Use translation key
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
              // Define other light theme properties
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.dark,
              // Define other dark theme properties
            ),
            themeMode: settingsState.themeMode, // Use themeMode from SettingsBloc
            onGenerateRoute: AppRouter.generateRoute, // Use named routes
            home: const SplashScreen(), // Initial screen
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {  // Change to StatefulWidget
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final onboardingStatus = await di.sl<OnboardingLocalDataSource>().getOnboardingStatus();

    if (mounted) {
      if (!onboardingStatus) {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
