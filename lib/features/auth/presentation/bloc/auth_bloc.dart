import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:samir_academy/features/auth/domain/entities/user_entity.dart';
import '../../domain/usecases/save_user.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/update_user_admin_status.dart';

part 'auth_events.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle signInWithGoogle;
  final SaveUser saveUser;
  final UpdateUserAdminStatus updateUserAdminStatus;

  AuthBloc({
    required this.signInWithGoogle,
    required this.saveUser,
    required this.updateUserAdminStatus,
  }) : super(AuthInitial()) {
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<LogOutEvent>(_onLogOut);
    on<UpdateUserAdminStatusEvent>(_onUpdateUserAdminStatus);
  }

  Future<void> _onLogOut(LogOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await GoogleSignIn().disconnect(); // Disconnect the Google account
      await FirebaseAuth.instance.signOut();
      emit(AuthInitial()); // Ensure the state is reset to AuthInitial after logout
    } catch (e) {
      emit(AuthError('Failed to log out: ${e.toString()}')); // Provide a clear error message
    }
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInWithGoogle(NoParams());
    await result.fold(
      (failure) async {
        emit(AuthError(failure.message));
      },
      (user) async {
        final saveResult = await saveUser(user);
        await saveResult.fold(
          (failure) async {
            emit(AuthError(failure.message));
          },
          (_) async {
            emit(AuthAuthenticated(user));
          },
        );
      },
    );
  }

  Future<void> _onUpdateUserAdminStatus(
      UpdateUserAdminStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await updateUserAdminStatus(UpdateUserAdminStatusParams(
      userId: event.userId,
      isAdmin: event.isAdmin,
    ));
    await result.fold(
      (failure) async {
        emit(AuthError(failure.message));
      },
      (_) async {
        emit(UserAdminStatusUpdated());
      },
    );
  }
}
