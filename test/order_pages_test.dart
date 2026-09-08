import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_app/features/orders/presentation/order_pages.dart';

void main() {
  testWidgets('renders order list states and detail', (tester) async {
    for (final state in OrderPageState.values) {
      await tester.pumpWidget(
        MaterialApp(home: OrdersPage(history: true, state: state)),
      );
      await tester.pump();
      expect(find.text('Historial'), findsOneWidget);
    }

    await tester.pumpWidget(
      const MaterialApp(
        home: OrderDetailPage(history: false, orderId: 'FT-88421'),
      ),
    );
    await tester.pump();
    expect(find.text('#FT-88421'), findsOneWidget);
    expect(find.text('En tránsito'), findsWidgets);
  });

  testWidgets('order filters and detail identifiers stay interactive', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: OrdersPage(history: true)));
    await tester.pump();
    expect(find.text('#FT-88421'), findsOneWidget);
    await tester.tap(find.text('Entregado'));
    await tester.pump();
    expect(find.text('#FT-88421'), findsNothing);

    await tester.pumpWidget(
      const MaterialApp(home: OrdersPage(history: false)),
    );
    await tester.pump();
    await tester.tap(find.text('Aprobado 1'));
    await tester.pump();
    expect(find.text('#FT-88418'), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(
        home: OrderDetailPage(history: true, orderId: 'FT-88374'),
      ),
    );
    await tester.pump();
    expect(find.text('#FT-88374'), findsOneWidget);
  });

  testWidgets('sales report moves from dashboard to ready', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SalesReportPage()));
    await tester.pump();
    expect(find.text('Reportes de ventas'), findsOneWidget);
    expect(find.text('S/ 148,320'), findsOneWidget);

    final generate = find.textContaining('Generate Report');
    await tester.ensureVisible(generate);
    await tester.tap(generate);
    await tester.pump();
    expect(find.text('Generando reporte'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text('Reporte listo'), findsWidgets);
    expect(find.textContaining('Download PDF'), findsOneWidget);
  });

  testWidgets('renders new order states and creates an order', (tester) async {
    for (final state in NewOrderState.values) {
      await tester.pumpWidget(
        MaterialApp(home: NewOrderPage(initialState: state)),
      );
      await tester.pump();
      expect(find.byType(NewOrderPage), findsOneWidget);
    }

    await tester.pumpWidget(const MaterialApp(home: NewOrderPage()));
    await tester.pump();
    expect(find.text('New Order'), findsOneWidget);
    expect(find.text('Create Order  →'), findsOneWidget);
    await tester.tap(find.text('Create Order  →'));
    await tester.pump();
    expect(find.text('Creating order'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text('Pedido creado\ncorrectamente'), findsOneWidget);
    expect(find.text('#FT-88421'), findsOneWidget);
  });
}
