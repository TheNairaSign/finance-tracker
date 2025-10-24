import 'package:finance_tracker/core/theme/global_colors.dart';
import 'package:finance_tracker/core/widgets/custom_text_field.dart';
import 'package:finance_tracker/features/auth/data/models/sign_up_field_model.dart';
import 'package:finance_tracker/features/auth/logic/provider/sign_up_notifier.dart';
import 'package:finance_tracker/features/auth/logic/sign_up_state.dart';
import 'package:finance_tracker/features/auth/presentation/widgets/auth_button.dart';
import 'package:finance_tracker/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  List<TextFieldModel> fieldModels = [];

  bool _isChecked = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fieldModels = TextFieldModel.signUpFields(ref);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpNotifierProvider);
    final provider = ref.watch(signUpNotifierProvider.notifier);

    ref.listen<SignUpState>(signUpNotifierProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (_) {
          context.go('/');
        },
        error: (message) {
          debugPrint('Error signing up: $message');
          if (!mounted) return;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Sign Up Failed'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                )
              ],
            ),
          );
        },
        orElse: () {},
      );
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Create Account',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Column(
                children: List.generate(fieldModels.length, (index) {
                  final field = fieldModels[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: CustomTextField(
                      controller: field.controller,
                      keyboardType: field.keyboardType,
                      validator: field.validator,
                      hintText: field.hintText,
                      obscure: field.obscure,
                      showSuffix: field.showSuffix,
                    ),
                  );
                }),
              ),
              CheckboxListTile(
                checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                title: Text('I agree with terms of use', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                activeColor: GlobalColors.primaryColor,
                value: _isChecked,
                checkColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value!;
                  });
                }
              ),
              // const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: AuthButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      provider.signUp(
                        fieldModels[1].controller.text,
                        fieldModels[2].controller.text,
                        displayName: fieldModels[0].controller.text,
                      );
                    }
                  },
                  text: 'Sign up',
                  child: state == SignUpState.loading() ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Registering', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
                      const SizedBox(width: 10),
                      const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      ),
                    ],
                  ) : null,
                )
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Expanded(
                    child: Divider(
                      endIndent: 10,
                      indent: 10,
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  Text('OR'),
                  Expanded(
                    child: Divider(
                      indent: 10,
                      endIndent: 10,
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GoogleSignInButton(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text('Sign In', style: Theme.of(context).textTheme.bodyMedium?.copyWith(decoration: TextDecoration.underline),
                    ),
                  )
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}