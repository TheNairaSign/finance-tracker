import 'dart:async';

import 'package:finance_tracker/features/transaction/data/models/transaction.dart';
import 'package:finance_tracker/features/transaction/data/repositories/transaction_repository.dart';
import 'package:finance_tracker/features/transaction/logic/transaction_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionNotifier extends StateNotifier<TransactionState> {

  final TransactionRepository transactionRepository;
  StreamSubscription<List<Transaction>>? _subscription;

  TransactionNotifier(this.transactionRepository) : super(TransactionState.initial());

  void getTransactions() async {
    print('Getting user transactions');
    // state = TransactionState.loading();

    _subscription?.cancel();

    _subscription = transactionRepository.getTransactions().listen((transactions) {
      print('Transactions from subscription: $transactions');
        state = TransactionState.loaded(transactions);
      },
      onError: (err) => state = TransactionState.error(err.toString())
    );
  }

  List<Transaction> filterTransactionsByType(List<Transaction> transactions, TransactionType type) {
    // state = TransactionState.loading();
    try {
      final filteredTransactions = transactions.where((transaction) => transaction.type == type).toList();
      // state = TransactionState.loaded(filteredTransactions);
      return filteredTransactions;
    } catch (e) {
      state = TransactionState.error(e.toString());
      return [];
    }
  }

  Future<void> addTransaction(Transaction txn) async {
    try {
      await transactionRepository.addTransaction(txn);
      state = TransactionState.loaded([txn]);
    } catch (e) {
      state = TransactionState.error(e.toString());
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

}

final transactionNotifierProvider = StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
  return TransactionNotifier(ref.read(transactionRepositoryProvider));
});