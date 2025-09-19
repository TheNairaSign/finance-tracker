import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';

class CurrencyTextField extends StatefulWidget {
  const CurrencyTextField({super.key});

  @override
  State<CurrencyTextField> createState() => _CurrencyTextFieldState();
}

class _CurrencyTextFieldState extends State<CurrencyTextField> {
  final TextEditingController _controller = TextEditingController();
  Currency? _selectedCurrency;

  void _pickCurrency() {
    showCurrencyPicker(
      context: context,
      showFlag: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      onSelect: (Currency currency) {
        setState(() {
          _selectedCurrency = currency;
          _controller.text = "${currency.symbol} ${currency.code}";
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final conve = CurrencyUtils.currencyToEmoji(_selectedCurrency!);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10)
      ),
      height: 40,
      child: TextField(
        controller: _controller,
        readOnly: true,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: "Select Currency",
          labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          prefixIcon: _selectedCurrency == null
              ? Icon(Icons.flag_outlined) // default before picking
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    conve, // ✅ show emoji flag
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        onTap: _pickCurrency,
      ),
    );
  }
}
