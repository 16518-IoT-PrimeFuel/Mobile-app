import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_app/features/dispatches/presentation/dispatch_pages.dart';

void main() {
  testWidgets(
    'transport availability exposes content, loading, empty and conflict states',
    (tester) async {
      for (final state in TransportAvailabilityState.values) {
        await tester.pumpWidget(
          MaterialApp(home: TransportAvailabilityPage(initialState: state)),
        );
        await tester.pump();
        expect(find.text('Transporte disponible'), findsOneWidget);
      }

      await tester.pumpWidget(
        const MaterialApp(home: TransportAvailabilityPage()),
      );
      await tester.pump();
      await tester.tap(find.text('Actualizar').first);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Cargando...'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('TK-4421'), findsOneWidget);
    },
  );

  testWidgets('fleet and driver forms block duplicate records', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FleetFormPage(initialState: VehicleFormState.duplicate),
      ),
    );
    await tester.pump();
    expect(
      find.text('Esta placa ya está registrada en tu flota'),
      findsOneWidget,
    );
    expect(find.text('Guardar vehículo'), findsOneWidget);
    await tester.pumpWidget(
      const MaterialApp(
        home: DriverFormPage(initialState: DriverFormState.duplicate),
      ),
    );
    await tester.pump();
    expect(find.text('Este DNI ya está registrado'), findsOneWidget);
    expect(find.text('Guardar conductor'), findsOneWidget);
  });

  testWidgets(
    'assignment flow reaches conflict and can recover with a new vehicle',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: DispatchAssignmentPage()),
      );
      await tester.pump();
      for (var i = 0; i < 3; i++) {
        await tester.tap(find.text('Continuar  →'));
        await tester.pump();
      }
      await tester.tap(find.text('Asignar recursos'));
      await tester.pump();
      expect(
        find.textContaining('Conflicto de recursos detectado'),
        findsOneWidget,
      );
      await tester.tap(find.text('Volver a seleccionar'));
      await tester.pump();
      await tester.tap(find.text('TK-2214'));
      await tester.tap(find.text('Continuar  →'));
      await tester.pump();
      await tester.tap(find.text('Carlos Mendoza'));
      await tester.tap(find.text('Continuar  →'));
      await tester.pump();
      await tester.tap(find.text('Asignar recursos'));
      await tester.pump();
      expect(find.text('Despacho asignado'), findsNWidgets(2));
    },
  );
}
