import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:samir_academy/features/auth/domain/entities/user_entity.dart';
import '../../domain/usecases/save_user.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart'; // Import SignOut use case

part 'auth_events.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle signInWithGoogle;
  final SaveUser saveUser;
  final SignOut signOut; // Add SignOut use case

  AuthBloc({
    required this.signInWithGoogle,
    required this.saveUser,
    required this.signOut, // Inject SignOut use case
  }) : super(AuthInitial()) {
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<LogOutEvent>(_onLogOut);
    // Consider adding an event to check initial auth state if needed
    // on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onLogOut(LogOutEvent event, Emitter<AuthState> emit) async {

    final NoParams params = NoParams();
    emit(AuthLoading()); // Indicate loading state
    final result = await signOut(params); // Use the SignOut use case
    result.fold(
      (failure) {
        // Emit error state but might still want to transition to AuthInitial
        // Depending on whether partial logout is acceptable
        emit(AuthError('Failed to log out completely: ${failure.message}'));
        // Optionally, still emit AuthInitial if UI should reset regardless of error
        // emit(AuthInitial());
      },
      (_) {
        emit(AuthInitial()); // Transition to initial state on successful logout
      },
    );
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInWithGoogle(NoParams());
    result.fold(
      (failure) {
        emit(AuthError(failure.message));
      },
      (user) async {
        // No need to save user here if signInWithGoogle already handles it
        // The data source logic now checks existence and saves if new
        emit(AuthAuthenticated(user));
        // Removed the nested saveUser call as it's handled in the data source
        // final saveResult = await saveUser(user);
        // saveResult.fold(
        //   (failure) {
        //     emit(AuthError(failure.message));
        //   },
        //   (_) {
        //     emit(AuthAuthenticated(user));
        //   },
        // );
      },
    );
  }

  // Optional: Add handler to check initial auth state on app start
  // Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
  //   // Logic to check Firebase Auth state, fetch user data if logged in
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     // Fetch user details from Firestore
  //     // emit(AuthAuthenticated(userEntity));
  //   } else {
  //     emit(AuthInitial());
  //   }
  // }
}

