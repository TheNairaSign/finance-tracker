import 'package:finance_tracker/features/transaction/presentation/add_transaction_page.dart';
import 'package:flutter/material.dart';

void showAddTransactionModal(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (context) {
      return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        curve: Curves.decelerate,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
            minHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: MediaQuery.of(context).viewInsets.bottom > 0 ? 0.8 : 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.95,
            builder: (_, controller) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 24,
                  bottom: 20,
                ),
                child: AddTransactionPage(),
              );
            },
          ),
        ),
      );
    },
  );
}