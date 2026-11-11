import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/data/api_client.dart';
import 'package:mobile_app/data/fulltank_api.dart';
import 'package:mobile_app/features/gaps/data/provider_customers_repository.dart';
import 'package:mobile_app/features/gaps/presentation/missing_pages.dart';

void main() {
  testWidgets('list renders API customers with their counts', (tester) async {
    await _pump(tester, _Repo());
    expect(find.text('Clientes'), findsOneWidget);
    expect(find.text('2 cuentas vinculadas'), findsOneWidget);
    expect(find.text('AgroNorte S.A.'), findsOneWidget);
    expect(
      find.text('3 tanques · 1 crítico · 2 pedidos activos'),
      findsOneWidget,
    );
    expect(find.text('Transportes Delta'), findsOneWidget);
    expect(find.text('Cementos B'), findsNothing);
  });

  testWidgets('empty list shows an empty state', (tester) async {
    await _pump(tester, _Repo(items: const []));
    expect(find.text('Aún no tienes clientes vinculados.'), findsOneWidget);
  });

  testWidgets('error shows retry and recovers', (tester) async {
    final repo = _Repo()..fail = true;
    await _pump(tester, repo);
    expect(find.text('No se pudieron cargar los clientes.'), findsOneWidget);
    repo.fail = false;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('AgroNorte S.A.'), findsOneWidget);
  });

  testWidgets('search filters by name or RUC', (tester) async {
    await _pump(tester, _Repo());
    await tester.enterText(find.byType(TextField), 'delta');
    await tester.pumpAndSettle();
    expect(find.text('Transportes Delta'), findsOneWidget);
    expect(find.text('AgroNorte S.A.'), findsNothing);
    await tester.enterText(find.byType(TextField), '20123456789');
    await tester.pumpAndSettle();
    expect(find.text('AgroNorte S.A.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();
    expect(find.text('Sin resultados.'), findsOneWidget);
  });

  testWidgets('detail shows counts and sites without unsupported actions', (
    tester,
  ) async {
    await _pump(tester, _Repo());
    await tester.tap(find.text('AgroNorte S.A.'));
    await tester.pumpAndSettle();
    expect(find.text('Detalle de cliente'), findsOneWidget);
    expect(find.text('20123456789'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('14'), findsOneWidget);
    expect(find.text('Sede Norte'), findsOneWidget);
    expect(find.text('Av. Lima 1'), findsOneWidget);
    expect(find.text('Archivar cliente'), findsNothing);
    expect(find.text('Crear pedido para este cliente'), findsNothing);
    expect(find.byTooltip('Editar'), findsNothing);
  });

  testWidgets('create form posts name and RUC and returns to the list', (
    tester,
  ) async {
    final repo = _Repo();
    await _pump(tester, repo);
    await tester.tap(find.byTooltip('Agregar cliente'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar cliente'));
    await tester.pumpAndSettle();
    expect(repo.created, isEmpty);
    expect(find.text('El RUC debe tener 11 dígitos.'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Empresa'),
      'Nuevo SA',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'RUC'),
      '20123456789',
    );
    await tester.tap(find.text('Guardar cliente'));
    await tester.pumpAndSettle();
    expect(repo.created, ['Nuevo SA:20123456789']);
    expect(find.text('Clientes'), findsOneWidget);
  });

  testWidgets('create failure does not claim success', (tester) async {
    final repo = _Repo()..failCreate = true;
    await _pump(tester, repo);
    await tester.tap(find.byTooltip('Agregar cliente'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Empresa'),
      'Nuevo SA',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'RUC'),
      '20123456789',
    );
    await tester.tap(find.text('Guardar cliente'));
    await tester.pumpAndSettle();
    expect(find.text('No se pudo guardar el cliente.'), findsOneWidget);
    expect(find.text('Cliente guardado correctamente.'), findsNothing);
  });
}

Future<void> _pump(WidgetTester tester, _Repo repo) async {
  final router = GoRouter(
    initialLocation: '/customers',
    routes: [
      GoRoute(path: '/customers', builder: (_, __) => const CustomersPage()),
      GoRoute(
        path: '/customers/new',
        builder: (_, __) => const CustomerFormPage(),
      ),
      GoRoute(
        path: '/customers/:customerId',
        builder: (_, state) =>
            CustomerDetailPage(customerId: state.pathParameters['customerId']!),
      ),
    ],
  );
  tester.view.physicalSize = const Size(900, 3200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [providerCustomersRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
}

class _Repo extends ProviderCustomersRepository {
  _Repo({List<ProviderCustomer>? items})
    : items = items ?? _sample,
      super(FullTankApi(ApiClient()));

  final List<ProviderCustomer> items;
  bool fail = false;
  bool failCreate = false;
  final created = <String>[];

  static const _sample = [
    ProviderCustomer(
      id: 5,
      name: 'AgroNorte S.A.',
      ruc: '20123456789',
      sector: 'Agro',
      tankCount: 3,
      criticalTankCount: 1,
      activeOrderCount: 2,
      historicalOrderCount: 14,
      sites: [CustomerSite(id: 8, name: 'Sede Norte', address: 'Av. Lima 1')],
    ),
    ProviderCustomer(
      id: 6,
      name: 'Transportes Delta',
      ruc: '20999888777',
      sector: 'Transporte',
      tankCount: 0,
      criticalTankCount: 0,
      activeOrderCount: 0,
      historicalOrderCount: 0,
      sites: [],
    ),
  ];

  @override
  Future<List<ProviderCustomer>> list() async {
    if (fail) throw Exception('boom');
    return items;
  }

  @override
  Future<void> create({
    required String name,
    required String ruc,
    String? contactEmail,
    String? phone,
  }) async {
    if (failCreate) throw Exception('boom');
    created.add('$name:$ruc');
  }
}
