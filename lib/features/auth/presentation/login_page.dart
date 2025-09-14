import 'package:finance_tracker/core/theme/global_colors.dart';
import 'package:finance_tracker/core/utils/validators.dart';
import 'package:finance_tracker/core/widgets/custom_text_field.dart';
import 'package:finance_tracker/features/auth/logic/login_state.dart';
import 'package:finance_tracker/features/auth/logic/provider/login_notifier.dart';
import 'package:finance_tracker/features/auth/presentation/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, required this.from});
  final String? from;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isChecked = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginNotifierProvider);
    final provider = ref.watch(loginNotifierProvider.notifier);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Image.asset('assets/imgs/login-sticker.png', height: 400,),
              CustomTextField(
                controller: _emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Validators.validateEmail(value),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: 'Password',
                showSuffix: true,
                controller: _passwordController,
                label: 'Password',
                obscure: true,
                validator: (value) => Validators.validatePassword(value),
              ),
              CheckboxListTile(
                checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
                title: Text('Remember me', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                activeColor: GlobalColors.primaryColor,
                checkColor: Colors.white,
                value: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value!;
                  });
                }
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: AuthButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      provider.signIn(_emailController.text, _passwordController.text).then((_) {
                        ref.watch(loginNotifierProvider).maybeWhen(
                          authenticated: (_) {
                            if (widget.from != null) {
                              context.go(widget.from!);
                            } else {
                              context.go('/');
                            }
                          },
                          error: (message) {
                            debugPrint('Error logging in: $message');
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Login Failed'),
                                content: Text(message),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('OK'),
                                  )
                                ],
                              ),
                            );
                          },
                          orElse: () => debugPrint('Or ELSE')
                        );
                      });
                    }
                    // if (isAuthed!) {
                    //   if (widget.from != null) {
                    //     context.go(widget.from!);
                    //   } else {
                    //     context.go('/');
                    //   }
                    // }
                  },
                  text: 'Login',
                  child: state == LoginState.loading() ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Logging in', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 15,
                        width: 15,
                        child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      ),
                    ],
                  ) : null,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have and account?', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => context.go('/sign-up'),
                    child: Text('Sign Up', style: Theme.of(context).textTheme.bodyMedium?.copyWith(decoration: TextDecoration.underline),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}