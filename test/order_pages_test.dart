import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_app/features/orders/application/orders_providers.dart';
import 'package:mobile_app/features/orders/data/mock_orders_repository.dart';
import 'package:mobile_app/features/orders/presentation/order_pages.dart';

Widget testApp(Widget child) => ProviderScope(
  overrides: [
    ordersRepositoryProvider.overrideWithValue(MockOrdersRepository()),
  ],
  child: MaterialApp(home: child),
);

void main() {
  testWidgets('orders flows keep the shared bottom navigation', (tester) async {
    await tester.pumpWidget(testApp(const OrdersPage(history: false)));
    await tester.pump();
    expect(find.text('Pedidos'), findsOneWidget);

    await tester.pumpWidget(testApp(const SalesReportPage()));
    await tester.pump();
    expect(find.text('Reportes'), findsOneWidget);
  });

  testWidgets('renders order list states and detail', (tester) async {
    for (final state in OrderPageState.values) {
      await tester.pumpWidget(testApp(OrdersPage(history: true, state: state)));
      await tester.pump();
      expect(find.text('Historial'), findsOneWidget);
    }

    await tester.pumpWidget(
      testApp(const OrderDetailPage(history: false, orderId: 'FT-88421')),
    );
    await tester.pump();
    expect(find.text('#FT-88421'), findsOneWidget);
    expect(find.text('En tránsito'), findsWidgets);
  });

  testWidgets('order filters and detail identifiers stay interactive', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(const OrdersPage(history: true)));
    await tester.pump();
    expect(find.text('#FT-88421'), findsOneWidget);
    await tester.tap(find.text('Entregado'));
    await tester.pump();
    expect(find.text('#FT-88421'), findsNothing);

    await tester.pumpWidget(testApp(const OrdersPage(history: false)));
    await tester.pump();
    await tester.tap(find.text('Aprobado').first);
    await tester.pump();
    expect(find.text('#FT-88418'), findsOneWidget);

    await tester.pumpWidget(
      testApp(const OrderDetailPage(history: true, orderId: 'FT-88374')),
    );
    await tester.pump();
    expect(find.text('#FT-88374'), findsWidgets);
  });

  testWidgets('sales report moves from dashboard to ready', (tester) async {
    await tester.pumpWidget(testApp(const SalesReportPage()));
    await tester.pump();
    expect(find.text('Reportes de ventas'), findsOneWidget);
    expect(find.text('S/ 148,320'), findsOneWidget);

    final generate = find.textContaining('Generar reporte');
    await tester.ensureVisible(generate);
    await tester.tap(generate);
    await tester.pump();
    expect(find.text('Generando reporte'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text('Reporte listo'), findsWidgets);
    expect(find.textContaining('Descargar PDF'), findsOneWidget);
  });

  testWidgets('renders new order states and creates an order', (tester) async {
    for (final state in NewOrderState.values) {
      await tester.pumpWidget(testApp(NewOrderPage(initialState: state)));
      await tester.pump();
      expect(find.byType(NewOrderPage), findsOneWidget);
    }

    await tester.pumpWidget(testApp(const NewOrderPage()));
    await tester.pump();
    expect(find.text('Nuevo pedido'), findsOneWidget);
    expect(find.text('Crear pedido  →'), findsOneWidget);
    await tester.tap(find.text('Crear pedido  →'));
    await tester.pump();
    expect(find.text('Pedido creado\ncorrectamente'), findsOneWidget);
    expect(find.text('#FT-88421'), findsOneWidget);
  });
}
