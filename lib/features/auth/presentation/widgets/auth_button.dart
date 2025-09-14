import 'package:finance_tracker/core/theme/global_colors.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key, 
    required this.onPressed, 
    this.text, 
    this.child, this.color, 
    this.radius
  });
  final VoidCallback onPressed;
  final String? text;
  final Widget? child;
  final Color? color;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? GlobalColors.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 25.0)),
        minimumSize: const Size.fromHeight(50), // Make button full width
      ),
      onPressed: onPressed,
      child: child ?? Text(text!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white))
    );
  }
}