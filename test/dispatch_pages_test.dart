import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/dispatches/application/dispatch_providers.dart';
import 'package:mobile_app/features/dispatches/data/mock_dispatch_repository.dart';
import 'package:mobile_app/features/orders/application/orders_providers.dart';
import 'package:mobile_app/features/orders/data/mock_orders_repository.dart';

import 'package:mobile_app/features/dispatches/presentation/dispatch_pages.dart';

void main() {
  testWidgets(
    'transport availability exposes content, loading, empty and conflict states',
    (tester) async {
      for (final state in TransportAvailabilityState.values) {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              dispatchRepositoryProvider.overrideWithValue(
                MockDispatchRepository(),
              ),
            ],
            child: MaterialApp(
              home: TransportAvailabilityPage(initialState: state),
            ),
          ),
        );
        await tester.pump();
        expect(find.text('Transporte disponible'), findsOneWidget);
      }

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dispatchRepositoryProvider.overrideWithValue(
              MockDispatchRepository(),
            ),
          ],
          child: const MaterialApp(home: TransportAvailabilityPage()),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Actualizar disponibilidad'));
      await tester.pumpAndSettle();
      expect(find.text('ABC-921'), findsOneWidget);
    },
  );

  testWidgets('fleet and driver forms block duplicate records', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dispatchRepositoryProvider.overrideWithValue(
            MockDispatchRepository(),
          ),
        ],
        child: const MaterialApp(
          home: FleetFormPage(initialState: VehicleFormState.duplicate),
        ),
      ),
    );
    await tester.pump();
    expect(
      find.text('Esta placa ya está registrada en tu flota'),
      findsOneWidget,
    );
    expect(find.text('Guardar vehículo'), findsOneWidget);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dispatchRepositoryProvider.overrideWithValue(
            MockDispatchRepository(),
          ),
        ],
        child: const MaterialApp(
          home: DriverFormPage(initialState: DriverFormState.duplicate),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('DNI duplicado'), findsOneWidget);
    expect(find.text('Guardar conductor'), findsOneWidget);
  });

  testWidgets(
    'assignment flow creates a delivery with selected backend resources',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dispatchRepositoryProvider.overrideWithValue(
              MockDispatchRepository(),
            ),
            ordersRepositoryProvider.overrideWithValue(MockOrdersRepository()),
          ],
          child: const MaterialApp(home: DispatchAssignmentPage()),
        ),
      );
      await tester.pumpAndSettle();
      for (var i = 0; i < 3; i++) {
        if (i == 1) {
          expect(find.text('ABC-921'), findsOneWidget);
          await tester.tap(find.text('ABC-921'));
          await tester.pump();
        }
        if (i == 2) {
          expect(find.text('Ana Navarro'), findsOneWidget);
          await tester.tap(find.text('Ana Navarro'));
          await tester.pump();
        }
        await tester.tap(find.text('Continuar  →'));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('Asignar recursos'));
      await tester.pumpAndSettle();
      expect(find.text('Despacho asignado'), findsWidgets);
    },
  );
}
