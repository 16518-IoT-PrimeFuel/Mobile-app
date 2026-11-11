import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile_app/domain/auth/auth_repository.dart';
import 'package:mobile_app/domain/auth/auth_session.dart';
import 'package:mobile_app/domain/auth/sign_up_request.dart';
import 'package:mobile_app/features/auth/application/auth_providers.dart';
import 'package:mobile_app/features/home/application/home_summary.dart';
import 'package:mobile_app/features/home/presentation/home_page.dart';
import 'package:mobile_app/features/inventory/domain/tank.dart';

void main() {
  testWidgets('renders every requested Home-related screen', (tester) async {
    final screens = <({Widget screen, String title})>[
      (
        screen: const HomePage(role: HomeRole.requester),
        title: 'Empresa de ejemplo',
      ),
      (screen: const GlobalSearchPage(), title: 'Búsqueda global'),
      (screen: const QuickActionsPage(), title: 'Acciones rápidas'),
      (screen: const ActivityCenterPage(), title: 'Actividad'),
      (
        screen: const EmptyHomePage(role: HomeRole.requester),
        title: 'No hay pedidos activos',
      ),
      (
        screen: const EmptyHomePage(role: HomeRole.provider),
        title: 'No hay operaciones hoy',
      ),
    ];

    for (final entry in screens) {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(_NoopAuthRepository()),
            homeSummaryProvider.overrideWith((ref) async => _sample),
          ],
          child: MaterialApp(home: entry.screen),
        ),
      );
      await tester.pump();
      expect(find.text(entry.title), findsOneWidget);
    }
  });

  testWidgets('tank summary opens inventory', (tester) async {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (_, __) => const HomePage(role: HomeRole.requester),
        ),
        GoRoute(
          path: '/inventory',
          builder: (_, __) => const Text('Inventario abierto'),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [homeSummaryProvider.overrideWith((ref) async => _sample)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
    final tank = find.textContaining('TANQUE MÁS BAJO');
    await tester.ensureVisible(tank);
    await tester.tap(tank);
    await tester.pumpAndSettle();

    expect(find.text('Inventario abierto'), findsOneWidget);
  });
}

final _sample = HomeSummary(
  isProvider: false,
  companyName: 'Empresa de ejemplo',
  fetchedAt: DateTime(2026, 11, 11, 9),
  tank: const Tank(
    id: 'T1',
    siteId: 1,
    name: 'A-102',
    fuelType: 'Diésel',
    capacity: 10000,
    unit: 'L',
    currentLevel: 4500,
    status: 'OPTIMAL',
    lastReadingAt: null,
  ),
);

class _NoopAuthRepository implements AuthRepository {
  @override
  Future<AuthSession> signIn(
    String username,
    String password, {
    required bool rememberMe,
  }) async {
    return const AuthSession(username: 'test', token: 'test');
  }

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
