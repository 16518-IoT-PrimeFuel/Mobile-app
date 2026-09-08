import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_app/domain/auth/auth_repository.dart';
import 'package:mobile_app/domain/auth/auth_session.dart';
import 'package:mobile_app/features/auth/application/auth_providers.dart';
import 'package:mobile_app/app/app_router.dart';
import 'package:mobile_app/features/gaps/presentation/missing_pages.dart';

void main() {
  testWidgets('renders the missing feature entry screens', (tester) async {
    final screens = <({Widget widget, String title})>[
      (widget: const SplashPage(), title: 'FullTank'),
      (
        widget: const SignupPage(role: SignupRole.requester),
        title: 'Crea tu cuenta empresarial',
      ),
      (widget: const PaymentPage(), title: 'Confirmar pago'),
      (widget: const ProviderOrdersPage(), title: 'Pedidos por atender'),
      (widget: const SupportHelpPage(), title: 'Centro de ayuda'),
      (widget: const NotificationsCenterPage(), title: 'Notificaciones'),
      (widget: const CustomersPage(), title: 'Clientes'),
      (widget: const ProductsPage(), title: 'Inventario de productos'),
    ];

    for (final screen in screens) {
      await tester.pumpWidget(MaterialApp(home: screen.widget));
      await tester.pump();
      expect(find.text(screen.title), findsOneWidget);
    }
  });

  testWidgets('payment and provider actions update their state', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PaymentPage()));
    await tester.tap(find.text('Pagar S/ 42,600'));
    await tester.pump();
    expect(find.text('Procesando pago'), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(
        home: ProviderOrderActionPage(orderId: 'FT-2098', action: 'reject'),
      ),
    );
    await tester.tap(find.text('Confirmar rechazo'));
    await tester.pump();
    expect(find.text('Acción completada'), findsOneWidget);
  });

  testWidgets('signup validates, accepts terms and submits', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SignupPage(role: SignupRole.provider)),
    );
    await tester.tap(find.text('Enviar solicitud'));
    await tester.pump();
    expect(find.text('Este campo es obligatorio'), findsWidgets);

    final fields = find.byType(TextFormField);
    for (var i = 0; i < fields.evaluate().length; i++) {
      await tester.enterText(
        fields.at(i),
        i == 2 ? 'provider@example.com' : 'valor válido',
      );
    }
    await tester.ensureVisible(find.byType(Checkbox));
    await tester.tap(find.byType(Checkbox));
    await tester.ensureVisible(find.text('Enviar solicitud').last);
    await tester.tap(find.text('Enviar solicitud'));
    await tester.pump();
    expect(find.text('Solicitud enviada'), findsOneWidget);
  });

  testWidgets('new routes resolve through the authenticated app router', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(_RouteRepository())],
    );
    addTearDown(container.dispose);
    container.read(authControllerProvider.notifier).continueAsGuest();
    final router = container.read(appRouterProvider);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();

    const routes = <({String path, String title})>[
      (path: '/orders/FT-88421/payment', title: 'Confirmar pago'),
      (path: '/provider/orders', title: 'Pedidos por atender'),
      (path: '/support/help', title: 'Centro de ayuda'),
      (path: '/notifications', title: 'Notificaciones'),
      (path: '/customers', title: 'Clientes'),
      (path: '/customers/new', title: 'Agregar cliente'),
      (path: '/inventory/products', title: 'Inventario de productos'),
      (path: '/inventory/products/new', title: 'Agregar producto'),
    ];
    for (final route in routes) {
      router.go(route.path);
      await tester.pumpAndSettle();
      expect(find.text(route.title), findsOneWidget, reason: route.path);
    }
  });
}

class _RouteRepository implements AuthRepository {
  @override
  Future<AuthSession> signIn(
    String username,
    String password, {
    required bool rememberMe,
  }) async => const AuthSession(username: 'test', token: 'test');

  @override
  Future<AuthSession?> restoreSession() async => null;

  @override
  Future<void> signOut() async {}
}
