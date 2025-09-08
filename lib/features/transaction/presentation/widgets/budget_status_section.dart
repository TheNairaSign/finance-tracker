import 'package:flutter/material.dart';

class BudgetStatusSection extends StatelessWidget {
  final double budgetPercent;

  const BudgetStatusSection({
    Key? key,
    required this.budgetPercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (budgetPercent > 0.8 ? Colors.red : const Color(0xFF11998e))
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    budgetPercent > 0.8 ? Icons.warning : Icons.check_circle,
                    color: budgetPercent > 0.8 ? Colors.red : const Color(0xFF11998e),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Budget Status",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[100],
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: budgetPercent.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      colors: budgetPercent > 0.8
                          ? [const Color(0xFFfd746c), const Color(0xFFff9068)]
                          : [const Color(0xFF11998e), const Color(0xFF38ef7d)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A5568),
                ),
                children: [
                  const TextSpan(text: "You have used "),
                  TextSpan(
                    text: "${(budgetPercent * 100).toStringAsFixed(0)}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: budgetPercent > 0.8 ? Colors.red : const Color(0xFF11998e),
                    ),
                  ),
                  const TextSpan(text: " of your budget"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
