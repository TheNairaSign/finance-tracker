import 'package:finance_tracker/core/utils/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextFieldModel {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final bool obscure, showSuffix;

  const TextFieldModel({
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    required this.validator,
    this.obscure = false,
    this.showSuffix = false,
  });

  static List<TextFieldModel> signUpFields(WidgetRef ref) {

    final displayNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();


    List<TextFieldModel> fieldModels = [];

    fieldModels.add(TextFieldModel(
      controller: displayNameController,
      hintText: 'Display Name',
      validator: (value) => Validators.validateName(value),
    ));
    fieldModels.add(TextFieldModel(
      controller: emailController,
      hintText: 'Email',
      validator: (value) => Validators.validateEmail(value),
    ));
    fieldModels.add(TextFieldModel(
      controller: passwordController,
      hintText: 'Password',
      validator: (value) => Validators.validatePassword(value),
      obscure: true,
      showSuffix: true,
    ));
    fieldModels.add(TextFieldModel(
      controller: confirmPasswordController,
      hintText: 'Confirm Password',
      validator: (value) => Validators.validateConfirmPassword(value, passwordController.text),
      obscure: true,
      showSuffix: true
    ));

    return fieldModels;
  }
}