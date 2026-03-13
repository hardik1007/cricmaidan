import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';
import '../domain/auth_state.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  late final StreamSubscription<User?> _authSub;

  AuthNotifier(this._repo) : super(const AuthState.initial()) {
    // Listen to Firebase auth state — drives GoRouter redirect automatically
    _authSub = _repo.authStateChanges.listen(
      (user) {
        if (user != null) {
          state = AuthState.authenticated(user: user);
        } else {
          state = const AuthState.unauthenticated();
        }
      },
      onError: (e) {
        state = AuthState.error(message: e.toString());
      },
    );
  }

  // ── Email Sign-In ─────────────────────────────────────────────────────────
  Future<void> signInWithEmail(String email, String password) async {
    state = const AuthState.loading();
    try {
      await _repo.signInWithEmail(email: email, password: password);
      // authStateChanges stream updates state automatically
    } catch (e) {
      state = AuthState.error(message: _repo.friendlyAuthError(e));
    }
  }

  // ── Email Sign-Up ─────────────────────────────────────────────────────────
  Future<void> signUpWithEmail(
    String email,
    String password, {
    String? displayName,
  }) async {
    state = const AuthState.loading();
    try {
      await _repo.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
    } catch (e) {
      state = AuthState.error(message: _repo.friendlyAuthError(e));
    }
  }

  // ── Google Sign-In ────────────────────────────────────────────────────────
  Future<void> signInWithGoogle() async {
    state = const AuthState.loading();
    try {
      await _repo.signInWithGoogle();
    } catch (e) {
      state = AuthState.error(message: _repo.friendlyAuthError(e));
    }
  }

  // ── Sign Out ──────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    await _repo.signOut();
  }

  // ── Password Reset ────────────────────────────────────────────────────────
  Future<void> sendPasswordReset(String email) async {
    try {
      await _repo.sendPasswordResetEmail(email);
    } catch (e) {
      state = AuthState.error(message: _repo.friendlyAuthError(e));
    }
  }

  void clearError() {
    state = const AuthState.unauthenticated();
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }
}
