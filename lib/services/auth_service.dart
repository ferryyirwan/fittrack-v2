import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    await _auth.sendPasswordResetEmail(
      email: email,
    );
  }

  Future<bool> checkEmailExists(String email) async {
    final cleanEmail = email.trim();
    try {
      final queryExact = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: cleanEmail)
          .limit(1)
          .get();
      if (queryExact.docs.isNotEmpty) return true;

      final queryLower = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: cleanEmail.toLowerCase())
          .limit(1)
          .get();
      if (queryLower.docs.isNotEmpty) return true;
    } catch (_) {}

    return false;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}