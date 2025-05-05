import 'package:samir_academy/features/courses/domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel(
      {required super.id, required super.name, required super.imageUrl});

  // Add factory constructor for Firestore deserialization if needed
  factory CategoryModel.fromSnapshot(Map<String, dynamic> data, String documentId) {
    return CategoryModel(
      id: documentId,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // Add method for Firestore serialization if needed
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      // ID is usually the document ID, not stored in the document data itself
    };
  }
}

