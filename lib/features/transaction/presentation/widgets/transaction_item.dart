import 'package:finance_tracker/core/extensions/capitalize.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final String amount;
  final bool isExpense;

  const TransactionItem({
    super.key,
    required this.title,
    required this.amount,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isExpense ? Colors.red[50] : Colors.green[50],
            shape: BoxShape.circle,
          ),
          child: Icon(
            isExpense ? Icons.arrow_upward : Icons.arrow_downward,
            color: isExpense ? Colors.red : Colors.green,
            size: 20,
          ),
        ),
        title: Text(title.capitalize(), style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Text(isExpense ? 'Expense' : 'Income', style: Theme.of(context).textTheme.bodySmall),
        trailing: Text(
          amount,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isExpense ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}