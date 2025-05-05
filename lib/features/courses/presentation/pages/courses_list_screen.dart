import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samir_academy/core/navigation/routes.dart'; // Import AppRoutes
import 'package:samir_academy/features/auth/presentation/bloc/auth_bloc.dart'; // Import AuthBloc
import 'package:samir_academy/features/courses/presentation/bloc/course_bloc.dart';
// import 'package:samir_academy/features/courses/presentation/pages/add_course_screen.dart'; // No longer needed for direct navigation
// import 'package:samir_academy/features/courses/presentation/pages/course_details_screen.dart'; // No longer needed for direct navigation

class CoursesListScreen extends StatefulWidget {
  final String categoryId; // CategoryId is passed
final String categoryName;
  const CoursesListScreen({Key? key, required this.categoryId, required this.categoryName}) : super(key: key);

  @override
  _CoursesListScreenState createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends State<CoursesListScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load courses only if not already loaded for this category
    // Note: The improved CourseBloc handles caching, so this might be okay,
    // but ideally, check if the current loaded list matches the category.
    BlocProvider.of<CourseBloc>(context).add(GetCoursesEvent(categoryId: widget.categoryId));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        // TODO: Get category name instead of ID for title
        title: Text(widget.categoryName),
      ),
      body: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, courseState) {
          if (courseState is CourseListLoading || courseState is CourseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (courseState is CourseLoaded) {
            // Filter courses by categoryId if the bloc doesn't handle it internally
            // final coursesForCategory = courseState.courses.where((c) => c.categoryId == widget.categoryId).toList();
            // Assuming GetCoursesEvent correctly filters or the state holds category-specific courses
            final coursesForCategory = courseState.courses;

            if (coursesForCategory.isEmpty) {
              return Center(child: Text('no_courses_found'.tr()));
            }
            return ListView.builder(
              itemCount: coursesForCategory.length,
              itemBuilder: (context, index) {
                final course = coursesForCategory[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: course.imageUrl.isNotEmpty
                        ? Image.network(
                            course.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(width: 50, height: 50, child: Icon(Icons.broken_image)),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator()));
                            },
                          )
                        : const SizedBox(width: 50, height: 50, child: Icon(Icons.image)), // Placeholder if no image
                    title: Text(course.title), // Assuming title is already localized or doesn't need it
                    subtitle: Text(course.description, maxLines: 2, overflow: TextOverflow.ellipsis), // Assuming description is localized or doesn't need it
                    onTap: () {
                      // Navigate using named route
                      Navigator.pushNamed(
                        context,
                        AppRoutes.courseDetails,
                        arguments: course.id, // Pass course ID as argument
                      );
                    },
                  ),
                );
              },
            );
          } else if (courseState is CourseError) {
            return Center(child: Text('error_loading_courses'.tr(args: [courseState.message])));
          } else {
            return Center(child: Text('loading_courses'.tr()));
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
                  AppRoutes.addCourse,
                  arguments: widget.categoryId, // Pass categoryId as argument
                ).then((success) {
                   if (success == true) {
                      // Invalidate cache and reload courses for this category
                      BlocProvider.of<CourseBloc>(context).clearCache(); // Consider more granular invalidation
                      BlocProvider.of<CourseBloc>(context).add(GetCoursesEvent(categoryId: widget.categoryId));
                   }
                });
              },
              child: const Icon(Icons.add),
              tooltip: 'add_course'.tr(),
            );
          } else {
            // Return null or an empty SizedBox if user is not admin
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

