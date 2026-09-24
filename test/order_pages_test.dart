import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/inventory/application/inventory_providers.dart';
import 'package:mobile_app/features/inventory/data/mock_inventory_repository.dart';
import 'package:mobile_app/features/orders/application/orders_providers.dart';
import 'package:mobile_app/features/orders/data/mock_orders_repository.dart';
import 'package:mobile_app/features/reports/application/reports_providers.dart';
import 'package:mobile_app/features/reports/data/mock_reports_repository.dart';

import 'package:mobile_app/features/orders/presentation/order_pages.dart';

void main() {
  testWidgets('orders flows keep the shared bottom navigation', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: OrdersPage(history: false)),
    );
    await tester.pump();
    expect(find.text('Pedidos'), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(home: SalesReportPage()));
    await tester.pump();
    expect(find.text('Reportes'), findsOneWidget);
  });

  testWidgets('renders order list states and detail', (tester) async {
    for (final state in OrderPageState.values) {
      await tester.pumpWidget(
        _testApp(OrdersPage(history: true, state: state)),
      );
      await tester.pump();
      expect(find.text('Historial'), findsOneWidget);
    }

    await tester.pumpWidget(
      _testApp(const OrderDetailPage(history: false, orderId: 'FT-88421')),
    );
    await tester.pumpAndSettle();
    expect(find.text('#FT-88421'), findsWidgets);
    expect(find.text('En tránsito'), findsWidgets);
  });

  testWidgets('order filters and detail identifiers stay interactive', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(const OrdersPage(history: true)));
    await tester.pump();
    expect(find.text('#FT-88421'), findsOneWidget);
    await tester.tap(find.text('Entregado'));
    await tester.pump();
    expect(find.text('#FT-88421'), findsNothing);

    await tester.pumpWidget(_testApp(const OrdersPage(history: false)));
    await tester.pump();
    await tester.tap(find.text('Aprobado 1'));
    await tester.pump();
    expect(find.text('#FT-88418'), findsOneWidget);

    await tester.pumpWidget(
      _testApp(const OrderDetailPage(history: true, orderId: 'FT-88374')),
    );
    await tester.pump();
    expect(find.text('#FT-88374'), findsOneWidget);
  });

  testWidgets('sales report moves from dashboard to ready', (tester) async {
    await tester.pumpWidget(_testApp(const SalesReportPage()));
    await tester.pump();
    expect(find.text('Reportes de ventas'), findsOneWidget);
    expect(find.text('S/ 31200.00'), findsOneWidget);

    final generate = find.textContaining('Generar reporte');
    await tester.ensureVisible(generate);
    await tester.tap(generate);
    await tester.pumpAndSettle();
    expect(find.text('Reporte listo'), findsWidgets);
    expect(find.textContaining('Descargar PDF'), findsOneWidget);
  });

  testWidgets('renders new order states and creates an order', (tester) async {
    for (final state in NewOrderState.values) {
      await tester.pumpWidget(_testApp(NewOrderPage(initialState: state)));
      await tester.pump();
      expect(find.byType(NewOrderPage), findsOneWidget);
    }

    await tester.pumpWidget(const MaterialApp(home: NewOrderPage()));
    await tester.pump();
    expect(find.text('Nuevo pedido'), findsOneWidget);
    expect(find.text('Crear pedido  →'), findsOneWidget);
    await tester.tap(find.text('Crear pedido  →'));
    await tester.pump();
    expect(find.text('Creando pedido'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text('Pedido creado\ncorrectamente'), findsOneWidget);
    expect(find.text('#FT-MOCK-001'), findsOneWidget);
  });
}

Widget _testApp(Widget home) => ProviderScope(
  overrides: [
    ordersRepositoryProvider.overrideWithValue(MockOrdersRepository()),
    inventoryRepositoryProvider.overrideWithValue(MockInventoryRepository()),
    reportsRepositoryProvider.overrideWithValue(MockReportsRepository()),
  ],
  child: MaterialApp(home: home),
);
