import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:samir_academy/features/auth/domain/entities/user_entity.dart';
import 'package:samir_academy/features/auth/domain/usecases/get_current_user.dart'; // Import GetCurrentUser
import 'package:samir_academy/features/auth/domain/usecases/save_user.dart';
import 'package:samir_academy/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:samir_academy/features/auth/domain/usecases/sign_out.dart';

part 'auth_events.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle signInWithGoogle;
  final SaveUser saveUser;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser; // Added GetCurrentUser use case

  AuthBloc({
    required this.signInWithGoogle,
    required this.saveUser,
    required this.signOut,
    required this.getCurrentUser, // Added to constructor
  }) : super(AuthInitial()) {
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<LogOutEvent>(_onLogOut);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus); // Added handler registration
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    // Don't emit loading here to avoid splash screen flicker if already logged in
    // emit(AuthLoading());
    final result = await getCurrentUser(NoParams());
    result.fold(
      (failure) {
        // If checking fails, assume not logged in
        print('Error checking auth status: ${failure.message}');
        emit(AuthInitial());
      },
      (user) {
        if (user != null) {
          // User is logged in, emit authenticated state
          emit(AuthAuthenticated(user));
        } else {
          // No user logged in
          emit(AuthInitial());
        }
      },
    );
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInWithGoogle(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogOut(LogOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading()); // Show loading during sign out
    final result = await signOut(NoParams());
    result.fold(
      (failure) {
        // Even if sign out fails, transition to AuthInitial
        print('Sign out failed: ${failure.message}');
        emit(AuthInitial());
      },
      (_) => emit(AuthInitial()), // Go to initial state on successful logout
    );
  }
}

