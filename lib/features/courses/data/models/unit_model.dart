import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/unit.dart';

class UnitModel extends Unit {
  const UnitModel({
    required String id,
    required String title,
    required int order,
    // Add courseId if needed for context, especially for adding units
    String courseId = '', // Added courseId, default to empty
    // Add timestamps if needed
    // required DateTime createdAt,
    // required DateTime updatedAt,
  }) : super(
          id: id,
          title: title,
          order: order,
          courseId: courseId, // Pass courseId to super
          // createdAt: createdAt,
          // updatedAt: updatedAt,
        );

  // Renamed fromFirestore to fromSnapshot
  factory UnitModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UnitModel(
      id: doc.id,
      title: data['title'] ?? '',
      order: data['order'] ?? 0,
      courseId: data['courseId'] ?? '', // Read courseId if available
      // createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      // updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Renamed toFirestore to toJson
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'order': order,
      'courseId': courseId, // Include courseId when writing
      // Use FieldValue.serverTimestamp() for automatic timestamps on creation/update
      // 'createdAt': FieldValue.serverTimestamp(),
      // 'updatedAt': FieldValue.serverTimestamp(),
      // ID is typically not included when writing to Firestore using .add()
    };
  }
}

