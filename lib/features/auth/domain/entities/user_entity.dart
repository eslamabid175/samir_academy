import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final List<String> subscribedCourses;
  final bool isAdmin;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.subscribedCourses = const [],
    this.isAdmin = false,
  });

  @override
  List<Object> get props => [id, name, email, subscribedCourses, isAdmin];
}