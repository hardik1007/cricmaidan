import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/auth_state.dart';
import '../../features/auth/presentation/auth_notifier.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/home/presentation/home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    redirect: (BuildContext context, GoRouterState state) {
      final isInitial        = authState is AuthStateInitial;
      final isLoading        = authState is AuthStateLoading;
      final isAuthenticated  = authState is AuthStateAuthenticated;

      final onSplash   = state.matchedLocation == '/splash';
      final onAuthPage = state.matchedLocation == '/login' ||
                         state.matchedLocation == '/signup';

      if (isInitial || isLoading) return onSplash ? null : '/splash';
      if (isAuthenticated)        return onAuthPage || onSplash ? '/home' : null;
      // unauthenticated
      return onAuthPage ? null : '/login';
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (_, __) => const SignupScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (_, __) => const HomeScreen(),
      ),
    ],
  );
});
