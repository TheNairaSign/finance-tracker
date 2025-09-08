import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/utils/auth_exception.dart';

class GoogleAuthRepository {

  GoogleAuthRepository({
    GoogleSignIn? googleSignIn,
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<void> _initialize() async {
    return await _googleSignIn.initialize(
      clientId: '440038229820-s06b03j0t11pakef9lvehni2mbkbbrrd.apps.googleusercontent.com'
    );
  }

  Future<GoogleSignInAccount?> get _authenticate async {
    await _initialize().then((_) async {
      return await _googleSignIn.authenticate(
        scopeHint: [
          'email',
          'profile',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    await _initialize();

    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.attemptLightweightAuthentication();

      googleUser ??= await _authenticate;

      if (googleUser == null) {
        throw AuthException('Failed to sign in with Google');
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw AuthException('Failed to get authentication tokens');
      }

      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      final user = await _firebaseAuth.signInWithCredential(credential);
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw AuthException('Account exists with different credentials');
        case 'invalid-credential':
          throw AuthException('Invalid credentials provided');
        default:
          throw AuthException('Authentication failed: ${e.message}');
      }
    } catch (e) {
      throw AuthException('Error during Google Sign-In: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('Error during Google Sign-Out: $e');
    }
  }
}


final googleAuthRepositoryProvider = Provider<GoogleAuthRepository>((ref) {
  return GoogleAuthRepository();
});
