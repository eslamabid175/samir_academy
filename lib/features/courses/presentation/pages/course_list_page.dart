import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/dummy_data.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/course.dart';
import '../bloc/course_bloc.dart';
import 'course_detail_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CourseListPage extends StatelessWidget {
  final Category category;

  const CourseListPage({Key? key, required this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<Course> categoryCourses = DummyData.getCoursesByCategory(category.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('${category.name} Courses'),
        elevation: 0,
      ),

      body:

      categoryCourses.isEmpty
          ? const Center(
        child: Text(
          'No courses available for this category yet.',
          style: TextStyle(fontSize: 18),
        ),
      )
          :ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categoryCourses.length,
        itemBuilder: (ctx, index) {
          return _buildCourseCard(categoryCourses[index]);
        },
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              course.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  course.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // This would navigate to course details in a real app
                  },
                  child: const Text('View Details'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
