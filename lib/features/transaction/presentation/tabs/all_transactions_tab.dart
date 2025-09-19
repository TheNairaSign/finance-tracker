import 'package:finance_tracker/features/transaction/data/models/transaction.dart';
import 'package:finance_tracker/features/transaction/logic/monthly/monthly_transaction_notifier.dart';
import 'package:finance_tracker/features/transaction/logic/monthly/monthly_transaction_state.dart';
import 'package:finance_tracker/features/transaction/presentation/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class AllTransactionsTab extends ConsumerStatefulWidget {
  const AllTransactionsTab({super.key});

  @override
  ConsumerState<AllTransactionsTab> createState() => _AllTransactionsTabState();
}

class _AllTransactionsTabState extends ConsumerState<AllTransactionsTab> {
  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(monthlyTransactionNotifierProvider);

    final textStyle = Theme.of(context).textTheme.headlineSmall;

    return switch (transactionState) {
      MonthlyTransactionInitial() => const Center(child: CircularProgressIndicator()),
      MonthlyTransactionLoading() => Center(child: LoadingAnimationWidget.discreteCircle(color: Colors.green, size: 50)),
      MonthlyTransactionLoaded() when (transactionState.transactions.isEmpty) => Center(child: Text('No transactions found', style: textStyle)),
      MonthlyTransactionLoaded() =>  ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: transactionState.transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactionState.transactions[index];
          return TransactionItem(
            title: transaction.category.name,
            amount: transaction.amount.toString(),
            isExpense: transaction.type == TransactionType.expense,
          );
        },
      ),
      MonthlyTransactionError() => Center(child: Text('Error loading transactions', style: textStyle)),
      _ => Center(child: Text('No transactions found', style: textStyle))
    };

  }
}
