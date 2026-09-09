import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_app/features/auth/presentation/recover_page.dart';

void main() {
  testWidgets('renders the recovery form in Spanish', (tester) async {
    await tester.pumpWidget(const _TestApp());

    expect(find.text('RECUPERACIÓN SEGURA'), findsOneWidget);
    expect(find.text('Recuperar contraseña'), findsOneWidget);
    expect(find.text('Enviar enlace de recuperación'), findsOneWidget);
    expect(find.text('Contactar soporte 24/7'), findsOneWidget);
  });

  testWidgets('shows the empty email validation state', (tester) async {
    await tester.pumpWidget(const _TestApp());
    await tester.ensureVisible(find.text('Enviar enlace de recuperación'));
    await tester.tap(find.text('Enviar enlace de recuperación'));
    await tester.pump();

    expect(find.text('Ingresa tu email corporativo'), findsOneWidget);
  });

  testWidgets('shows the not found state for the reference email', (
    tester,
  ) async {
    await tester.pumpWidget(const _TestApp());
    await tester.enterText(find.byType(TextField), 'noexiste@empresa.com');
    await tester.ensureVisible(find.text('Enviar enlace de recuperación'));
    await tester.tap(find.text('Enviar enlace de recuperación'));
    await tester.pump();

    expect(
      find.text('No encontramos ninguna cuenta con este email'),
      findsOneWidget,
    );
  });

  testWidgets('shows the sent state for a valid email', (tester) async {
    await tester.pumpWidget(const _TestApp());
    await tester.enterText(find.byType(TextField), 'operador@empresa.com');
    await tester.ensureVisible(find.text('Enviar enlace de recuperación'));
    await tester.tap(find.text('Enviar enlace de recuperación'));
    await tester.pump();

    expect(find.text('Revisa tu bandeja'), findsOneWidget);
    expect(find.text('Abrir mi correo'), findsOneWidget);
    expect(find.text('ENVIADO A'), findsOneWidget);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: RecoverPage());
  }
}
