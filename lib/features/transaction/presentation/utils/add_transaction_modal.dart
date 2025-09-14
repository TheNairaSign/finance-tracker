import 'package:finance_tracker/core/theme/global_colors.dart';
import 'package:finance_tracker/features/transaction/presentation/add_transaction_page.dart';
import 'package:flutter/material.dart';

void showAddTransactionModal(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: GlobalColors.background,
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (context) {
      return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        curve: Curves.decelerate,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 24,
            bottom: 20,
          ),
          child: AddTransactionPage(),
        ),
      );
    },
  );
}