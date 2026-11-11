import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/orders/application/orders_providers.dart';
import 'package:mobile_app/features/orders/data/mock_orders_repository.dart';
import 'package:mobile_app/features/orders/presentation/order_pages.dart';
import 'package:mobile_app/features/reports/application/reports_providers.dart';
import 'package:mobile_app/features/reports/domain/report.dart';
import 'package:mobile_app/features/reports/domain/reports_repository.dart';

void main() {
  testWidgets('history detail has no invoice download, only a disabled note', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const OrderDetailPage(history: true, orderId: 'FT-88374')),
    );
    await tester.pump();
    expect(find.text('Descargar factura'), findsNothing);
    final note = find.textContaining('No disponible aún');
    expect(note, findsOneWidget);
    final button = tester.widget<OutlinedButton>(
      find.ancestor(of: note, matching: find.byType(OutlinedButton)),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('active detail has no live tracking button', (tester) async {
    await tester.pumpWidget(
      _app(const OrderDetailPage(history: false, orderId: 'FT-88421')),
    );
    await tester.pump();
    expect(find.textContaining('Seguimiento en vivo'), findsNothing);
    expect(find.text('Soporte'), findsOneWidget);
  });

  group('history export', () {
    testWidgets('shows the consumption summary and copies it', (tester) async {
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String;
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await tester.pumpWidget(
        _app(const OrdersPage(history: true), csv: 'a,b\n1,2'),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Resumen de consumo'));
      await tester.pumpAndSettle();
      expect(find.text('Resumen de consumo'), findsWidgets);
      expect(find.textContaining('a,b'), findsOneWidget);
      await tester.tap(find.text('Copiar'));
      await tester.pumpAndSettle();
      expect(copied, 'a,b\n1,2');
    });

    testWidgets('a failing export shows an error, no dialog', (tester) async {
      await tester.pumpWidget(_app(const OrdersPage(history: true), csv: null));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Resumen de consumo'));
      await tester.pumpAndSettle();
      expect(find.text('No se pudo obtener el resumen.'), findsOneWidget);
      expect(find.text('Copiar'), findsNothing);
    });

    testWidgets('the misleading download label is gone', (tester) async {
      await tester.pumpWidget(_app(const OrdersPage(history: true), csv: 'x'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Descargar historial'), findsNothing);
    });
  });
}

Widget _app(Widget child, {String? csv = 'x'}) => ProviderScope(
  overrides: [
    ordersRepositoryProvider.overrideWithValue(MockOrdersRepository()),
    reportsRepositoryProvider.overrideWithValue(_Reports(csv)),
  ],
  child: MaterialApp(home: child),
);

class _Reports implements ReportsRepository {
  _Reports(this.csv);
  final String? csv;

  @override
  Future<String> exportCsv() async {
    if (csv == null) throw StateError('boom');
    return csv!;
  }

  @override
  Future<ReportSummary> summary() async =>
      const ReportSummary(revenue: 0, liters: 0, orders: 0);
}
