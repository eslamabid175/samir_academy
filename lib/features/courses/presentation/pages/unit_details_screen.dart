import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samir_academy/core/navigation/routes.dart'; // Import AppRoutes
import 'package:samir_academy/features/auth/presentation/bloc/auth_bloc.dart'; // Import AuthBloc
import 'package:samir_academy/features/courses/presentation/bloc/course_bloc.dart';
// import 'package:samir_academy/features/courses/presentation/pages/lesson_details_screen.dart'; // No longer needed for direct navigation
// import 'package:samir_academy/features/courses/presentation/pages/add_lesson_screen.dart'; // No longer needed for direct navigation

class UnitDetailsScreen extends StatefulWidget {
  final String courseId;
  final String unitId;
  final String unitTitle;

  const UnitDetailsScreen({
    Key? key,
    required this.courseId,
    required this.unitId,
    required this.unitTitle,
  }) : super(key: key);

  @override
  State<UnitDetailsScreen> createState() => _UnitDetailsScreenState();
}

class _UnitDetailsScreenState extends State<UnitDetailsScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load lessons only if not already loaded for this unit
    final state = context.read<CourseBloc>().state;
    bool shouldLoad = true;
    if (state is UnitDetailsLoaded) {
      // Check if the loaded lessons correspond to the current unit/course
      // This relies on the improved bloc caching logic
      shouldLoad = false; // Assume cache is valid if state is UnitDetailsLoaded
    }
    if (shouldLoad) {
      _loadLessons();
    }
  }

  @override
  void dispose() {
    // Don't clear cache on dispose
    super.dispose();
  }

  void _loadLessons() {
    // Dispatch event to load lessons for this unit
    BlocProvider.of<CourseBloc>(context).add(
      GetLessonsEvent(courseId: widget.courseId, unitId: widget.unitId),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        final state = context.read<CourseBloc>().state;
        if (state is CourseActionLoading || state is UnitDetailsLoading) {
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.unitTitle), // Use the passed unit title (assuming it's dynamic)
        ),
        body: BlocBuilder<CourseBloc, CourseState>(
          builder: (context, state) {
            // Handle loading state specifically for this unit's lessons
            if (state is UnitDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            // Handle error state
            else if (state is CourseError) {
              // Check if the error is relevant or show a generic error
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('error_loading_lessons'.tr(args: [state.message]), textAlign: TextAlign.center),
                ),
              );
            }
            // Handle loaded state for lessons
            else if (state is UnitDetailsLoaded) {
              final lessons = state.lessons;
              return RefreshIndicator(
                onRefresh: () async => _loadLessons(), // Add pull-to-refresh
                child: lessons.isEmpty
                    ? Center(
                        child: Text('no_lessons_available'.tr()),
                      )
                    : ListView.builder(
                        itemCount: lessons.length,
                        itemBuilder: (context, index) {
                          final lesson = lessons[index];
                          return ListTile(
                            leading: const Icon(Icons.play_circle_outline), // Icon for lesson
                            title: Text(lesson.title), // Assuming title is dynamic
                            subtitle: Text('lesson_order'.tr(args: ['${lesson.order}'])), // Display order
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              // Navigate using named route
                              Navigator.pushNamed(
                                context,
                                AppRoutes.lessonDetails,
                                arguments: {
                                  'courseId': widget.courseId,
                                  'unitId': widget.unitId,
                                  'lessonId': lesson.id,
                                  'lessonTitle': lesson.title, // Pass title for app bar
                                },
                              );
                            },
                          );
                        },
                      ),
              );
            } else {
              // Fallback for initial state or other unhandled states
              // Trigger loading if state is not relevant
              if (state is! UnitDetailsLoading) _loadLessons();
              return Center(child: Text('loading_lessons'.tr())); // Show loading
            }
          },
        ),
        // Conditionally display FAB based on AuthState
        floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthAuthenticated && authState.user.isAdmin) {
              return FloatingActionButton(
                onPressed: () {
                  // Navigate using named route
                  Navigator.pushNamed(
                    context,
                    AppRoutes.addLesson,
                    arguments: {
                      'courseId': widget.courseId,
                      'unitId': widget.unitId,
                    },
                  ).then((success) {
                    // Refresh lessons if a lesson was added successfully
                    if (success == true) {
                      // Invalidate cache and reload lessons
                      BlocProvider.of<CourseBloc>(context).clearCache(); // Consider more granular invalidation
                      _loadLessons();
                    }
                  });
                },
                child: const Icon(Icons.add),
                tooltip: 'add_lesson'.tr(),
              );
            } else {
              // Return null or an empty SizedBox if user is not admin
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

