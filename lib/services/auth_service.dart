import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final LocalAuthentication _localAuth = LocalAuthentication();
  String? _displayName;
  String? get currentUserDisplayName => _displayName;

  Future<firebase_auth.User?> signUpWithEmail(String email, String password) async {
    try {
      firebase_auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('Помилка реєстрації: $e');
      rethrow; // Перекидаю просто помилку для обробки в UI
    } catch (e) {
      print('Помилка реєстрації: $e');
      return null;
    }
  }

  Future<firebase_auth.User?> signInWithEmail(String email, String password) async {
    try {
      firebase_auth.UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // додаткові дані користувача
      if (result.user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(result.user!.uid).get();
        if (userDoc.exists) {
          _displayName = userDoc.data()?['displayName'];
        }
      }
      return result.user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('Помилка входу: $e');
      rethrow;
    } catch (e) {
      print('Помилка входу: $e');
      return null;
    }
  }

  Future<firebase_auth.User?> signInWithGoogle() async {
    try {
      // спочатку виход, щоб уникнути проблем з кешем
      await _googleSignIn.signOut();
      // явний потік для входу
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Користувач скасував вхід через Google');
        return null;
      }
      try {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // Вход в сервер з отриманими даними
        final firebase_auth.UserCredential userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;
      } catch (e) {
        print('Помилка аутентифікації Google: $e');
        return null;
      }
    } catch (e) {
      print('Помилка входу через Google: $e');
      return null;
    }
  }

  String? get currentUserEmail => _auth.currentUser?.email;
  String? get currentUserId => _auth.currentUser?.uid;

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // біометрична аутентифікація!!!!!
  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Автентифікація для доступу до застосунку',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (e) {
      print('Помилка біометричної аутентифікації: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
  firebase_auth.User? get currentUser => _auth.currentUser;
}
