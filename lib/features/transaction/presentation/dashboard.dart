import 'package:finance_tracker/features/auth/data/repositories/user_repository.dart';
import 'package:finance_tracker/features/transaction/logic/transaction_notifier.dart';
import 'package:finance_tracker/features/transaction/presentation/tabs/all_transactions_tab.dart';
import 'package:finance_tracker/features/transaction/presentation/tabs/expenses_tab.dart';
import 'package:finance_tracker/features/transaction/presentation/tabs/income_tab.dart';
import 'package:finance_tracker/features/transaction/presentation/widgets/pie_chart.dart';
import 'package:finance_tracker/features/transaction/presentation/widgets/transaction_item.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    ref.read(transactionNotifierProvider.notifier).getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(getUserDataProvider);

    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFFb1ff85),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text('Your Budget', style: Theme.of(context).textTheme.bodyLarge?.copyWith()),
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
                  loading: () => CircularProgressIndicator(color: Colors.white),
              )
            ]
          ),
        ),
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
        const SizedBox(height: 20),
      /*
        LinearProgressIndicator(
          value: 424 / 920,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        */

        Container(
          color: Colors.white,
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                indicatorColor: Color(0xFFb1ff85),
                labelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                unselectedLabelColor: Colors.grey,
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'Income'),
                  Tab(text: 'Expenses'),
                ],
              ),
              SizedBox(
                height: 200,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    AllTransactionsTab(),
                    IncomeTab(),
                    ExpenseTab(),
                  ],
                ),
              ),
            ],
          ),
        ),

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
