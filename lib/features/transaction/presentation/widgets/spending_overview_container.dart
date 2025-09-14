import 'package:finance_tracker/features/transaction/data/models/transaction.dart';
import 'package:finance_tracker/features/transaction/data/transaction_category.dart';
import 'package:finance_tracker/features/transaction/logic/transaction_notifier.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpendingOverviewContainer extends ConsumerStatefulWidget {
  const SpendingOverviewContainer({super.key, required this.transactions});
  final Set<Transaction> transactions;

  @override
  ConsumerState<SpendingOverviewContainer> createState() => _SpendingOverviewContainerState();
}

class _SpendingOverviewContainerState extends ConsumerState<SpendingOverviewContainer> {
  
  late List<Transaction> sortedTxns;
  late Map<TransactionCategory, double> categoryAmounts;

  @override
  void initState() {
    super.initState();
    ref.read(transactionNotifierProvider.notifier).getTransactions();

    debugPrint('SpendingOverviewContainer: ${widget.transactions}');
    // Filter out transactions with zero amount
    sortedTxns = widget.transactions.where((transaction) => transaction.amount > 0).toList();
    if (sortedTxns.isEmpty) {
      // If all transactions have zero amount, include them all for display
      sortedTxns = widget.transactions.toList();
    }
    sortedTxns.sort((a, b) => b.amount.compareTo(a.amount));
    
    // Group transactions by category and sum amounts
    categoryAmounts = {};
    for (var transaction in sortedTxns) {
      categoryAmounts[transaction.category] = (categoryAmounts[transaction.category] ?? 0) + transaction.amount;
    }
    
    debugPrint('SpendingOverviewContainer (sorted): ${widget.transactions}, $sortedTxns');
    debugPrint('SpendingOverviewContainer (categories): $categoryAmounts');
  }

  @override
  Widget build(BuildContext context) {
    double total = widget.transactions.fold(0, (sum, transaction) => sum + transaction.amount);
    debugPrint('SpendingOverviewContainer: total = $total');
    debugPrint('SpendingOverviewContainer: sortedTxns = $sortedTxns');
    
    // Create a list of SpendingCategory objects from the categoryAmounts map
    List<SpendingCategory> spendingCategories = categoryAmounts.entries
        .map((entry) => SpendingCategory(category: entry.key, amount: entry.value))
        .toList();
    
    // Sort spending categories by amount (highest first)
    spendingCategories.sort((a, b) => b.amount.compareTo(a.amount));
    
    // Ensure we have a valid total for display
    if (total <= 0 && spendingCategories.isNotEmpty) {
      debugPrint('SpendingOverviewContainer: Correcting total from $total to 0.01 for display purposes');
      total = 0.01; // Small non-zero value for display purposes
    }

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Spending Overview', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          Row(
            children: [
              // Donut Chart
              Container(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: Size(160, 160),
                      painter: DonutChartPainter(spendingCategories, total),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\$${total.toInt()}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 40),
              // Legend
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: spendingCategories.map((category) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 12,
                            decoration: BoxDecoration(
                              color: category.category.color,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              category.category.name,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '\$${category.amount.toInt()}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SpendingCategory {
  final TransactionCategory category;
  final double amount;

  SpendingCategory({required this.category, required this.amount});
}

class DonutChartPainter extends CustomPainter {
  final List<SpendingCategory> categories;
  final double total;

  DonutChartPainter(this.categories, this.total);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final strokeWidth = 25.0;

    double startAngle = -math.pi / 2; // Start from top

    if (categories.isEmpty || total <= 0) {
      // If no categories or total is zero, draw a placeholder circle
      if (categories.isNotEmpty) {
        // Draw placeholder segments for each category with equal distribution
        double sweepAngle = 2 * math.pi / categories.length;
        double currentAngle = startAngle;
        
        for (final category in categories) {
          final paint = Paint()
            ..color = category.category.color.withOpacity(0.3) // Use lighter colors
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round;
            
          canvas.drawArc(
            Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
            currentAngle,
            sweepAngle,
            false,
            paint,
          );
          currentAngle += sweepAngle;
        }
      } else {
        // Draw a grey circle if there are no categories
        final paint = Paint()
          ..color = Colors.grey[300]!
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
          startAngle,
          2 * math.pi, // Full circle
          false,
          paint,
        );
      }
      return;
    }

    for (int i = 0; i < categories.length; i++) {
      final category = categories[i];
      final sweepAngle = (category.amount / total) * 2 * math.pi;

      final paint = Paint()
        ..color = category.category.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}