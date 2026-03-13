import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial()                       = AuthStateInitial;
  const factory AuthState.loading()                       = AuthStateLoading;
  const factory AuthState.authenticated({required User user}) = AuthStateAuthenticated;
  const factory AuthState.unauthenticated()               = AuthStateUnauthenticated;
  const factory AuthState.error({required String message}) = AuthStateError;
}
