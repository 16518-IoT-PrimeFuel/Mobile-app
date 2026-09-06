import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile_app/domain/auth/auth_failure.dart';
import 'package:mobile_app/domain/auth/auth_repository.dart';
import 'package:mobile_app/domain/auth/auth_session.dart';
import 'package:mobile_app/features/auth/application/auth_providers.dart';
import 'package:mobile_app/features/auth/presentation/login_page.dart';

void main() {
  testWidgets('renders the default login state', (tester) async {
    await tester.pumpWidget(_TestApp(repository: _FakeRepository()));

    expect(find.text('Bienvenido de vuelta'), findsOneWidget);
    expect(find.text('EMAIL CORPORATIVO'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });

  testWidgets('shows inline validation for empty fields', (tester) async {
    await tester.pumpWidget(_TestApp(repository: _FakeRepository()));
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pump();

    expect(find.text('Ingresa tu email corporativo'), findsOneWidget);
    expect(find.text('Este campo es obligatorio'), findsOneWidget);
  });

  testWidgets('shows loading while credentials are verified', (tester) async {
    final pending = Completer<AuthSession>();
    await tester.pumpWidget(_TestApp(repository: _FakeRepository(pending: pending)));
    await tester.enterText(find.byType(TextField).at(0), 'operador@combustibles.mx');
    await tester.enterText(find.byType(TextField).at(1), 'FullTank123!');
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pump();

    expect(find.text('Verificando credenciales...'), findsOneWidget);
    pending.complete(const AuthSession(token: 'token', username: 'user'));
    await tester.pump();
  });

  testWidgets('shows incorrect credentials banner', (tester) async {
    await tester.pumpWidget(_TestApp(repository: _FakeRepository(fails: true)));
    await tester.enterText(find.byType(TextField).at(0), 'operador@combustibles.mx');
    await tester.enterText(find.byType(TextField).at(1), 'wrong');
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Email o contraseña incorrectos. Verifica tus credenciales o recupera tu acceso.',
      ),
      findsOneWidget,
    );
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.repository});

  final AuthRepository repository;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const LoginPage(),
            ),
            GoRoute(
              path: '/home',
              builder: (context, state) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _FakeRepository implements AuthRepository {
  _FakeRepository({this.fails = false, this.pending});

  final bool fails;
  final Completer<AuthSession>? pending;

  @override
  Future<AuthSession> signIn(
    String username,
    String password, {
    required bool rememberMe,
  }) async {
    if (pending != null) return pending!.future;
    if (fails) throw AuthFailure.invalidCredentials();
    return const AuthSession(token: 'token', username: 'user');
  }

  @override
  Future<AuthSession?> restoreSession() async => null;

  @override
  Future<void> signOut() async {}
}
