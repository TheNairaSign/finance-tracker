import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:finance_tracker/core/widgets/shimmer_placeholder_container.dart';
import 'package:finance_tracker/features/transaction/presentation/utils/add_transaction_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/data/repositories/user_repository.dart';

class NavigationMainShell extends ConsumerStatefulWidget {
  const NavigationMainShell({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<NavigationMainShell> createState() => _NavigationMainShellState();
}

class _NavigationMainShellState extends ConsumerState<NavigationMainShell> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(getUserDataProvider);
    debugPrint('User in dashboard: $user');
    return Scaffold(
      appBar: _currentIndex != 0 ? null: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(7),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            clipBehavior: Clip.hardEdge,
            child: CachedNetworkImage(
              imageUrl: user.when(
                data: (data) => data?.photoURL ?? '',
                error: (error, stackTrace) => '',
                loading: () => '',
              ),
              width: 30,
              height: 30,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => const Icon(Icons.account_circle),
              placeholder: (_, __) => ShimmerImagePlaceholder(width: 30, height: 30, shape: BoxShape.circle),
            ),
          ),
        ),
        forceMaterialTransparency: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome', style: Theme.of(context).textTheme.bodyMedium),
            user.when(
              data: (data) => Text(data?.displayName ?? 'John Doe', style: Theme.of(context).textTheme.titleLarge),
              error: (error, stackTrace) => Text('Error: $error'),
              loading: () => CardLoading(
                height: 20,
                width: 50,
                borderRadius: BorderRadius.circular(10),
              )
            )
          ],
        ),
      ),
      body: Padding(
        padding: _currentIndex != 0 ? EdgeInsetsGeometry.zero : const EdgeInsets.all(15.0),
        child: widget.child,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        currentIndex: _currentIndex,
        selectedIconTheme: IconThemeData(color: Colors.black),
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        onTap: (idx) => _onItemTapped(idx, context),
      ),
      floatingActionButton: _currentIndex != 0 ? null : FloatingActionButton(
        onPressed: () => showAddTransactionModal(context),
        backgroundColor: Color(0xFFb1ff85),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        setState(() => _currentIndex = 0);
        break;
      case 1:
        GoRouter.of(context).go('/transactions');
        setState(() => _currentIndex = 1);
        break;
      case 2:
        GoRouter.of(context).go('/profile');
        setState(() => _currentIndex = 2);
        break;
    }
  }

}