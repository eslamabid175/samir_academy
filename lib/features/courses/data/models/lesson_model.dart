import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/lesson.dart';

class LessonModel extends Lesson {
  const LessonModel({
    required String id,
    required String title,
    required String description,
    required String youtubeVideoId,
    required int order,
    // Add courseId and unitId for context
    String courseId = '', // Added courseId
    String unitId = '',   // Added unitId
    // Add timestamps if needed
    // required DateTime createdAt,
    // required DateTime updatedAt,
  }) : super(
          id: id,
          title: title,
          description: description,
          youtubeVideoId: youtubeVideoId,
          order: order,
          courseId: courseId, // Pass courseId to super
          unitId: unitId,     // Pass unitId to super
          // createdAt: createdAt,
          // updatedAt: updatedAt,
        );

  // Renamed fromFirestore to fromSnapshot
  factory LessonModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LessonModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      youtubeVideoId: data['youtubeVideoId'] ?? '',
      order: data['order'] ?? 0,
      courseId: data['courseId'] ?? '', // Read courseId if available
      unitId: data['unitId'] ?? '',     // Read unitId if available
      // createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      // updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Renamed toFirestore to toJson
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'youtubeVideoId': youtubeVideoId,
      'order': order,
      'courseId': courseId, // Include courseId when writing
      'unitId': unitId,     // Include unitId when writing
      // Use FieldValue.serverTimestamp() for automatic timestamps on creation/update
      // 'createdAt': FieldValue.serverTimestamp(),
      // 'updatedAt': FieldValue.serverTimestamp(),
      // ID is typically not included when writing to Firestore using .add()
    };
  }
}

