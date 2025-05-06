import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart'; // Added for value equality
import 'package:samir_academy/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String id,
    required String name,
    required String email,
    List<String> subscribedCourses = const [],
    bool isAdmin = false,
  }) : super(
    id: id,
    name: name,
    email: email,
    subscribedCourses: subscribedCourses,
    isAdmin: isAdmin,
  );

  // Factory constructor to create a UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      subscribedCourses: List<String>.from(data['subscribedCourses'] ?? []),
      isAdmin: data['isAdmin'] ?? false,
    );
  }

  // Method to convert UserModel instance to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'subscribedCourses': subscribedCourses,
      'isAdmin': isAdmin,
      // Don't include 'id' here as it's the document ID
    };
  }
}

