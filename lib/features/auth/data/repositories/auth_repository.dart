import 'package:finance_tracker/features/auth/data/models/user_model.dart';
import 'package:finance_tracker/features/auth/data/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  final UserRepository _userRepository;

  AuthRepository({FirebaseAuth? firebaseAuth, UserRepository? userRepository})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _userRepository = userRepository ?? UserRepository();

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

    if (userCredential.user != null) {
      await _userRepository.updateLastLogin(
        userCredential.user!.uid,
        userCredential.user!.metadata.lastSignInTime ?? DateTime.now(),
      );
    } 

    return userCredential.user;
  }

  Future<User?> createUserWithEmailAndPassword(String email, String password, {required String displayName}) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    await updateDisplayName(displayName);
    final user = userCredential.user;

    if (user != null) {
      final userModel = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: displayName,
        photoURL: user.photoURL,
        balance: 0,
        budget: 0.0,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
        lastSignIn: user.metadata.lastSignInTime ?? DateTime.now(),
      );
      await _userRepository.saveUser(userModel);
    }
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut(); 
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateDisplayName(String displayName) async {
    await _firebaseAuth.currentUser?.updateDisplayName(displayName);
    await _firebaseAuth.currentUser?.reload();
  }

  Future<void> updatePhotoURL(String photoUrl) async {
    await _firebaseAuth.currentUser?.updatePhotoURL(photoUrl);
    await _firebaseAuth.currentUser?.reload();
  }

}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(userRepository: ref.watch(userRepositoryProvider));
});

final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  // ref.watch(getUserDataProvider);
  return authRepository.authStateChanges;
});

final userProvider = Provider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.currentUser;
});
