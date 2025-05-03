import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:samir_academy/core/error/failures.dart';
import '../../models/user_model.dart'; // Assuming UserModel exists

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<void> saveUser(UserModel user);
  Future<void> deleteUser();
  Future<UserModel?> getCurrentUser(); // Added method to get current user
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        // User is logged in, fetch their data from Firestore
        final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (userDoc.exists) {
          return UserModel.fromFirestore(userDoc);
        } else {
          // User exists in Auth but not Firestore? This shouldn't happen with current logic
          // but handle defensively. Maybe sign them out or create Firestore entry.
          print('Warning: User ${firebaseUser.uid} exists in Firebase Auth but not Firestore.');
          // Optionally sign out the inconsistent user
          // await signOut();
          return null;
        }
      } else {
        // No user logged in
        return null;
      }
    } catch (e) {
      print('Error getting current user: ${e.toString()}');
      // Don't throw, just return null if check fails
      return null;
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut(); // Ensure clean state
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
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
        throw const AuthFailure('Failed to sign in with Google.');
      }
      final userDocRef = _firestore.collection('users').doc(firebaseUser.uid);
      final userDoc = await userDocRef.get();
      if (!userDoc.exists) {
        final newUser = UserModel(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'No Name',
          email: firebaseUser.email ?? 'No Email',
          isAdmin: false,
        );
        await saveUser(newUser);
        return newUser;
      } else {
        return UserModel.fromFirestore(userDoc);
      }
    } on FirebaseAuthException catch (e) {
      throw AuthFailure('Firebase Sign-In failed: ${e.message} (${e.code})');
    } catch (e) {
      throw AuthFailure('Google Sign-In failed: ${e.toString()}');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
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
      print('Error during sign out: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      final User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        final String uid = currentUser.uid;
        await currentUser.delete();
        await _firestore.collection('users').doc(uid).delete();
        await _googleSignIn.signOut();
      } else {
        throw const AuthFailure('No user currently signed in to delete.');
      }
    } on FirebaseAuthException catch (e) {
      throw AuthFailure('Failed to delete Firebase user: ${e.message} (${e.code})');
    } catch (e) {
      throw AuthFailure('Failed to delete user: ${e.toString()}');
    }
  }
}

