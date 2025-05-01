part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInWithGoogleEvent extends AuthEvent {}
class LogOutEvent extends AuthEvent {}
class UpdateUserAdminStatusEvent extends AuthEvent {
  final String userId;
  final bool isAdmin;

  const UpdateUserAdminStatusEvent({required this.userId, required this.isAdmin});

  @override
  List<Object> get props => [userId, isAdmin];
}
