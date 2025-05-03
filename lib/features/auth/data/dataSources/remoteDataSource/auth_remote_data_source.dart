import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:samir_academy/core/error/failures.dart';
import '../../models/user_model.dart'; // Assuming UserModel exists

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<void> signOut(); // Added signOut method
  Future<void> saveUser(UserModel user);
  Future<void> deleteUser(); // Corrected typo from deleteUSer
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // Ensure user is signed out from Google before attempting a new sign-in
      // This can help prevent issues if the previous session wasn't fully cleared.
      await _googleSignIn.signOut();

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

      // Sign in to Firebase
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw const AuthFailure('Failed to sign in with Google.');
      }

      // Check if user exists in Firestore, if not, create a new entry
      final userDocRef = _firestore.collection('users').doc(firebaseUser.uid);
      final userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        // Create a new user model if it doesn't exist
        final newUser = UserModel(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'No Name',
          email: firebaseUser.email ?? 'No Email',
          isAdmin: false, // Default isAdmin to false for new users
          // Initialize other fields as needed
        );
        await saveUser(newUser); // Save the new user to Firestore
        return newUser;
      } else {
        // User exists, fetch and return the existing user data
        // Ensure isAdmin is fetched correctly
        return UserModel.fromFirestore(userDoc);
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase auth errors
      throw AuthFailure('Firebase Sign-In failed: ${e.message} (${e.code})');
    } catch (e) {
      // Handle other errors like network issues or Google Sign-In errors
      throw AuthFailure('Google Sign-In failed: ${e.toString()}');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      // Use merge: true to avoid overwriting fields like isAdmin if not included in the model update
      await _firestore.collection('users').doc(user.id).set(user.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      throw AuthFailure('Failed to save user: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      // It's generally safe to ignore sign-out errors, but log them
      print('Error during sign out: ${e.toString()}');
      // Optionally rethrow if sign-out failure needs specific handling
      // throw AuthFailure('Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUser() async { // Corrected method name
    try {
      final User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        final String uid = currentUser.uid; // Store UID before deleting user
        // Delete from Firebase Auth first
        await currentUser.delete();
        // Then delete from Firestore
        await _firestore.collection('users').doc(uid).delete();
        // Sign out from Google as well
        await _googleSignIn.signOut(); // Ensure Google session is cleared
      } else {
        throw const AuthFailure('No user currently signed in to delete.');
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific errors like requires-recent-login
      throw AuthFailure('Failed to delete Firebase user: ${e.message} (${e.code})');
    } catch (e) {
      throw AuthFailure('Failed to delete user: ${e.toString()}');
    }
  }
}

