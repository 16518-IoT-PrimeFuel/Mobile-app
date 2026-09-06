import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/auth/auth_failure.dart';
import '../../../domain/auth/auth_repository.dart';
import '../../../domain/auth/auth_session.dart';

enum AuthStatus { signedOut, loading, authenticated, failure }

class AuthState {
  const AuthState({
    this.status = AuthStatus.signedOut,
    this.session,
    this.failure,
  });

  final AuthStatus status;
  final AuthSession? session;
  final AuthFailure? failure;

  AuthState copyWith({
    AuthStatus? status,
    AuthSession? session,
    AuthFailure? failure,
    bool clearSession = false,
    bool clearFailure = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: clearSession ? null : session ?? this.session,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  Future<void> restoreSession() async {
    try {
      final session = await _repository.restoreSession();
      if (session == null) return;
      state = AuthState(
        status: AuthStatus.authenticated,
        session: session,
      );
    } catch (_) {
      await _repository.signOut();
    }
  }

  Future<bool> signIn({
    required String username,
    required String password,
    required bool rememberMe,
  }) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      final session = await _repository.signIn(
        username,
        password,
        rememberMe: rememberMe,
      );
      state = AuthState(
        status: AuthStatus.authenticated,
        session: session,
      );
      return true;
    } on AuthFailure catch (failure) {
      state = AuthState(
        status: AuthStatus.failure,
        failure: failure,
      );
      return false;
    } catch (_) {
      state = AuthState(
        status: AuthStatus.failure,
        failure: AuthFailure.unknown(),
      );
      return false;
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AuthState();
  }
}
