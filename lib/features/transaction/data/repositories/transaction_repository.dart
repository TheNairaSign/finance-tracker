import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:finance_tracker/core/utils/auth_exception.dart';
import 'package:finance_tracker/features/auth/data/repositories/auth_repository.dart';
import 'package:finance_tracker/features/transaction/data/models/transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionRepository {
  final FirebaseFirestore _firestore;

  TransactionRepository({
    FirebaseFirestore? firestore, 
    AuthRepository? authRepository
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final userId = FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _userTransactionCollection => _firestore.collection('users').doc(userId).collection('transactions');

  Stream<List<Transaction>> getTransactions() {
    try {
      final txns = _userTransactionCollection
          .orderBy('date', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => Transaction.fromJson(doc.data()).copyWith(id: doc.id)).toList());
      return txns;
    } on FirebaseException catch (e) {
      throw AuthException(e.message ?? 'Something went wrong while fetching transactions');
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    if (userId == null) throw AuthException('No authenticated user');

    print('userId: $userId');

    try {
      // 1️⃣ Write under user's subcollection
      final docRef = await FirebaseFirestore.instance.collection('users').doc(userId).collection('transactions').add(transaction.toJson());

      print('Document Reference: ${docRef.toString()}');

      // 2️⃣ Also write to global collection with reference back to user
      await _firestore.collection('transactions').doc(docRef.id).set({
        ...transaction.toJson(),
        'userId': userId,        // ensure ownership
        'userTxnPath': docRef.path, // link back to subcollection if needed
      });
    } on FirebaseException catch (e) {
      throw AuthException(e.message ?? 'Something went wrong while adding a transaction');
    } catch (e) {
      throw AuthException('Error adding transaction: ${e.toString()}');
    }
  }


  /// Delete a transaction
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _userTransactionCollection.doc(transactionId).delete();
    } on FirebaseException catch (e) {
      throw AuthException(e.message ?? 'Something went wrong while deleting a transaction');
    }
  }
}


final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository(firestore: FirebaseFirestore.instance, authRepository: AuthRepository());
});

