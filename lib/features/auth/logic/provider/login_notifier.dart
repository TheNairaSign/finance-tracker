import 'package:finance_tracker/features/auth/data/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository.dart';
import '../login_state.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  LoginNotifier(this._authRepository, this._userRepository) : super(LoginState.initial());

  void authChanges() {
    _authRepository.authStateChanges.listen((user) async {
      if (user == null) {
        state = LoginState.unauthenticated();
      } else {
        await _userRepository.updateLastLogin(user.uid, user.metadata.lastSignInTime ?? DateTime.now());
        state = LoginState.authenticated(user.uid);
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    state = LoginState.loading();
    try {
      final user = await _authRepository.signInWithEmailAndPassword(email, password);

      if (user != null) {
        state = LoginState.authenticated(user.uid);
      } else {
        state = LoginState.unauthenticated();
      }
    } on FirebaseAuthException catch(e) {
      print('Login Error: $e');
      final message = interpretFirebaseAuthError(e);
      state = LoginState.error(message);
    }
  }

  String interpretFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return "The email address is badly formatted.";
      case 'user-disabled':
        return "This account has been disabled. Please contact support.";
      case 'user-not-found':
        return "No user found with this email.";
      case 'wrong-password':
        return "Incorrect password. Please try again.";
      case 'email-already-in-use':
        return "This email is already registered.";
      case 'operation-not-allowed':
        return "This sign-in method is not enabled.";
      case 'weak-password':
        return "Your password is too weak. Try a stronger one.";
      case 'network-request-failed':
        return "Network error. Please check your internet connection.";
      case 'too-many-requests':
        return "Too many attempts. Please try again later.";
      default:
        return "An unknown error occurred. Code: ${e.code}";
    }
  }

}

final loginNotifierProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) => LoginNotifier(ref.watch(authRepositoryProvider), ref.watch(userRepositoryProvider)));
