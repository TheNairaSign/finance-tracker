import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/google_auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../sign_up_state.dart';

class SignUpNotifier extends StateNotifier<SignUpState> {
  final AuthRepository _authRepository;
  final GoogleAuthRepository _googleAuthRepository;
  final UserRepository _userRepository;

  SignUpNotifier(this._authRepository, this._googleAuthRepository, this._userRepository)
      : super(SignUpState.initial());

  Future<void> signUp(String email, String password, {required String displayName}) async {
    state = SignUpState.loading();
    try {
      final user = await _authRepository.createUserWithEmailAndPassword(
        email,
        password,
        displayName: displayName,
      );

      if (user != null) {
        state = SignUpState.authenticated(user.uid);
      } else {
        state = SignUpState.unauthenticated();
      }
    } catch (e) {
      state = SignUpState.error(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    state = SignUpState.loading();
    try {
      final userCredential = await _googleAuthRepository.signInWithGoogle();
      final user = userCredential?.user;

      if (user != null) {
        final userModel = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? '',
          photoURL: user.photoURL,
          balance: 0,
          budget: 0.0,
          createdAt: user.metadata.creationTime ?? DateTime.now(),
          lastSignIn: user.metadata.lastSignInTime ?? DateTime.now(),
        );
        await _userRepository.saveUser(userModel);

        state = SignUpState.authenticated(user.uid);
      } else {
        state = SignUpState.unauthenticated();
      }
    } catch (e) {
      state = SignUpState.error(e.toString());
    }
  }
}

final signUpNotifierProvider = StateNotifierProvider<SignUpNotifier, SignUpState>((ref) {
  return SignUpNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(googleAuthRepositoryProvider),
    ref.watch(userRepositoryProvider),
  );
});
