import 'package:finance_tracker/core/widgets/custom_text_field.dart';
import 'package:finance_tracker/features/auth/presentation/widgets/auth_button.dart';
import 'package:finance_tracker/features/transaction/logic/transaction_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/features/transaction/data/models/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddTransactionPage extends ConsumerStatefulWidget {

  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _category = "Food";
  TransactionType _type = TransactionType.expense;
  DateTime _selectedDate = DateTime.now();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final txn = Transaction(
        userId: userId!,
        amount: double.parse(_amountController.text),
        category: _category,
        date: _selectedDate,
        type: _type,
        note: _noteController.text,
      );
      ref.read(transactionNotifierProvider.notifier).addTransaction(txn);
      debugPrint('Add transaction: $txn');
      Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Row(
            children: [
              GestureDetector(onTap: () => context.pop(), child: Icon(Icons.close)),
              const SizedBox(width: 30),
              Text('Add Transaction', style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _amountController,
            hintText: 'Amount',
            keyboardType: TextInputType.number,
            validator: (v) => v == null || v.isEmpty ? "Enter amount" : null,
          ),
          DropdownButtonFormField<String>(
            initialValue: _category,
            items: ["Food", "Transport", "Rent", "Shopping", "Other"]
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (val) => setState(() => _category = val!),
            decoration: const InputDecoration(labelText: "Category"),
          ),
          DropdownButtonFormField<TransactionType>(
            style: Theme.of(context).textTheme.bodyMedium,
            initialValue: _type,
            items: TransactionType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
            onChanged: (val) => setState(() => _type = val!),
            decoration: const InputDecoration(labelText: "Type"),
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _noteController,
            hintText: "Note (optional)",
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text("Date: ${_selectedDate.toLocal()}".split(' ')[0]),
              TextButton(
                onPressed: _pickDate,
                child: const Text("Pick Date"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AuthButton(onPressed: () => _submit(), text: 'Add Transaction')
        ],
      ),
    );
  }
}
