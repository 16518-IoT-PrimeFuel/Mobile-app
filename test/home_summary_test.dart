import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/data/api_client.dart';
import 'package:mobile_app/data/fulltank_api.dart';
import 'package:mobile_app/domain/auth/auth_repository.dart';
import 'package:mobile_app/domain/auth/auth_session.dart';
import 'package:mobile_app/domain/auth/sign_up_request.dart';
import 'package:mobile_app/features/account/application/account_providers.dart';
import 'package:mobile_app/features/account/data/company_profile_repository.dart';
import 'package:mobile_app/features/auth/application/auth_providers.dart';
import 'package:mobile_app/features/home/application/home_summary.dart';
import 'package:mobile_app/features/home/presentation/home_page.dart';
import 'package:mobile_app/features/inventory/application/inventory_providers.dart';
import 'package:mobile_app/features/inventory/domain/tank.dart';
import 'package:mobile_app/features/orders/application/orders_providers.dart';
import 'package:mobile_app/features/orders/domain/order.dart';
import 'package:mobile_app/features/orders/domain/orders_repository.dart';

void main() {
  testWidgets('buyer summary renders real values', (tester) async {
    await _pump(tester);
    expect(find.text('PetroAndes'), findsOneWidget);
    expect(find.text('PE'), findsOneWidget);
    expect(find.text('BUENOS DÍAS · MIÉRCOLES, 11 NOV'), findsOneWidget);
    expect(find.textContaining('A-102'), findsOneWidget);
    expect(find.text('45%'), findsOneWidget);
    expect(find.text('4.500 / 10.000 L'), findsOneWidget);
    expect(find.text('Crítico'), findsOneWidget);
    expect(find.text('#88421'), findsOneWidget);
    expect(find.text('8.000 L · Diésel B5'), findsOneWidget);
    for (final fake in [
      '10.200 / 15.000 L',
      '#FT-2041',
      'Norte · Sector 4',
      'Actualizado hace 5 min',
      'de FuelMex Logistics',
    ]) {
      expect(find.text(fake), findsNothing);
    }
  });

  testWidgets('active order card opens the real order id', (tester) async {
    await _pump(tester);
    final card = find.text('Ver detalles');
    await tester.ensureVisible(card);
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.text('order 88421'), findsOneWidget);
  });

  testWidgets('provider summary renders pending orders and fuel sold', (
    tester,
  ) async {
    await _pump(tester, provider: true);
    expect(find.text('Andes Fuel'), findsOneWidget);
    expect(find.text('PEDIDOS PENDIENTES'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('COMBUSTIBLE VENDIDO'), findsOneWidget);
    expect(find.textContaining('74.000'), findsOneWidget);
    expect(find.text('CLIENTES'), findsNothing);
    expect(find.text('ENTREGAS ACTIVAS'), findsNothing);
    expect(find.text('Aprobar pedido — AgroNorte'), findsNothing);
  });

  testWidgets('no orders hides the order card', (tester) async {
    await _pump(tester, orders: const []);
    expect(find.text('PEDIDO ACTIVO'), findsNothing);
    expect(find.text('Ver detalles'), findsNothing);
    expect(find.text('PetroAndes'), findsOneWidget);
  });

  testWidgets('failure shows retry and recovers', (tester) async {
    final h = await _pump(tester, failProfile: true);
    expect(find.text('No se pudo cargar el resumen.'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
    h.profiles.fail = false;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('PetroAndes'), findsOneWidget);
  });

  testWidgets('loading state is shown while fetching', (tester) async {
    final gate = Completer<void>();
    await _pump(tester, gate: gate);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    gate.complete();
    await tester.pumpAndSettle();
    expect(find.text('PetroAndes'), findsOneWidget);
  });

  testWidgets('guest sees labelled sample data', (tester) async {
    await _pump(tester, guest: true);
    expect(find.textContaining('Vista previa'), findsWidgets);
    expect(find.text('PetroAndes'), findsNothing);
    expect(find.text('Salir de vista previa'), findsOneWidget);
  });

  test('greeting follows the clock', () {
    expect(
      homeGreeting(DateTime(2026, 11, 11, 9)),
      'BUENOS DÍAS · MIÉRCOLES, 11 NOV',
    );
    expect(
      homeGreeting(DateTime(2026, 11, 11, 15)),
      startsWith('BUENAS TARDES'),
    );
    expect(
      homeGreeting(DateTime(2026, 11, 11, 22)),
      startsWith('BUENAS NOCHES'),
    );
  });
}

typedef _Harness = ({_Profiles profiles});

Future<_Harness> _pump(
  WidgetTester tester, {
  bool provider = false,
  bool guest = false,
  bool failProfile = false,
  Completer<void>? gate,
  List<Order>? orders,
}) async {
  final profiles = _Profiles()
    ..fail = failProfile
    ..gate = gate;
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(_Auth(provider)),
      companyProfileRepositoryProvider.overrideWithValue(profiles),
      ordersRepositoryProvider.overrideWithValue(
        _Orders(
          orders ??
              const [
                Order(
                  id: '88421',
                  fuel: 'Diésel B5',
                  quantity: 8000,
                  total: 0,
                  status: OrderStatus.inTransit,
                ),
              ],
        ),
      ),
      inventoryTanksProvider.overrideWith(
        (ref) async => const [
          Tank(
            id: 'T2',
            siteId: 1,
            name: 'A-102',
            fuelType: 'Diésel',
            capacity: 10000,
            unit: 'L',
            currentLevel: 4500,
            status: 'CRITICAL',
            lastReadingAt: null,
          ),
          Tank(
            id: 'T1',
            siteId: 1,
            name: 'B-05',
            fuelType: 'Diésel',
            capacity: 10000,
            unit: 'L',
            currentLevel: 9000,
            status: 'OPTIMAL',
            lastReadingAt: null,
          ),
        ],
      ),
      homeAnalyticsRepositoryProvider.overrideWithValue(_Analytics()),
      homeClockProvider.overrideWithValue(() => DateTime(2026, 11, 11, 9)),
    ],
  );
  addTearDown(container.dispose);
  final controller = container.read(authControllerProvider.notifier);
  if (guest) {
    controller.continueAsGuest();
  } else {
    await controller.signIn(
      username: 'user@example.test',
      password: 'Password1',
      rememberMe: false,
    );
  }
  final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (_, __) =>
            HomePage(role: provider ? HomeRole.provider : HomeRole.requester),
      ),
      GoRoute(
        path: '/orders/:id',
        builder: (_, state) => Text('order ${state.pathParameters['id']}'),
      ),
      GoRoute(path: '/login', builder: (_, __) => const Text('login')),
    ],
  );
  tester.view.physicalSize = const Size(900, 3200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  if (gate == null) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
  return (profiles: profiles);
}

class _Profiles extends CompanyProfileRepository {
  _Profiles() : super(FullTankApi(ApiClient()));
  bool fail = false;
  Completer<void>? gate;

  @override
  Future<CompanyProfile> load({required bool provider, required int id}) async {
    await gate?.future;
    if (fail) throw Exception('boom');
    return CompanyProfile(
      isProvider: provider,
      id: id,
      name: provider ? 'Andes Fuel' : 'PetroAndes',
      ruc: '20123456789',
      address: '',
      phone: '',
    );
  }
}

class _Orders implements OrdersRepository {
  _Orders(this.items);
  final List<Order> items;

  @override
  Future<List<Order>> list({bool history = false}) async => items;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Analytics extends HomeAnalyticsRepository {
  _Analytics() : super(FullTankApi(ApiClient()));

  @override
  Future<ProviderAnalytics> provider(int providerId) async =>
      const ProviderAnalytics(pendingOrders: 5, totalFuelSoldLitres: 74000);
}

class _Auth implements AuthRepository {
  _Auth(this.provider);
  final bool provider;

  @override
  Future<AuthSession> signIn(
    String username,
    String password, {
    required bool rememberMe,
  }) async => AuthSession(
    username: username,
    token: 'token',
    companyId: provider ? null : 17,
    providerId: provider ? 9 : null,
    roles: [provider ? 'ROLE_PROVIDER' : 'ROLE_BUYER'],
  );

  @override
  Future<AuthSession?> restoreSession() async => null;
  @override
  Future<void> signUp(SignUpRequest request) async {}
  @override
  Future<void> requestPasswordReset(String email) async {}
  @override
  Future<void> resetPassword(String token, String newPassword) async {}
  @override
  Future<void> signOut() async {}
}
