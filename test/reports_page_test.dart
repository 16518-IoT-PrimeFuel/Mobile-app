import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_app/features/reports/presentation/reports_page.dart';

void main() {
  testWidgets('renders every report variant and Spanish navigation', (
    tester,
  ) async {
    for (final variant in ReportVariant.values) {
      await tester.pumpWidget(MaterialApp(home: ReportsPage(variant: variant)));
      await tester.pump();
      expect(find.text('Clientes'), findsOneWidget);
      expect(find.text('Inventario'), findsOneWidget);
      expect(find.text('Ventas'), findsWidgets);
      expect(find.text('Reportes'), findsOneWidget);
      expect(find.text('Cuenta'), findsOneWidget);
    }
  });
}
