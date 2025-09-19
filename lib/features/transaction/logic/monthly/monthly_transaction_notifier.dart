import 'dart:async';

import 'package:finance_tracker/features/transaction/data/models/transaction.dart';
import 'package:finance_tracker/features/transaction/data/repositories/transaction_repository.dart';
import 'package:finance_tracker/features/transaction/logic/monthly/monthly_transaction_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonthlyTransactionNotifier extends StateNotifier<MonthlyTransactionState> {
  final TransactionRepository _repo;
  MonthlyTransactionNotifier(this._repo) : super(MonthlyTransactionInitial());

  StreamSubscription<List<Transaction>>? _subscription;

  Future<void> getTransactionsForCurrentMonth() async {
    // state = MonthlyTransactionLoading();
    try {

      _subscription?.cancel();
      _subscription = _repo.getCurrentMonthTransactions().listen((transactions) {
        state = MonthlyTransactionLoaded(transactions);
      });
    } catch (e) {
      state = MonthlyTransactionError(e.toString());
    }
  }

  Future<void> getTransactionsForSelectedMonth(DateTime selectedDate) async {
    state = MonthlyTransactionLoading();
    try {

      _subscription?.cancel();
      _subscription = _repo.getTransactionsForMonth(selectedDate).listen((transactions) {
        state = MonthlyTransactionLoaded(transactions);
      });
    } catch (e) {
      state = MonthlyTransactionError(e.toString());
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
final monthlyTransactionNotifierProvider = StateNotifierProvider<MonthlyTransactionNotifier, MonthlyTransactionState>((ref) {
  return MonthlyTransactionNotifier(ref.read(transactionRepositoryProvider));
});