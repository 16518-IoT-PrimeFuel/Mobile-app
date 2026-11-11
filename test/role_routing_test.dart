import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app/app_router.dart';
import 'package:mobile_app/app/role_routing.dart';
import 'package:mobile_app/domain/auth/auth_repository.dart';
import 'package:mobile_app/domain/auth/auth_session.dart';
import 'package:mobile_app/domain/auth/sign_up_request.dart';
import 'package:mobile_app/features/auth/application/auth_providers.dart';
import 'package:mobile_app/features/home/presentation/home_page.dart';

const _buyer = ['ROLE_BUYER'];
const _provider = ['ROLE_PROVIDER'];
const providerOnly = [
  '/provider/orders',
  '/provider/orders/FT-2098',
  '/dispatches',
  '/dispatches/fleet',
  '/dispatches/assign',
];

void main() {
  group('home variant', () {
    testWidgets('ROLE_PROVIDER session sees the provider home', (tester) async {
      final harness = await _pump(tester, roles: _provider);
      harness.router.go('/home');
      await tester.pumpAndSettle();
      expect(_homeRole(tester), HomeRole.provider);
    });

    testWidgets('ROLE_BUYER session sees the requester home', (tester) async {
      final harness = await _pump(tester, roles: _buyer);
      harness.router.go('/home');
      await tester.pumpAndSettle();
      expect(_homeRole(tester), HomeRole.requester);
    });

    testWidgets('a buyer cannot force the provider home with a query', (
      tester,
    ) async {
      final harness = await _pump(tester, roles: _buyer);
      harness.router.go('/home?role=provider');
      await tester.pumpAndSettle();
      expect(_homeRole(tester), HomeRole.requester);
      harness.router.go('/home/provider');
      await tester.pumpAndSettle();
      expect(_homeRole(tester), HomeRole.requester);
    });

    testWidgets('a provider session opens /home/provider as provider', (
      tester,
    ) async {
      final harness = await _pump(tester, roles: _provider);
      harness.router.go('/home/provider');
      await tester.pumpAndSettle();
      expect(_homeRole(tester), HomeRole.provider);
    });

    testWidgets('guest is a requester and may preview the provider home', (
      tester,
    ) async {
      final harness = await _pump(tester, guest: true);
      harness.router.go('/home');
      await tester.pumpAndSettle();
      expect(_homeRole(tester), HomeRole.requester);
      harness.router.go('/home?role=provider');
      await tester.pumpAndSettle();
      expect(_homeRole(tester), HomeRole.provider);
    });
  });

  group('role guards', () {
    testWidgets('a buyer is sent home from provider-only routes', (
      tester,
    ) async {
      final harness = await _pump(tester, roles: _buyer);
      for (final path in providerOnly) {
        harness.router.go(path);
        await tester.pumpAndSettle();
        expect(_location(harness.router), '/home', reason: path);
      }
    });

    testWidgets('a provider is sent home from the buyer-only new order', (
      tester,
    ) async {
      final harness = await _pump(tester, roles: _provider);
      harness.router.go('/orders/new');
      await tester.pumpAndSettle();
      expect(_location(harness.router), '/home');
    });

    testWidgets('a session without roles is rejected by both guards', (
      tester,
    ) async {
      final harness = await _pump(tester, roles: const []);
      harness.router.go('/orders/new');
      await tester.pumpAndSettle();
      expect(_location(harness.router), '/home');
      harness.router.go('/provider/orders');
      await tester.pumpAndSettle();
      expect(_location(harness.router), '/home');
    });

    testWidgets('a buyer keeps access to buyer routes', (tester) async {
      final harness = await _pump(tester, roles: _buyer);
      harness.router.go('/orders/new');
      await tester.pumpAndSettle();
      expect(_location(harness.router), '/orders/new');
    });

    test('allowed roles are not redirected (pure guard)', () {
      const buyer = AuthSession(username: 'b', token: 't', roles: _buyer);
      const provider = AuthSession(username: 'p', token: 't', roles: _provider);
      expect(roleGuardRedirect(buyer, '/orders/new'), isNull);
      expect(roleGuardRedirect(buyer, '/orders/history'), isNull);
      expect(roleGuardRedirect(buyer, '/home'), isNull);
      for (final path in providerOnly) {
        expect(roleGuardRedirect(provider, path), isNull, reason: path);
        expect(roleGuardRedirect(buyer, path), '/home', reason: path);
      }
      expect(roleGuardRedirect(provider, '/orders/new'), '/home');
      expect(roleGuardRedirect(provider, '/providers-list'), isNull);
    });

    test('guest and signed-out sessions are never redirected by role', () {
      const guest = AuthSession(username: 'Invitado', token: 'guest');
      for (final path in [...providerOnly, '/orders/new']) {
        expect(roleGuardRedirect(guest, path), isNull, reason: path);
        expect(roleGuardRedirect(null, path), isNull, reason: path);
      }
    });

    testWidgets('guest bypasses the guards in the real router', (tester) async {
      final harness = await _pump(tester, guest: true);
      for (final path in ['/provider/orders', '/orders/new']) {
        harness.router.go(path);
        await tester.pumpAndSettle();
        expect(_location(harness.router), path);
      }
    });

    testWidgets('signed-out users still go to login first', (tester) async {
      final harness = await _pump(tester);
      harness.router.go('/provider/orders');
      await tester.pumpAndSettle();
      expect(_location(harness.router), '/login');
    });
  });
}

HomeRole _homeRole(WidgetTester tester) =>
    tester.widget<HomePage>(find.byType(HomePage)).role;

String _location(GoRouter router) =>
    router.routerDelegate.currentConfiguration.uri.toString();

Future<({GoRouter router})> _pump(
  WidgetTester tester, {
  List<String>? roles,
  bool guest = false,
}) async {
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(_Repo(roles ?? const [])),
    ],
  );
  addTearDown(container.dispose);
  final controller = container.read(authControllerProvider.notifier);
  if (guest) {
    controller.continueAsGuest();
  } else if (roles != null) {
    await controller.signIn(
      username: 'user@example.test',
      password: 'Password1',
      rememberMe: false,
    );
  }
  final router = container.read(appRouterProvider);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pump();
  return (router: router);
}

class _Repo implements AuthRepository {
  _Repo(this.roles);

  final List<String> roles;

  @override
  Future<AuthSession> signIn(
    String username,
    String password, {
    required bool rememberMe,
  }) async => AuthSession(username: username, token: 'token', roles: roles);

  @override
  Future<AuthSession?> restoreSession() async => null;

  @override
  Future<void> signUp(SignUpRequest request) async {}

  @override
  Future<void> requestPasswordReset(String email) async {}

  @override
  Future<void> resetPassword(String token, String newPassword) async {}

  @override
  Future<void> signOut() async {}
}
