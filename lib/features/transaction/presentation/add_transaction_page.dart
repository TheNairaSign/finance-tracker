// ignore_for_file: use_build_context_synchronously

import 'package:finance_tracker/core/extensions/capitalize.dart';
import 'package:finance_tracker/core/theme/global_colors.dart';
import 'package:finance_tracker/core/widgets/custom_text_field.dart';
import 'package:finance_tracker/features/auth/presentation/widgets/auth_button.dart';
import 'package:finance_tracker/features/transaction/data/models/transaction.dart';
import 'package:finance_tracker/features/transaction/data/transaction_category.dart';
import 'package:finance_tracker/features/transaction/logic/transaction_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddTransactionPage extends ConsumerStatefulWidget {

  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  TransactionCategory _category = TransactionCategory.other;
  TransactionType _type = TransactionType.expense;
  DateTime _selectedDate = DateTime.now();

  bool _isLoading = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      FocusScope.of(context).unfocus();
      try {
        final userId = FirebaseAuth.instance.currentUser?.uid;
        final txn = Transaction(
          userId: userId!,
          amount: double.parse(_amountController.text),
          category: _category,
          date: _selectedDate,
          type: _type,
          note: _noteController.text,
        );
        await ref.watch(transactionNotifierProvider.notifier).addTransaction(txn);
        debugPrint('Add transaction (page): $txn');
        setState(() {
          _isLoading = false;
        });
        context.pop();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding transaction: ${e.toString()}'))
        );
      }
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
    return PopScope(
      canPop: !_isLoading,
      child: Form(
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
              enabled: _isLoading ? false : true,
              controller: _amountController,
              hintText: 'Amount',
              keyboardType: TextInputType.number,
              fillColor: Colors.white,
              borderColor: _category.color,
              validator: (v) => v == null || v.isEmpty ? "Enter amount" : null,
            ),
            const SizedBox(height: 15),
            ExpansionTile(
              enabled: _isLoading ? false : true,
              backgroundColor: Colors.white,
              iconColor: _category.color,
              collapsedBackgroundColor: _category.color.withValues(alpha: .2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
              title: RichText(
                text: TextSpan(
                  text: 'Category:  ', 
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[900]),
                  children: [
                    TextSpan(text: _category.name, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: _category.color, fontWeight: FontWeight.bold))
                  ]
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: TransactionCategory.values.map((category) {
                      final isSelected = _category == category;
                      return GestureDetector(
                        onTap: () => setState(() => _category = category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? category.color
                                :  GlobalColors(context).textFieldColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            category.name,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<TransactionType>(
                  style: Theme.of(context).textTheme.bodyMedium,
                  value: _type,
                  items: TransactionType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name.capitalize()))).toList(),
                  onChanged: _isLoading ? null : (val) => setState(() => _type = val!),
                  dropdownColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 15),
            CustomTextField(
              enabled: _isLoading ? false : true,
              controller: _noteController,
              hintText: "Note (optional)",
              fillColor: Colors.white,
              borderColor: _category.color,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_month, size: 15),
                const SizedBox(width: 7),
                RichText(
                  text: TextSpan(
                    text: 'Date: ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: _selectedDate.toString().split(' ')[0],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 30,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: _category.color.withValues(alpha: .2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 7)
                    ),
                    onPressed: () => _isLoading ? null : _pickDate(),
                    child: Text(
                      "Pick Date",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: _category.color),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AuthButton(
              onPressed: () => _isLoading? null : _submit(), 
              text: !_isLoading ? 'Add Transaction' : null, 
              color: _category.color, 
              radius: 15,
              child: _isLoading ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Adding Transaction...', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  LoadingAnimationWidget.waveDots(color: Colors.white, size: 20),
                ],
              ) : null,
            )
          ],
        ),
      ),
    );
  }
}
