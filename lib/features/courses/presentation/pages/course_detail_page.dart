
import 'package:flutter/cupertino.dart';

class CourseDetailPage extends StatelessWidget {
  const CourseDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('Course Detail Page'),
      ),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:easy_localization/easy_localization.dart';

// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:flutter/material.dart';
//
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// import '../../domain/entities/course.dart';
//
// class CourseDetailPage extends StatefulWidget {
//   final Course course;
//
//   const CourseDetailPage({super.key, required this.course});
//
//   @override
//   _CourseDetailPageState createState() => _CourseDetailPageState();
// }
//
// class _CourseDetailPageState extends State<CourseDetailPage> {
//   late YoutubePlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: 'dQw4w9WgXcQ', // Replace with actual video ID
//       flags: const YoutubePlayerFlags(autoPlay: false),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Future<bool> _isEnrolled(String userId) async {
//     final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//     final subscribedCourses = List<String>.from(userDoc['subscribedCourses'] ?? []);
//     return subscribedCourses.contains(widget.course.id);
//   }
//
//   Future<bool> _isBookmarked(String userId) async {
//     final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//     final bookmarkedCourses = List<String>.from(userDoc['bookmarkedCourses'] ?? []);
//     return bookmarkedCourses.contains(widget.course.id);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final user = firebase_auth.FirebaseAuth.instance.currentUser;
//
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.course.title)),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             YoutubePlayer(
//               controller: _controller,
//               showVideoProgressIndicator: true,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.course.title,
//                     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(widget.course.description),
//                   const SizedBox(height: 20),
//                   if (user != null)
//                     FutureBuilder<bool>(
//                       future: _isEnrolled(user.uid),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData && !snapshot.data!) {
//                           return ElevatedButton(
//                             onPressed: () async {
//                               // Mock payment
//                               final enrolled = await _mockPayment(context);
//                               if (enrolled) {
//                                 await FirebaseFirestore.instance
//                                     .collection('users')
//                                     .doc(user.uid)
//                                     .update({
//                                   'subscribedCourses': FieldValue.arrayUnion([widget.course.id]),
//                                 });
//                                 Fluttertoast.showToast(msg: 'Enrolled successfully');
//                                 setState(() {});
//                               }
//                             },
//                             child: Text('enroll'.tr()),
//                           );
//                         }
//                         return const SizedBox();
//                       },
//                     ),
//                   const SizedBox(height: 10),
//                   if (user != null)
//                     FutureBuilder<bool>(
//                       future: _isBookmarked(user.uid),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           return ElevatedButton(
//                             onPressed: () async {
//                               final isBookmarked = snapshot.data!;
//                               await FirebaseFirestore.instance
//                                   .collection('users')
//                                   .doc(user.uid)
//                                   .update({
//                                 'bookmarkedCourses': isBookmarked
//                                     ? FieldValue.arrayRemove([widget.course.id])
//                                     : FieldValue.arrayUnion([widget.course.id]),
//                               });
//                               Fluttertoast.showToast(
//                                   msg: isBookmarked ? 'Bookmark removed' : 'Bookmarked');
//                               setState(() {});
//                             },
//                             child: Text(
//                                 snapshot.data! ? 'Remove Bookmark' : 'bookmark'.tr()),
//                           );
//                         }
//                         return const SizedBox();
//                       },
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<bool> _mockPayment(BuildContext context) async {
//     bool? result = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Mock Payment'),
//         content: const Text('Proceed with mock payment for this course?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Pay'),
//           ),
//         ],
//       ),
//     );
//     return result ?? false;
//   }
// }