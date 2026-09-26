import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_app/features/reports/application/reports_controller.dart';
import 'package:mobile_app/features/reports/domain/report.dart';
import 'package:mobile_app/features/reports/presentation/reports_page.dart';

void main() {
  testWidgets('renders every report variant and Spanish navigation', (
    tester,
  ) async {
    for (final variant in ReportVariant.values) {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            reportsControllerProvider.overrideWith(
              (ref) async => const ReportSummary(
                revenue: 31200,
                liters: 1240000,
                orders: 318,
              ),
            ),
          ],
          child: MaterialApp(home: ReportsPage(variant: variant)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Inicio'), findsOneWidget);
      expect(find.text('Pedidos'), findsWidgets);
      expect(find.text('Despachos'), findsOneWidget);
      expect(find.text('Reportes'), findsOneWidget);
      expect(find.text('Cuenta'), findsOneWidget);
    }
  });

  testWidgets('renders report metrics from the controller', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          reportsControllerProvider.overrideWith(
            (ref) async =>
                const ReportSummary(revenue: 4200, liters: 8000, orders: 12),
          ),
        ],
        child: const MaterialApp(
          home: ReportsPage(variant: ReportVariant.sales),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('\$4200'), findsWidgets);
    expect(find.text('8000 L'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
  });

  testWidgets('preserves report error state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          reportsControllerProvider.overrideWith(
            (ref) async => throw StateError('offline'),
          ),
        ],
        child: const MaterialApp(
          home: ReportsPage(variant: ReportVariant.sales),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No pudimos cargar este reporte'), findsOneWidget);
    expect(find.text('Intenta nuevamente más tarde.'), findsOneWidget);
  });
}
