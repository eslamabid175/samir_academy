import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samir_academy/core/navigation/app_router.dart';
import 'package:samir_academy/core/navigation/routes.dart';
import 'package:samir_academy/presentation/bloc/settings/settings_bloc.dart';
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
        BlocProvider(create: (_) => di.sl<SettingsBloc>()..add(LoadSettings())),
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
            initialRoute: '/', // استخدم / كـ default
          );
        },
      ),
    );
  }
}

// ✅ SplashScreen as default route (mapped to "/")
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
              onboardingCompleted ? AppRoutes.home : AppRoutes.onboarding;
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
