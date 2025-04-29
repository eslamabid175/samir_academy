import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/course_bloc.dart';
import 'course_detail_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: BlocConsumer<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state is CourseError) {
            Fluttertoast.showToast(msg: state.message);
          }
        },
        builder: (context, state) {
          if (state is CourseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CourseLoaded) {
            return ListView.builder(
              itemCount: state.courses.length,
              itemBuilder: (context, index) {
                final course = state.courses[index];
                return ListTile(
                  title: Text(course.title),
                  subtitle: Text(course.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailPage(),
                     //   builder: (context) => CourseDetailPage(course: course),
                      ),
                    );
                  },
                );
              },
            );
          }
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<CourseBloc>().add(GetCoursesEvent());
              },
              child: const Text('Load Courses'),
            ),
          );
        },
      ),
    );
  }
}