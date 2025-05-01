// lib/features/courses/data/services/category_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../../features/courses/domain/entities/category.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Stream categories for real-time updates
  Stream<List<Category>> streamCategories() {
    return _firestore.collection('categories').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Category(
          id: doc.id,
          name: data['name'],
          imageUrl: data['imageUrl'],
        );
      }).toList();
    });
  }

  // Add new category with image upload
  Future<void> addCategory(String name, File imageFile) async {
    // Upload image to Firebase Storage
    final storageRef = _storage.ref().child('categories/${DateTime.now()}.jpg');
    await storageRef.putFile(imageFile);
    final imageUrl = await storageRef.getDownloadURL();

    // Save category to Firestore
    await _firestore.collection('categories').add({
      'name': name,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now(),
    });
  }
}