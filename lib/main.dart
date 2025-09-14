import 'package:finance_tracker/core/routes/router.dart';
import 'package:finance_tracker/core/theme/dark_theme.dart';
import 'package:finance_tracker/core/theme/light_theme.dart';
import 'package:finance_tracker/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ProviderScope(child: const FinanceTracker()));
}

class FinanceTracker extends ConsumerWidget {
  const FinanceTracker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Finance Tracker',
      theme: lightTheme,
      // darkTheme: darkTheme,
    );
  }
}


