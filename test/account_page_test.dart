import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile_app/features/account/presentation/account_page.dart';
import 'package:mobile_app/shared/widgets/fulltank_bottom_navigation.dart';

void main() {
  testWidgets('renders every account variant with the expected bottom bar', (
    tester,
  ) async {
    for (final variant in AccountVariant.values) {
      await tester.pumpWidget(MaterialApp(home: AccountPage(variant: variant)));
      await tester.pump();

      expect(
        find.text('Cuenta'),
        findsNWidgets(
          variant == AccountVariant.overview || variant == AccountVariant.help
              ? 1
              : 0,
        ),
      );
      expect(
        find.text('Editar perfil'),
        variant == AccountVariant.profile ? findsOneWidget : findsNothing,
      );
    }
  });

  testWidgets('bottom bar navigates through the real destination map', (
    tester,
  ) async {
    late GoRouter router;
    Widget screen(String name, int active) => Scaffold(
      body: Center(child: Text(name)),
      bottomNavigationBar: FullTankBottomNav(active: active),
    );

    router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(path: '/home', builder: (_, __) => screen('home', 0)),
        GoRoute(path: '/orders', builder: (_, __) => screen('orders', 1)),
        GoRoute(
          path: '/dispatches',
          builder: (_, __) => screen('dispatches', 2),
        ),
        GoRoute(path: '/reports/sales', builder: (_, __) => screen('sales', 3)),
        GoRoute(
          path: '/account',
          builder: (_, __) =>
              const AccountPage(variant: AccountVariant.overview),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    for (final destination in [
      ('Pedidos', '/orders'),
      ('Despachos', '/dispatches'),
      ('Reportes', '/reports/sales'),
      ('Cuenta', '/account'),
      ('Inicio', '/home'),
    ]) {
      await tester.tap(find.text(destination.$1));
      await tester.pumpAndSettle();
      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        destination.$2,
      );
    }
  });
}
