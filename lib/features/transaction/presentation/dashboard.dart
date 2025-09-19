import 'package:card_loading/card_loading.dart';
import 'package:finance_tracker/features/auth/data/repositories/user_repository.dart';
import 'package:finance_tracker/features/transaction/logic/monthly/monthly_transaction_notifier.dart';
import 'package:finance_tracker/features/transaction/logic/transaction_notifier.dart';
import 'package:finance_tracker/features/transaction/logic/transaction_state.dart';
import 'package:finance_tracker/features/transaction/presentation/utils/add_transaction_modal.dart';
import 'package:finance_tracker/features/transaction/presentation/widgets/add_transaction_button.dart';
import 'package:finance_tracker/features/transaction/presentation/widgets/progress_card.dart';
import 'package:finance_tracker/features/transaction/presentation/widgets/spending_overview_container.dart';
import 'package:finance_tracker/features/transaction/presentation/widgets/transaction_card.dart';
import 'package:finance_tracker/features/transaction/presentation/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/models/transaction.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    ref.read(transactionNotifierProvider.notifier).getTransactions();
    ref.read(monthlyTransactionNotifierProvider.notifier).getTransactionsForCurrentMonth();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(getUserDataProvider);

    final transactionState = ref.watch(transactionNotifierProvider);

    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF171f32),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text('Available Balance', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('USD', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10))
                  )
                ],
              ),
              const SizedBox(height: 5),
              userState.when(
                data: (user) {
                  return RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(text: '\$', style: GoogleFonts.poppins(fontSize: 40)),
                        TextSpan(text: user?.budget.toString(), style: GoogleFonts.poppins(fontSize: 40))
                      ]
                    )
                  );
                },
                error: (error, stack) {
                  return RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(text: '\$', style: GoogleFonts.poppins(fontSize: 40)),
                        TextSpan(text: '0', style: GoogleFonts.poppins(fontSize: 40))
                      ]
                    )
                  );
                },
                  loading: () => CardLoading(
                    height: 20,
                    width: 50,
                    borderRadius: BorderRadius.circular(10),
                ),
              )
            ]
          ),
        ),
        /*
        const SizedBox(height: 10),
        Row(
          children: [
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodySmall,
                children: [
                  TextSpan(text: '\$424 '),
                  TextSpan(text: 'of \$920 spent', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey))
                ]
              )
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Color(0xFF2fe58e),
                borderRadius: BorderRadius.circular(20),
              ),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall,
                  children: [
                    TextSpan(text: '+15% '),
                    TextSpan(text: 'than last month', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white))
                  ]
                )
              ),
            )
          ],
        ),
        */
        const SizedBox(height: 15),

        transactionState.maybeWhen(
          loaded: (transactions) {
            final double incomeSum = transactions.where((txn) => txn.type == TransactionType.income).fold(0, (sum, transaction) => sum + transaction.amount);
            final double expenseSum = transactions.where((txn) => txn.type == TransactionType.expense).fold(0, (sum, transaction) => sum + transaction.amount);
            return Row(
              spacing: 15,
              children: [
                Expanded(child: TransactionCard(amount: incomeSum.toString(), type: TransactionType.income)),
                Expanded(child: TransactionCard(amount: expenseSum.toString(), type: TransactionType.expense)),
              ],
            );
          },
          orElse: () => Row(
            spacing: 15,
            children: [
              Expanded(
                child: CardLoading(
                  height: 80,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Expanded(
                child: CardLoading(
                  height: 80,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        transactionState.maybeWhen(
          loaded: (transactions) => SpendingProgressCard(spent: 377, budget: 924),
          orElse: () => CardLoading(
            height: 100,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        const SizedBox(height: 15),
        transactionState.maybeWhen(
          loaded: (transactions) => SpendingOverviewContainer(transactions: transactions.toSet()),
          orElse: () => CardLoading(
            height: 200,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        const SizedBox(height: 15),
        transactionState.maybeWhen(
          loaded: (_) => Row(
            spacing: 15,
            children: [
              Expanded(
                child: AddTransactionButton(
                  onPressed: () => showAddTransactionModal(context),
                  text: 'Add Transaction',
                  asset: 'assets/svgs/add-circle.svg',
                  color: Color(0xff1e67ea),
                ),
              ),
              Expanded(
                child: AddTransactionButton(
                  onPressed: () {},
                  text: 'View Budget',
                  asset: 'assets/svgs/target.svg',
                  color: Color(0xff22c45d),
                ),
              ),
            ],
          ),
          orElse: () => Row(
            spacing: 15,
            children: [
              Expanded(
                child: CardLoading(
                  height: 50,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Expanded(
                child: CardLoading(
                  height: 50,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ],
          ),
        )
        // const SizedBox(height: 15),
        // TxnTab(tabController: _tabController),
        // const SizedBox(height: 15),
        // RecentTxns(),
      ],
    );
  }
}

class RecentTxns extends StatelessWidget {
  const RecentTxns({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),

        // Recent Transactions Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8),

        // Transaction List
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return TransactionItem(
              title: 'Transaction ${index + 1}',
              amount: (index % 2 == 0) ? '-\$${(index + 1) * 25}' : '+\$${(index + 1) * 50}',
              isExpense: index % 2 == 0,
            );
          },
        ),
      ],
    );
  }
}


