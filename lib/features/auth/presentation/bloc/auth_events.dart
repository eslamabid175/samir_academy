part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInWithGoogleEvent extends AuthEvent {}

class LogOutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {} // Added event

