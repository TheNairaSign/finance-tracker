// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.showSuffix = false,
    this.obscure = false,
    this.height,
    this.label,
    this.keyboardType,
    this.backgroundColor,
    this.enabledBorder,
    this.enabled = true,
    this.suffixIcon,
    this.initialValue,
    this.onChanged,
    this.validator
  });
  final TextEditingController? controller; 
  final String? hintText, initialValue, label;
  final Widget? prefixIcon, suffixIcon;
  final bool showSuffix;
  final double? height;
  bool obscure, enabled;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Color? backgroundColor;
  final BorderSide? enabledBorder;
  final String? Function(String?)? validator;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      obscureText: widget.obscure,
      obscuringCharacter: '*',
      keyboardType: widget.keyboardType ?? TextInputType.name,
      initialValue: widget.controller == null ? widget.initialValue : null,
      cursorColor: Colors.black,
      onChanged: widget.onChanged,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        // hintText: widget.hintText,
        labelText: widget.hintText,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        // label: Text(widget.label ?? '',),
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon ?? (widget.showSuffix ? GestureDetector(
          onTap: () {
            setState(() {
              widget.obscure = !widget.obscure;
            });
          },
        child: Icon(widget.obscure? Icons.visibility_off : Icons.visibility, size: 20)) : null),
        // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: widget.enabledBorder ?? BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: .5), borderRadius: BorderRadius.circular(10)),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color.fromARGB(255, 242, 147, 141), width: .5)),
        enabled: widget.enabled,
        errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1), borderRadius: BorderRadius.circular(10)),
        fillColor: widget.backgroundColor ?? (const Color(0xfff5f5f5)),
        filled: true,
      ),
    );
  }
}
