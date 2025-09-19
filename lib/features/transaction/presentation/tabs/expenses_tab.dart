import 'package:finance_tracker/features/transaction/logic/monthly/monthly_transaction_notifier.dart';
import 'package:finance_tracker/features/transaction/logic/monthly/monthly_transaction_state.dart';
import 'package:finance_tracker/features/transaction/presentation/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../data/models/transaction.dart';

class ExpenseTab extends ConsumerStatefulWidget {
  const ExpenseTab({super.key, required this.month});
  final String month;

  @override
  ConsumerState<ExpenseTab> createState() => _ExpenseTabState();
}

class _ExpenseTabState extends ConsumerState<ExpenseTab> {
  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(monthlyTransactionNotifierProvider);
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    final currentMonth = widget.month;


    final emptyText = Text('No expense transactions for $currentMonth', style: textStyle, textAlign: TextAlign.center,);


    return switch (transactionState) {
      MonthlyTransactionInitial() => Center(child: LoadingAnimationWidget.discreteCircle(color: Colors.red, size: 50)),
      MonthlyTransactionLoading() => Center(child: LoadingAnimationWidget.discreteCircle(color: Colors.red, size: 50)),
      MonthlyTransactionLoaded() when (transactionState.transactions.where((t) => t.type == TransactionType.expense).toList().isEmpty) => Center(child: emptyText),
      MonthlyTransactionLoaded() => Builder(
        builder: (context) {
          final expenseTransactions = transactionState.transactions.where((type) => type.type == TransactionType.expense).toList();

          debugPrint('Expense Txns: $expenseTransactions');

          return ListView.separated(
            itemCount: expenseTransactions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final transaction = expenseTransactions[index];
              return TransactionItem(
                title: transaction.category.name,
                amount: transaction.amount.toString(),
                isExpense: true
              );
            },
          );
        } 
      ),
      MonthlyTransactionError() => Center(child: Text('Error loading expense transactions', style: textStyle)),
      _ => Center(child: Text('No expense transactions found', style: textStyle))
    };

  }
}
