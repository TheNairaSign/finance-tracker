import 'dart:async';

import 'package:finance_tracker/core/utils/build_page.dart';
import 'package:finance_tracker/features/transaction/presentation/transactions_page.dart';
import 'package:finance_tracker/pages/profile/sub_pages/help_support_page.dart';
import 'package:finance_tracker/pages/profile/sub_pages/legal_page.dart';
import 'package:finance_tracker/pages/profile/sub_pages/notification_page.dart';
import 'package:finance_tracker/pages/profile/sub_pages/personal_info_page.dart';
import 'package:finance_tracker/pages/profile/sub_pages/security_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/logic/utils/router_utils.dart';
import '../../features/auth/presentation/loading_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/sign_up_page.dart';
import '../../features/transaction/presentation/dashboard.dart';
import '../../features/transaction/presentation/navigation_main_shell.dart';
import '../../pages/profile/profile_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  print('Entering Router...');
  final authRepository = AuthRepository();
  print('Entering Router again...');

  return GoRouter(
    initialLocation: '/loading',
    redirect: redirectLogic(ref),
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges),
    routes: <RouteBase>[
      _navigationShell,
      GoRoute(
        path: '/login',
        builder: (context, state) {
          final from = state.uri.queryParameters['from'];
          return LoginPage(from: from);
        },
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingPage(),
      ),
    ],
  );
});

FutureOr<String?> Function(BuildContext, GoRouterState)? redirectLogic(Ref ref) {
  return (context, state) async {
    final authState = await Future.microtask(() => ref.watch(authStateProvider));
    final user = authState.asData?.value;
    final isLoading = authState.isLoading;

    final isLoggingIn = state.matchedLocation == '/login';
    final isSigningUp = state.matchedLocation == '/sign-up';
    final isGoingToPublic = isLoggingIn || isSigningUp;

    // 1. If we are still loading, redirect to the loading screen.
    if (isLoading) {
      return state.matchedLocation == '/loading' ? null : '/loading';
    }

    // 2. If the user is NOT authenticated.
    if (user == null) {
      print('User is null: $user');
      // Allow navigation to login and sign-up pages.
      return isGoingToPublic ? null : '/login';
    }
    // 3. If the user IS authenticated.
    else {
      // Prevent navigation to public pages and redirect to the home page.
      if (isGoingToPublic || state.matchedLocation == '/loading') {
        print('User: $user');
        return '/';
      }
      // Allow navigation to any other page.
      return null;
    }
  };
}

ShellRoute _navigationShell = ShellRoute(
  builder: (context, state, child) => NavigationMainShell(child: child),
  pageBuilder: (context, state, child) => buildPage(NavigationMainShell(child: child), state),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Dashboard(),
    ),
    GoRoute(
      path: '/transactions',
      builder: (context, state) => const TransactionsPage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
      routes: [
        authRoute(
          path: '/profile/settings',
          builder: (context, state) => const PersonalInfoPage(),
        ),
        authRoute(
          path: '/profile/security',
          builder: (context, state) => const SecurityPage(),
        ),
        authRoute(
          path: '/profile/notifications',
          builder: (context, state) =>  CircularProgressExample(),
        ),
        authRoute(
          path: '/profile/support',
          builder: (context, state) => const HelpSupportPage(),
        ),
        authRoute(
          path: '/profile/legal',
          builder: (context, state) => const LegalPage(),
        ),
      ]
    ),
  ],
);

GoRoute authRoute({
  required String path,
  required Widget Function(BuildContext, GoRouterState) builder,
}) {
  return GoRoute(
    path: path,
    builder: builder,
    name: 'protected:$path', // ✅ mark as protected
  );
}
