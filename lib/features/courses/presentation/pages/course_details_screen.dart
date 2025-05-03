import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samir_academy/core/navigation/routes.dart'; // Import AppRoutes
import 'package:samir_academy/features/auth/presentation/bloc/auth_bloc.dart'; // Import AuthBloc
import 'package:samir_academy/features/courses/presentation/bloc/course_bloc.dart';
// import 'package:samir_academy/features/courses/presentation/pages/unit_details_screen.dart'; // No longer needed for direct navigation
// import 'package:samir_academy/features/courses/presentation/pages/add_unit_screen.dart'; // No longer needed for direct navigation

class CourseDetailsScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailsScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load details only if not already loaded or if course ID differs
    final state = context.read<CourseBloc>().state;
    bool shouldLoad = true;
    if (state is CourseDetailsLoaded && state.course.id == widget.courseId) {
        // Check if units are also loaded for this course
        // Assuming the improved bloc ensures units are loaded with course details
        shouldLoad = false;
    }
    if (shouldLoad) {
      _loadDetails();
    }
  }

  @override
  void dispose() {
    // Don't clear cache on dispose to preserve state when navigating back
    super.dispose();
  }

  void _loadDetails() {
    // Dispatch event to load course details and units
    BlocProvider.of<CourseBloc>(context).add(GetCourseDetailsEvent(courseId: widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        // Prevent popping during loading states
        final state = context.read<CourseBloc>().state;
        if (state is CourseActionLoading || state is CourseDetailsLoading) {
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          // Title will be set based on loaded course in BlocBuilder
          title: BlocBuilder<CourseBloc, CourseState>(
            builder: (context, state) {
              if (state is CourseDetailsLoaded && state.course.id == widget.courseId) {
                return Text(state.course.title); // Assuming title is dynamic
              }
              return Text('course_details'.tr()); // Default title
            },
          ),
        ),
        body: BlocBuilder<CourseBloc, CourseState>(
          builder: (context, state) {
            // Handle loading state specifically for this course's details
            if (state is CourseDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            // Handle error state
            else if (state is CourseError) {
               // Check if the error is relevant or show a generic error
               return Center(
                 child: Padding(
                   padding: const EdgeInsets.all(16.0),
                   child: Text('error_loading_course_details'.tr(args: [state.message]), textAlign: TextAlign.center),
                 ),
               );
            }
            // Handle loaded state, ensuring it's for the correct course
            else if (state is CourseDetailsLoaded && state.course.id == widget.courseId) {
              final course = state.course;
              final units = state.units;
              return RefreshIndicator(
                onRefresh: () async => _loadDetails(), // Add pull-to-refresh
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course Image
                      if (course.imageUrl.isNotEmpty)
                        Image.network(
                          course.imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(height: 200, child: Center(child: Icon(Icons.broken_image, size: 50))),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 16.0),
                      // Course Title
                      Text(
                        course.title, // Assuming title is dynamic
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      // Course Description
                      Text(course.description, style: Theme.of(context).textTheme.bodyMedium), // Assuming description is dynamic
                      const SizedBox(height: 24.0),
                      // Units Section
                      Text(
                        'units'.tr(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Divider(),
                      if (units.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('no_units_available'.tr()),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: units.length,
                          itemBuilder: (context, index) {
                            final unit = units[index];
                            return ListTile(
                              title: Text(unit.title), // Assuming title is dynamic
                              subtitle: Text('unit_order'.tr(args: ['${unit.order}'])),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                // Navigate using named route
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.unitDetails,
                                  arguments: {
                                    'courseId': course.id,
                                    'unitId': unit.id,
                                    'unitTitle': unit.title, // Pass title for app bar
                                  },
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              );
            } else {
              // Fallback for initial state or other unhandled states
              // Trigger loading if state is not relevant to this screen
              if (state is! CourseDetailsLoading) _loadDetails();
              return Center(child: Text('loading_course_details'.tr())); // Show loading while fetching
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
                    AppRoutes.addUnit,
                    arguments: widget.courseId, // Pass courseId as argument
                  ).then((success) {
                    // Refresh details if a unit was added successfully
                    if (success == true) {
                      // Invalidate cache and reload details
                      BlocProvider.of<CourseBloc>(context).clearCache(); // Consider more granular invalidation
                      _loadDetails();
                    }
                  });
                },
                child: const Icon(Icons.add),
                tooltip: 'add_unit'.tr(),
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

