import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:samir_academy/presentation/pages/settings_page.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/ui/login_page.dart';
import '../../features/courses/presentation/bloc/course_bloc.dart';
import '../../features/courses/presentation/pages/bookmarks_page.dart';
import '../../features/courses/presentation/pages/course_detail_page.dart';
import '../../features/courses/presentation/pages/my_courses_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('home'.tr())),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.displayName ?? 'Guest'),
              accountEmail: Text(user?.email ?? 'Not signed in'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                child: user?.photoURL == null ? const Icon(Icons.person) : null,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: Text('my_courses'.tr()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyCoursesPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: Text('bookmarks'.tr()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookmarksPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text('settings'.tr()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: Text('privacy_policy'.tr()),
              onTap: () {
                Fluttertoast.showToast(msg: 'Privacy Policy not implemented yet');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text('about_us'.tr()),
              onTap: () {
                Fluttertoast.showToast(msg: 'About Us not implemented yet');
              },
            ),
            ListTile(
              leading: Icon(user == null ? Icons.login : Icons.logout),
              title: Text(user == null ? 'login'.tr() : 'logout'.tr()),
              onTap: () async {
                if (user == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                } else {
                  context.read<AuthBloc>().add(LogOutEvent());
                  // Wait for the logout process to complete before navigating
                  context.read<AuthBloc>().stream.firstWhere((state) => state is AuthInitial).then((_) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false, // Clear navigation stack after logout
                    );
                  });
                }
              },
            ),
          ],
        ),
      ),
      body: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          if (state is CourseInitial) {
            context.read<CourseBloc>().add(GetCoursesEvent());
          }
          if (state is CourseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CourseLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: state.courses.length,
              itemBuilder: (context, index) {
                final course = state.courses[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailPage(),
                     //     builder: (context) => CourseDetailPage(course: course),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.network(
                            'https://via.placeholder.com/150',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            course.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            course.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is CourseError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(); // Show nothing while loading
          }

          if (snapshot.hasError) {
            return const SizedBox(); // Handle errors gracefully
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const SizedBox(); // Document does not exist
          }

          final userData = snapshot.data!;
          if (userData['isAdmin'] == true) {
            return FloatingActionButton(
              onPressed: () {
                _showAdminDialog(context);
              },
              child: const Icon(Icons.add),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _showAdminDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('add_course'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('add_course'.tr()),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement add course form
                Fluttertoast.showToast(msg: 'Add Course not implemented yet');
              },
            ),
            ListTile(
              title: Text('add_unit'.tr()),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement add unit form
                Fluttertoast.showToast(msg: 'Add Unit not implemented yet');
              },
            ),
            ListTile(
              title: Text('add_classroom'.tr()),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement add classroom form
                Fluttertoast.showToast(msg: 'Add Classroom not implemented yet');
              },
            ),
          ],
        ),
      ),
    );
  }
}