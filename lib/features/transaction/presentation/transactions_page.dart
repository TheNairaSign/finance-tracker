// ignore_for_file: sized_box_for_whitespace

import 'package:finance_tracker/features/auth/data/repositories/user_repository.dart';
import 'package:finance_tracker/features/transaction/logic/monthly/monthly_transaction_notifier.dart';
import 'package:finance_tracker/features/transaction/logic/transaction_notifier.dart';
import 'package:finance_tracker/features/transaction/presentation/tabs/all_transactions_tab.dart';
import 'package:finance_tracker/features/transaction/presentation/tabs/expenses_tab.dart';
import 'package:finance_tracker/features/transaction/presentation/tabs/income_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    ref.read(transactionNotifierProvider.notifier).getTransactions();
  }

  DateTime currentMonth = DateTime.now();

  /// Function to change the currentMonth by delta months
  void changeMonth(int delta) {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + delta);
    });
  }

  // List of all months
  final List<String> months = [
    'January',
    'February', 
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  // Container to display months
  SizedBox monthsContainer() {
    final currentMonthIndex = currentMonth.month - 1;
    final scrollController = ScrollController();

    // Scroll to current month after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        final screenWidth = MediaQuery.of(context).size.width;
        final itemWidth = 120.0; // Approximate width of each month item
        final offset = (currentMonthIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
        scrollController.animateTo(
          offset.clamp(0.0, scrollController.position.maxScrollExtent),
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });

    return SizedBox(
      height: 40,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: months.length,
        itemBuilder: (context, index) {
          bool isSelected = DateFormat('MMMM').format(currentMonth) == months[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  currentMonth = DateTime(currentMonth.year, index + 1);
                  ref.watch(monthlyTransactionNotifierProvider.notifier).getTransactionsForSelectedMonth(currentMonth);
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white.withValues(alpha: .3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    months[index],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    String formattedMonth = DateFormat('MMMM').format(currentMonth);
    String formattedYear = DateFormat('yyyy').format(currentMonth);
    
    final profileData = ref.watch(getUserDataProvider);
    final user = profileData.value;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 130,
        actionsPadding: EdgeInsets.symmetric(horizontal: 10),
        backgroundColor: Color(0xfffee4ac),
        // title: Text('Transactions'),
        centerTitle: true,
        flexibleSpace: Container(
          padding: EdgeInsets.symmetric(vertical: 60, horizontal: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Transactions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withValues(alpha: .2)
                    ),
                    child: Badge.count(
                      count: 2,
                      child: SvgPicture.asset('assets/svgs/profile/notification.svg', color: Colors.black),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              monthsContainer()
            ],
          ),
        ),
        actions: [
          // Container(
          //   padding: EdgeInsets.all(5),
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: Colors.grey.withValues(alpha: .2)
          //   ),
          //   child: Badge.count(
          //     count: 2,
          //     child: SvgPicture.asset('assets/svgs/profile/notification.svg', color: Colors.white),
          //   ),
          // )
        ],
        bottom: TabBar(
          controller: _tabController,
          // indicatorColor: Color(0xFFb1ff85),
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          unselectedLabelColor: Colors.grey,
          labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium,
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Income'),
            Tab(text: 'Expenses'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            AllTransactionsTab(),
            IncomeTab(),
            ExpenseTab(),
          ],
        ),
      ),
    );
  }
}