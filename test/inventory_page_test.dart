import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/features/inventory/application/inventory_providers.dart';
import 'package:mobile_app/features/inventory/data/mock_inventory_repository.dart';

import 'package:mobile_app/features/inventory/presentation/inventory_page.dart';

void main() {
  testWidgets('renders inventory data and filters by status', (tester) async {
    await tester.pumpWidget(
      _inventoryScope(const MaterialApp(home: InventoryPage())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Inventory'), findsOneWidget);
    expect(find.text('6 tanks'), findsOneWidget);
    expect(find.text('Diesel Tank A-102'), findsOneWidget);

    await tester.tap(find.text('Critical'));
    await tester.pump();

    expect(find.text('Diesel Tank A-102'), findsOneWidget);
    expect(find.text('Water Tank B-05'), findsNothing);
  });

  testWidgets('tank rows navigate to tank detail', (tester) async {
    final router = GoRouter(
      initialLocation: '/inventory',
      routes: [
        GoRoute(path: '/inventory', builder: (_, __) => const InventoryPage()),
        GoRoute(
          path: '/inventory/tank/:tankId',
          builder: (_, state) =>
              TankDetailPage(tankId: state.pathParameters['tankId']!),
        ),
      ],
    );

    await tester.pumpWidget(
      _inventoryScope(MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();
    final tankRow = find.byKey(const ValueKey('tank-1'));
    await tester.ensureVisible(tankRow);
    await tester.tap(tankRow);
    await tester.pumpAndSettle();

    expect(
      router.routerDelegate.currentConfiguration.uri.path,
      '/inventory/tank/1',
    );
    expect(find.text('A-102'), findsOneWidget);
    expect(find.text('INVENTORY LEVEL'), findsOneWidget);
  });

  testWidgets('alerts expose restock navigation', (tester) async {
    final router = GoRouter(
      initialLocation: '/inventory/alerts',
      routes: [
        GoRoute(
          path: '/inventory/alerts',
          builder: (_, __) => const InventoryAlertsPage(),
        ),
        GoRoute(
          path: '/orders/new',
          builder: (_, __) => const Text('New Order'),
        ),
      ],
    );

    await tester.pumpWidget(
      _inventoryScope(MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();
    final restockButton = find.text('Restock').first;
    await tester.ensureVisible(restockButton);
    await tester.tap(restockButton);
    await tester.pumpAndSettle();

    expect(router.routerDelegate.currentConfiguration.uri.path, '/orders/new');
    expect(find.text('New Order'), findsOneWidget);
  });
}

Widget _inventoryScope(Widget child) => ProviderScope(
  overrides: [
    inventoryRepositoryProvider.overrideWithValue(MockInventoryRepository()),
  ],
  child: child,
);
