import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';

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
    return TextField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: "Select Currency",
        border: OutlineInputBorder(),
        prefixIcon: _selectedCurrency == null
            ? Icon(Icons.flag_outlined) // default before picking
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  _selectedCurrency!.flag!, // ✅ show emoji flag
                  style: TextStyle(fontSize: 20),
                ),
              ),
        suffixIcon: Icon(Icons.arrow_drop_down),
      ),
      onTap: _pickCurrency,
    );
  }
}
