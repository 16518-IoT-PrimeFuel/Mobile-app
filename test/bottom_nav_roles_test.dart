import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/domain/auth/auth_repository.dart';
import 'package:mobile_app/domain/auth/auth_session.dart';
import 'package:mobile_app/features/auth/application/auth_providers.dart';
import 'package:mobile_app/shared/widgets/fulltank_bottom_navigation.dart';

void main() {
  testWidgets('buyer does not get the Despachos tab', (tester) async {
    await _pump(tester, roles: const ['ROLE_BUYER']);
    expect(find.text('Despachos'), findsNothing);
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Pedidos'), findsOneWidget);
    expect(find.text('Reportes'), findsOneWidget);
    expect(find.text('Cuenta'), findsOneWidget);
  });

  testWidgets('provider keeps all five tabs', (tester) async {
    await _pump(tester, roles: const ['ROLE_PROVIDER']);
    expect(find.text('Despachos'), findsOneWidget);
  });

  testWidgets('guest keeps all five tabs', (tester) async {
    await _pump(tester, guest: true);
    expect(find.text('Despachos'), findsOneWidget);
  });

  testWidgets('without a provider scope all tabs show', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(bottomNavigationBar: FullTankBottomNav(active: 0)),
      ),
    );
    expect(find.text('Despachos'), findsOneWidget);
  });

  testWidgets('onTap reports the logical tab index for a buyer', (
    tester,
  ) async {
    final taps = <int>[];
    await _pump(tester, roles: const ['ROLE_BUYER'], onTap: taps.add);
    await tester.tap(find.text('Reportes'));
    await tester.tap(find.text('Cuenta'));
    expect(taps, [3, 4]);
  });
}

Future<void> _pump(
  WidgetTester tester, {
  List<String>? roles,
  bool guest = false,
  ValueChanged<int>? onTap,
}) async {
  final container = ProviderContainer(
    overrides: [authRepositoryProvider.overrideWithValue(_Repo(roles ?? []))],
  );
  addTearDown(container.dispose);
  final controller = container.read(authControllerProvider.notifier);
  if (guest) {
    controller.continueAsGuest();
  } else {
    await controller.signIn(
      username: 'user@example.test',
      password: 'Password1',
      rememberMe: false,
    );
  }
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Scaffold(
          bottomNavigationBar: FullTankBottomNav(active: 0, onTap: onTap),
        ),
      ),
    ),
  );
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
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
