import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_app/domain/auth/auth_failure.dart';
import 'package:mobile_app/domain/auth/auth_repository.dart';
import 'package:mobile_app/domain/auth/auth_session.dart';
import 'package:mobile_app/features/auth/application/auth_controller.dart';
import 'package:mobile_app/features/auth/application/auth_providers.dart';

void main() {
  test('sign in stores an authenticated session in state', () async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
      ],
    );
    addTearDown(container.dispose);

    final success = await container
        .read(authControllerProvider.notifier)
        .signIn(
          username: 'operador@combustibles.mx',
          password: 'FullTank123!',
          rememberMe: true,
        );

    expect(success, isTrue);
    expect(
      container.read(authControllerProvider).status,
      AuthStatus.authenticated,
    );
    expect(
      container.read(authControllerProvider).session?.username,
      'operador@combustibles.mx',
    );
  });

  test('invalid credentials expose a user-facing failure', () async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(_FakeAuthRepository(fails: true)),
      ],
    );
    addTearDown(container.dispose);

    final success = await container
        .read(authControllerProvider.notifier)
        .signIn(
          username: 'operador@combustibles.mx',
          password: 'bad',
          rememberMe: false,
        );

    expect(success, isFalse);
    expect(
      container.read(authControllerProvider).failure?.type,
      AuthFailureType.invalidCredentials,
    );
  });
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.fails = false});

  final bool fails;

  @override
  Future<AuthSession> signIn(
    String username,
    String password, {
    required bool rememberMe,
  }) async {
    if (fails) throw AuthFailure.invalidCredentials();
    return const AuthSession(
      userId: 1,
      username: 'operador@combustibles.mx',
      token: 'test-token',
    );
  }

  @override
  Future<AuthSession?> restoreSession() async => null;

  @override
  Future<void> signOut() async {}
}
