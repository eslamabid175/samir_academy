import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import '../../domain/entities/course.dart';
import 'course_detail_page.dart';

class MyCoursesPage extends StatelessWidget {
  const MyCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('my_courses'.tr())),
        body: const Center(child: Text('Please log in to view your courses')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('my_courses'.tr())),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No courses enrolled'));
          }
          final subscribedCourses = List<String>.from(snapshot.data!['subscribedCourses'] ?? []);
          if (subscribedCourses.isEmpty) {
            return const Center(child: Text('No courses enrolled'));
          }

          return ListView.builder(
            itemCount: subscribedCourses.length,
            itemBuilder: (context, index) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('courses')
                    .doc(subscribedCourses[index])
                    .get(),
                builder: (context, courseSnapshot) {
                  if (!courseSnapshot.hasData) {
                    return const ListTile(title: Text('Loading...'));
                  }
                  final courseData = courseSnapshot.data!.data() as Map<String, dynamic>;
                  final course = Course(
                    id: courseSnapshot.data!.id,
                    title: courseData['title'],
                    description: courseData['description'],
                    //todo: like above
                    categoryId: courseData['categoryId'],
                      imageUrl: courseData['imageUrl']
                  );
                  return ListTile(
                    title: Text(course.title),
                    subtitle: Text(course.description),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailPage(),
                     //     builder: (context) => CourseDetailPage(course: course),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}