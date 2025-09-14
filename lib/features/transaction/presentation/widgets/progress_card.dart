import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SpendingProgressCard extends StatelessWidget {
  final double spent;
  final double budget;

  const SpendingProgressCard({
    super.key,
    required this.spent,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (spent / budget).clamp(0.0, 1.0);
    final remaining = budget - spent;
    final isApproachingTarget = percentage >= 0.8;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withValues(alpha: 0.5),
        //     spreadRadius: -1,
        //     blurRadius: 5,
        //     offset: Offset(0, 2),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/svgs/trophy.svg', height: 13),
                  SizedBox(width: 8),
                  Text(
                    "Monthly Spending",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                "\$${spent.toStringAsFixed(0)} / \$${budget.toStringAsFixed(0)}",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress bar
          Stack(
            children: [
              Container(
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Container(
                height: 15,
                width: MediaQuery.of(context).size.width * 0.7 * percentage,
                decoration: BoxDecoration(
                  color: isApproachingTarget ? Color(0xfffe4737) : Color(0xfffee4ac),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('\$${spent.toStringAsFixed(0)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10), textAlign: TextAlign.end),
                    SizedBox(width: 5),
                  ],
                )
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Footer text
          Text(
            "${(percentage * 100).toStringAsFixed(0)}% spent • \$${remaining.toStringAsFixed(0)} left",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: remaining < 0 ? Colors.red : Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
