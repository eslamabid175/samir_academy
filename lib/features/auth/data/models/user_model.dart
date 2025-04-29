import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:samir_academy/features/auth/domain/entities/user_entity.dart';


class UserModel extends UserEntity {
  UserModel({
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

  factory UserModel.fromFirebase(User user) {
    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      subscribedCourses: List<String>.from(data['subscribedCourses'] ?? []),
      isAdmin: data['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'subscribedCourses': subscribedCourses,
      'isAdmin': isAdmin,
    };
  }
}