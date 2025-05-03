import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samir_academy/core/navigation/routes.dart';
import 'package:samir_academy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:samir_academy/features/courses/presentation/bloc/course_bloc.dart';
import 'package:samir_academy/features/courses/presentation/pages/add_course_screen.dart';
import 'package:samir_academy/features/courses/presentation/pages/add_lesson_screen.dart';
import 'package:samir_academy/features/courses/presentation/pages/add_unit_screen.dart';
import 'package:samir_academy/features/courses/presentation/pages/bookmarks_page.dart';
import 'package:samir_academy/features/courses/presentation/pages/courses_list_screen.dart';
import 'package:samir_academy/features/courses/presentation/pages/course_details_screen.dart';
import 'package:samir_academy/features/courses/presentation/pages/lesson_details_screen.dart';
import 'package:samir_academy/features/courses/presentation/pages/my_courses_page.dart';
import 'package:samir_academy/features/courses/presentation/pages/unit_details_screen.dart';
import 'package:samir_academy/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:samir_academy/injection_container.dart';
import 'package:samir_academy/presentation/pages/home_page.dart';
import 'package:samir_academy/presentation/pages/settings_page.dart';
import 'package:samir_academy/main.dart'; // لاستيراد SplashScreen

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // 🔍 Debug Log
    print('📍 Navigating to: ${settings.name} with args: ${settings.arguments}');

    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => HomePage());

      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());

      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => SettingsPage());

      case AppRoutes.myCourses:
        return MaterialPageRoute(builder: (_) => MyCoursesPage());

      case AppRoutes.bookmarks:
        return MaterialPageRoute(builder: (_) => BookmarksPage());

      case AppRoutes.coursesList:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: sl<CourseBloc>()),
                BlocProvider.value(value: sl<AuthBloc>()),
              ],
              child: CoursesListScreen(categoryId: args),
            ),
          );
        } else {
          return _errorRoute("Invalid arguments for coursesList");
        }

      case AppRoutes.courseDetails:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: sl<CourseBloc>()),
                BlocProvider.value(value: sl<AuthBloc>()),
              ],
              child: CourseDetailsScreen(courseId: args),
            ),
          );
        } else {
          return _errorRoute("Invalid arguments for courseDetails");
        }

      case AppRoutes.unitDetails:
        if (args is Map<String, String>) {
          return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: sl<CourseBloc>()),
                BlocProvider.value(value: sl<AuthBloc>()),
              ],
              child: UnitDetailsScreen(
                courseId: args['courseId']!,
                unitId: args['unitId']!,
                unitTitle: args['unitTitle']!,
              ),
            ),
          );
        } else {
          return _errorRoute("Invalid arguments for unitDetails");
        }

      case AppRoutes.lessonDetails:
        if (args is Map<String, String>) {
          return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: sl<CourseBloc>()),
                BlocProvider.value(value: sl<AuthBloc>()),
              ],
              child: LessonDetailsScreen(
                courseId: args['courseId']!,
                unitId: args['unitId']!,
                lessonId: args['lessonId']!,
                lessonTitle: args['lessonTitle']!,
              ),
            ),
          );
        } else {
          return _errorRoute("Invalid arguments for lessonDetails");
        }

      case AppRoutes.addCourse:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: sl<CourseBloc>()),
                BlocProvider.value(value: sl<AuthBloc>()),
              ],
              child: AddCourseScreen(categoryId: args),
            ),
          );
        } else {
          return _errorRoute("Invalid arguments for addCourse");
        }

      case AppRoutes.addUnit:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: sl<CourseBloc>()),
                BlocProvider.value(value: sl<AuthBloc>()),
              ],
              child: AddUnitScreen(courseId: args),
            ),
          );
        } else {
          return _errorRoute("Invalid arguments for addUnit");
        }

      case AppRoutes.addLesson:
        if (args is Map<String, String>) {
          return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: sl<CourseBloc>()),
                BlocProvider.value(value: sl<AuthBloc>()),
              ],
              child: AddLessonScreen(
                courseId: args['courseId']!,
                unitId: args['unitId']!,
              ),
            ),
          );
        } else {
          return _errorRoute("Invalid arguments for addLesson");
        }

      default:
        return _errorRoute("Unknown route: ${settings.name}");
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Routing Error: $message')),
      );
    });
  }
}
