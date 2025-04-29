import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import '../../domain/entities/course.dart';
import 'course_detail_page.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('bookmarks'.tr())),
        body: const Center(child: Text('Please log in to view your bookmarks')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('bookmarks'.tr())),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No bookmarked courses'));
          }
          final bookmarkedCourses = List<String>.from(snapshot.data!['bookmarkedCourses'] ?? []);
          if (bookmarkedCourses.isEmpty) {
            return const Center(child: Text('No bookmarked courses'));
          }

          return ListView.builder(
            itemCount: bookmarkedCourses.length,
            itemBuilder: (context, index) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('courses')
                    .doc(bookmarkedCourses[index])
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
                  );
                  return ListTile(
                    title: Text(course.title),
                    subtitle: Text(course.description),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailPage(),
                         // builder: (context) => CourseDetailPage(course: course),
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