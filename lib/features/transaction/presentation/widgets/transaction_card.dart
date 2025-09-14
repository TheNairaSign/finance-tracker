import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/models/transaction.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key, required this.amount, required this.type});
  final String amount;
  final TransactionType type;

  @override
  Widget build(BuildContext context) {
    const incomeAsset = 'assets/svgs/coins-stacked.svg';
    const expenseAsset = 'assets/svgs/receipt.svg';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      decoration: BoxDecoration(
        // color: Colors.white,
          color: type == TransactionType.income ? Colors.green.withValues(alpha: .2) : Colors.red.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(color:  type == TransactionType.income ? Colors.green.withValues(alpha: .3) : Colors.red.withValues(alpha: .3), width: .3)
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: type == TransactionType.income ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(type == TransactionType.income ? incomeAsset : expenseAsset),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                type == TransactionType.income ? 'Income' : 'Expense',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '\$$amount',
                style: TextStyle(
                  // color: type == TransactionType.income ? Colors.green : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
