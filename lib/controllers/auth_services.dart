import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email & password
  Future<String> createAccountWithEmail(String email, String password) async {
    try {
      // Membuat akun baru
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan data user ke Firestore
      await _firestore.collection('users').doc(email).set({
        'email': email,
        'created_at': Timestamp.now(),
      });

      return "Account Created";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred";
    }
  }

  // Login dengan email & password
  Future<String> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Login Successful";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred";
    }
  }

  // Logout user
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Cek apakah user sedang login
  Future<bool> isLoggedIn() async {
    final user = _auth.currentUser;
    return user != null;
  }

  // Ambil current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
