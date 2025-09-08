import 'package:finance_tracker/features/transaction/logic/transaction_notifier.dart';
import 'package:finance_tracker/features/transaction/logic/transaction_state.dart';
import 'package:finance_tracker/features/transaction/presentation/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/transaction.dart';

class IncomeTab extends ConsumerStatefulWidget {
  const IncomeTab({super.key});

  @override
  ConsumerState<IncomeTab> createState() => _IncomeTabState();
}

class _IncomeTabState extends ConsumerState<IncomeTab> {
  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionNotifierProvider);
    final notifier = ref.read(transactionNotifierProvider.notifier);

    return transactionState.maybeWhen(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error) => Center(child: Text('Error getting income transaction: $error')),
      loaded: (transactions) {
        debugPrint('All transactions: $transactions');
        final incomeTransactions = notifier.filterTransactionsByType(transactions, TransactionType.income);
        debugPrint('Income Txns: $incomeTransactions');

        if (incomeTransactions.isEmpty) {
          return Center(child: Text('No income transactions'));
        }

        return ListView.separated(
          itemCount: transactions.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final transaction = incomeTransactions[index];
            return TransactionItem(
              title: transaction.category,
              amount: transaction.amount.toString(),
              isExpense: false
            );
          },
        );
      },
      orElse: () => const Center(child: CircularProgressIndicator())
    );
  }
}
