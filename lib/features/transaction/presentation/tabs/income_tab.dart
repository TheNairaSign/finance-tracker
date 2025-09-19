import 'package:finance_tracker/features/transaction/logic/monthly/monthly_transaction_notifier.dart';
import 'package:finance_tracker/features/transaction/logic/monthly/monthly_transaction_state.dart';
import 'package:finance_tracker/features/transaction/presentation/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../data/models/transaction.dart';

class IncomeTab extends ConsumerStatefulWidget {
  const IncomeTab({super.key, required this.month});
  final String month;

  @override
  ConsumerState<IncomeTab> createState() => _IncomeTabState();
}

class _IncomeTabState extends ConsumerState<IncomeTab> {
  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(monthlyTransactionNotifierProvider);
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    final currentMonth = widget.month;

    final emptyText = Text('No income transactions for $currentMonth', style: textStyle, textAlign: TextAlign.center,);

    return switch (transactionState) {
      MonthlyTransactionInitial() => Center(child: LoadingAnimationWidget.discreteCircle(color: Colors.green, size: 50)),
      MonthlyTransactionLoading() => Center(child: LoadingAnimationWidget.discreteCircle(color: Colors.green, size: 50)),
      MonthlyTransactionLoaded() when (transactionState.transactions.where((t) => t.type == TransactionType.income).toList().isEmpty) => Center(child: emptyText),
      MonthlyTransactionLoaded() => Builder(
        builder: (context) {
          final incomeTransactions = transactionState.transactions.where((type) => type.type == TransactionType.income).toList();

          debugPrint('Income Txns: $incomeTransactions');

          return ListView.separated(
            itemCount: incomeTransactions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final transaction = incomeTransactions[index];
              return TransactionItem(
                title: transaction.category.name,
                amount: transaction.amount.toString(),
                isExpense: false
              );
            },
          );
        } 
      ),
      MonthlyTransactionError() => Center(child: Text('Error loading income transactions for $currentMonth', style: textStyle)),
      _ => Center(child: emptyText)
    };

  }
}
