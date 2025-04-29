import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
 // Future<void> signOut();
  Future<void> saveUser(UserModel user);

  Future<void> deleteUSer();
}
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource{
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn=GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Sign in cancelled by user');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null || user.email == null) {
        throw Exception('Failed to get user details');
      }

      // طباعة بيانات اليوزر للتأكد
      print('User Info: UID=${user.uid}, Email=${user.email}, Name=${user.displayName}');

      final userModel = UserModel.fromFirebase(user);
      await saveUser(userModel);
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Exception('Firebase Auth Error: ${e.message}');
    } catch (e, stackTrace) {
      print('SignIn Error: $e');
      print('StackTrace: $stackTrace');
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUSer() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await _googleSignIn.disconnect(); // Disconnect the Google account
        await user.delete();
        await _firestore.collection('users').doc(user.uid).delete();
        print('User deleted successfully');
      } else {
        throw Exception('No user is currently signed in');
      }
    } catch (e) {
      throw Exception('Failed to delete user: ${e.toString()}');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toFirestore(),SetOptions(merge: true),);
      print('User saved successfully: ${user.toFirestore()}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

