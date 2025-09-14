import 'package:flutter/material.dart';

class GlobalColors {
  static const primaryColor = Color(0xffa15eeb);
  static const background = Color(0xfff5f5f5);

  BuildContext context;
  GlobalColors(this.context);

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  Color get containerColor {
    return _isDarkMode ? Colors.grey.withValues(alpha: .5) : Colors.black.withValues(alpha: .5); 
  }

  Color? get textFieldColor {
    return _isDarkMode ? Colors.grey[900] : Color(0xfff8f8f8);
  }
}  