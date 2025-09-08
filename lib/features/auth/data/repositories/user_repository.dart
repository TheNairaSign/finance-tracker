import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:finance_tracker/features/auth/data/models/user_model.dart';
import 'package:finance_tracker/features/auth/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({FirebaseFirestore? firestore, Ref? ref}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final _userId = FirebaseAuth.instance.currentUser?.uid;

  DocumentReference<Map<String, dynamic>> get _userCollection => _firestore.collection('users').doc(_userId);

  Future<void> saveUser(UserModel user) async {
    final userExists = await _userCollection.get().then((snapshot) => snapshot.exists);
    if (userExists) {
      print('User already exists! No overriding!!!');
      return;
    }
    print('User Model creation with user: ${user.toString()}');
    await _userCollection.set(user.toJson(), SetOptions(merge: true));
  }

  Future<UserModel> getUser() async {
    DocumentSnapshot snapshot = await _userCollection.get();
    if (!snapshot.exists) {
      throw Exception('User not found');
    }

    print('User Model: ${snapshot.data()}');
    return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  void updateBudget(double budget) async {
    _userCollection.update({'budget': budget}).then((_) async => await getUser());
  }

  Future<void> updateLastLogin(String uid, DateTime lastLogin) async {
    await _userCollection.update({'lastLogin': DateTime.now().toIso8601String()});
  }

}

final userStateProvider = Provider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.currentUser;
});

final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository(ref: ref));

final getUserDataProvider = FutureProvider<UserModel?>((ref) async {
  final userRepository = ref.watch(userRepositoryProvider);
  return await userRepository.getUser();
});

