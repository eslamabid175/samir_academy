import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:samir_academy/core/error/failures.dart';
import '../../models/user_model.dart'; // Assuming UserModel exists

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  // Future<void> signOut(); // Not implemented in provided snippet
  Future<void> saveUser(UserModel user);
  Future<void> deleteUSer(); // Typo in original, assuming deleteUser
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        throw const AuthFailure('Google sign-in cancelled by user.');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw  AuthFailure('Failed to sign in with Google.');
      }

      // Check if user exists in Firestore, if not, create a new entry
      final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (!userDoc.exists) {
        // Create a new user model if it doesn't exist
        final newUser = UserModel(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'No Name',
          email: firebaseUser.email ?? 'No Email',
          // Initialize other fields as needed
        );
        await saveUser(newUser); // Save the new user to Firestore
        return newUser;
      } else {
        // User exists, return the existing user data
        return UserModel.fromFirestore(userDoc);
      }
    } catch (e) {
      // Log the error e
      throw  AuthFailure('Google Sign-In failed: ${e.toString()}');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toFirestore());
    } catch (e) {
      // Log the error e
      throw  AuthFailure('Failed to save user: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUSer() async { // Keeping original typo for now, but should be deleteUser
    try {
      final User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        // Delete from Firestore
        await _firestore.collection('users').doc(currentUser.uid).delete();
        // Delete from Firebase Auth
        await currentUser.delete();
        // Sign out from Google as well if needed
        await _googleSignIn.signOut();
      } else {
        throw const AuthFailure('No user currently signed in to delete.');
      }
    } catch (e) {
      // Log the error e
      throw  AuthFailure('Failed to delete user: ${e.toString()}');
    }
  }

// Implement signOut if needed
// Future<void> signOut() async {
//   try {
//     await _googleSignIn.signOut();
//     await _firebaseAuth.signOut();
//   } catch (e) {
//     throw ServerException('Sign out failed: ${e.toString()}');
//   }
// }
}

