import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_app/domain/auth/auth_repository.dart';
import 'package:mobile_app/domain/auth/auth_session.dart';
import 'package:mobile_app/features/auth/application/auth_providers.dart';
import 'package:mobile_app/features/home/presentation/home_page.dart';

void main() {
  testWidgets('renders every requested Home-related screen', (tester) async {
    final screens = <({Widget screen, String title})>[
      (screen: const HomePage(role: HomeRole.requester), title: 'PetroAndes'),
      (screen: const HomePage(role: HomeRole.provider), title: 'FuelMex Logistics'),
      (screen: const GlobalSearchPage(), title: 'Búsqueda global'),
      (screen: const QuickActionsPage(), title: 'Acciones rápidas'),
      (screen: const ActivityCenterPage(), title: 'Actividad'),
      (screen: const EmptyHomePage(role: HomeRole.requester), title: 'No hay pedidos activos'),
      (screen: const EmptyHomePage(role: HomeRole.provider), title: 'No hay operaciones hoy'),
    ];

    for (final entry in screens) {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(_NoopAuthRepository()),
          ],
          child: MaterialApp(home: entry.screen),
        ),
      );
      await tester.pump();
      expect(find.text(entry.title), findsOneWidget);
    }
  });
}

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
  Future<void> signOut() async {}
}
