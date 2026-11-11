import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/data/api_client.dart';
import 'package:mobile_app/data/fulltank_api.dart';
import 'package:mobile_app/features/inventory/application/inventory_providers.dart';
import 'package:mobile_app/features/inventory/domain/tank.dart';
import 'package:mobile_app/features/inventory/presentation/inventory_page.dart';
import 'package:mobile_app/features/orders/application/orders_providers.dart';
import 'package:mobile_app/features/orders/data/replenishment_options_repository.dart';
import 'package:mobile_app/features/orders/domain/order.dart';
import 'package:mobile_app/features/orders/domain/orders_repository.dart';

const _tank = Tank(
  id: '7',
  siteId: 3,
  name: 'Tanque real 7',
  fuelType: 'Diesel',
  capacity: 12000,
  unit: 'L',
  currentLevel: 2000,
  status: 'LOW',
  lastReadingAt: null,
);

void main() {
  testWidgets('submits the real tank, provider, product, quantity and date', (
    tester,
  ) async {
    final orders = _FakeOrders();
    final router = await _pump(tester, orders);
    await _fillForm(tester);
    await _tapSend(tester);

    expect(orders.calls, hasLength(1));
    final call = orders.calls.single;
    expect(call.customerAccountId, 42);
    expect(call.tankId, '7');
    expect(call.providerId, 5);
    expect(call.fuelProductId, 11);
    expect(call.quantity, 3000);
    expect(call.deliveryDate, DateUtils.dateOnly(DateTime.now()));
    expect(router.routerDelegate.currentConfiguration.uri.path, '/orders');
  });

  testWidgets('failure shows the error and does not claim success', (
    tester,
  ) async {
    final orders = _FakeOrders(fail: true);
    final router = await _pump(tester, orders);
    await _fillForm(tester);
    await _tapSend(tester);

    expect(orders.calls, hasLength(1));
    expect(find.textContaining('No se pudo enviar'), findsOneWidget);
    expect(find.textContaining('Solicitud enviada'), findsNothing);
    expect(
      router.routerDelegate.currentConfiguration.uri.path,
      '/inventory/restock/7',
    );
  });

  testWidgets('an empty quantity never calls the API', (tester) async {
    final orders = _FakeOrders();
    await _pump(tester, orders);
    await _fillForm(tester);
    await tester.enterText(find.byType(TextField), '');
    await _tapSend(tester);

    expect(orders.calls, isEmpty);
    expect(find.text('Ingresa una cantidad primero.'), findsOneWidget);
  });

  testWidgets('no provider selected never calls the API', (tester) async {
    final orders = _FakeOrders();
    await _pump(tester, orders);
    await tester.tap(find.text('3,000 L'));
    await _tapSend(tester);

    expect(orders.calls, isEmpty);
    expect(find.text('Selecciona proveedor y producto.'), findsOneWidget);
  });

  testWidgets('priority chips and notes are gone, date picker opens', (
    tester,
  ) async {
    await _pump(tester, _FakeOrders());
    expect(find.text('Urgente'), findsNothing);
    expect(find.text('Notas para el conductor'), findsNothing);
    await tester.ensureVisible(find.text('FECHA DE ENTREGA'));
    await tester.tap(find.text('FECHA DE ENTREGA'));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });

  testWidgets('preview mode is labelled and never claims success', (
    tester,
  ) async {
    final orders = _FakeOrders();
    await _pump(tester, orders, preview: true);
    expect(find.textContaining('Vista previa con datos'), findsOneWidget);
    await _tapSend(tester);
    expect(orders.calls, isEmpty);
    expect(
      find.text('Vista previa: no se envió ninguna solicitud.'),
      findsOneWidget,
    );
    expect(find.textContaining('Solicitud enviada'), findsNothing);
  });
}

Future<void> _fillForm(WidgetTester tester) async {
  await tester.ensureVisible(find.text('PROVEEDOR'));
  await tester.tap(find.text('PROVEEDOR'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Global Fuel').last);
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text('PRODUCTO'));
  await tester.tap(find.text('PRODUCTO'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Diesel B5').last);
  await tester.pumpAndSettle();
  await tester.tap(find.text('3,000 L'));
  await tester.pumpAndSettle();
}

Future<void> _tapSend(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Enviar solicitud'));
  await tester.tap(find.text('Enviar solicitud'));
  await tester.pumpAndSettle();
}

Future<GoRouter> _pump(
  WidgetTester tester,
  _FakeOrders orders, {
  bool preview = false,
}) async {
  tester.view.physicalSize = const Size(900, 3200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  final router = GoRouter(
    initialLocation: '/inventory/restock/7',
    routes: [
      GoRoute(
        path: '/inventory/restock/:tankId',
        builder: (_, state) =>
            RestockPage(tankId: state.pathParameters['tankId']!),
      ),
      GoRoute(
        path: '/orders',
        builder: (_, __) => const Scaffold(body: Text('orders list')),
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        inventoryPreviewProvider.overrideWithValue(preview),
        inventoryTankProvider.overrideWith((ref, id) async => _tank),
        replenishmentOptionsRepositoryProvider.overrideWithValue(
          _FakeOptions(),
        ),
        ordersRepositoryProvider.overrideWithValue(orders),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

class _FakeOptions extends ApiReplenishmentOptionsRepository {
  _FakeOptions() : super(FullTankApi(ApiClient()));

  @override
  Future<ReplenishmentOptions> load({
    required int? companyId,
    required List<Map<String, Object?>> memberships,
  }) async => const ReplenishmentOptions(
    customerAccountId: 42,
    sites: [ReplenishmentSite(id: 3, name: 'Planta')],
    providers: [ReplenishmentProvider(id: 5, name: 'Global Fuel')],
    products: [
      ReplenishmentProduct(id: 11, providerId: 5, name: 'Diesel B5'),
      ReplenishmentProduct(id: 12, providerId: 6, name: 'Gasolina 90'),
    ],
  );
}

class _Call {
  _Call(
    this.customerAccountId,
    this.tankId,
    this.providerId,
    this.fuelProductId,
    this.quantity,
    this.deliveryDate,
  );
  final int customerAccountId;
  final String? tankId;
  final int? providerId;
  final int? fuelProductId;
  final double quantity;
  final DateTime deliveryDate;
}

class _FakeOrders implements OrdersRepository {
  _FakeOrders({this.fail = false});
  final bool fail;
  final calls = <_Call>[];

  @override
  Future<List<Order>> list({bool history = false}) async => const [];

  @override
  Future<Order> create({
    required int customerAccountId,
    required int? fuelProductId,
    required String? tankId,
    required int? providerId,
    required String fuel,
    required double quantity,
    required String unit,
    required String deliveryAddress,
    required DateTime deliveryDate,
  }) async {
    calls.add(
      _Call(
        customerAccountId,
        tankId,
        providerId,
        fuelProductId,
        quantity,
        deliveryDate,
      ),
    );
    if (fail) throw StateError('boom');
    return Order(
      id: '1',
      fuel: fuel,
      quantity: quantity,
      total: 0,
      status: OrderStatus.pending,
    );
  }

  @override
  Future<Order?> find(String id) async => null;
  @override
  Future<Order> accept(int requestId) => throw UnimplementedError();
  @override
  Future<Order> reject(int requestId, String reason) =>
      throw UnimplementedError();
}
