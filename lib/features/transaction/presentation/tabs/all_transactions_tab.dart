import 'package:finance_tracker/features/transaction/logic/transaction_notifier.dart';
import 'package:finance_tracker/features/transaction/logic/transaction_state.dart';
import 'package:finance_tracker/features/transaction/presentation/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AllTransactionsTab extends ConsumerStatefulWidget {
  const AllTransactionsTab({super.key});

  @override
  ConsumerState<AllTransactionsTab> createState() => _AllTransactionsTabState();
}

class _AllTransactionsTabState extends ConsumerState<AllTransactionsTab> {
  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionNotifierProvider);
    final notifier = ref.read(transactionNotifierProvider.notifier);

    return transactionState.maybeWhen(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error) => Center(child: Text('Error getting income transaction: $error')),
        loaded: (transactions) {
          debugPrint('All transactions: $transactions');

          if (transactions.isEmpty) {
            return Center(child: Text('No transactions'));
          }

          return ListView.separated(
            itemCount: transactions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final transaction = transactions[index];
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
