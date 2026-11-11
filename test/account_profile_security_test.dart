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
import 'package:mobile_app/features/account/presentation/account_page.dart';
import 'package:mobile_app/features/auth/application/auth_providers.dart';

void main() {
  group('profile', () {
    testWidgets('loads the company of the session', (tester) async {
      final h = await _pump(tester, AccountVariant.profile);
      expect(h.profiles.loaded, 'buyer:17');
      expect(find.widgetWithText(TextField, 'PetroAndes'), findsOneWidget);
      expect(find.text('NOMBRE COMPLETO'), findsNothing);
      expect(find.text('CARGO'), findsNothing);
      expect(find.text('Foto de perfil'), findsNothing);
    });

    testWidgets('saves the edited company and reports success', (tester) async {
      final h = await _pump(tester, AccountVariant.profile);
      await tester.enterText(
        find.widgetWithText(TextField, '555'),
        '999111222',
      );
      await _tap(tester, 'Guardar cambios');
      expect(h.profiles.saved, hasLength(1));
      expect(h.profiles.saved.single.phone, '999111222');
      expect(h.profiles.saved.single.name, 'PetroAndes');
      expect(find.text('Perfil actualizado.'), findsOneWidget);
    });

    testWidgets('save failure does not claim success', (tester) async {
      final h = await _pump(tester, AccountVariant.profile);
      h.profiles.failSave = true;
      await _tap(tester, 'Guardar cambios');
      expect(find.text('No se pudo guardar el perfil.'), findsOneWidget);
      expect(find.text('Perfil actualizado.'), findsNothing);
    });

    testWidgets('an invalid RUC is rejected before calling the API', (
      tester,
    ) async {
      final h = await _pump(tester, AccountVariant.profile);
      await tester.enterText(
        find.widgetWithText(TextField, '20123456789'),
        '12',
      );
      await _tap(tester, 'Guardar cambios');
      expect(h.profiles.saved, isEmpty);
      expect(find.text('El RUC debe tener 11 dígitos.'), findsOneWidget);
    });

    testWidgets('load failure shows the error', (tester) async {
      final h = await _pump(tester, AccountVariant.profile, loadFails: true);
      expect(h.profiles.saved, isEmpty);
      expect(find.text('No se pudo cargar el perfil.'), findsOneWidget);
      expect(find.text('Guardar cambios'), findsNothing);
    });

    testWidgets('guest sees a labelled read-only preview', (tester) async {
      final h = await _pump(tester, AccountVariant.profile, guest: true);
      expect(h.profiles.loaded, isNull);
      expect(find.textContaining('Vista previa'), findsOneWidget);
      expect(find.text('Guardar cambios'), findsNothing);
    });
  });

  group('security', () {
    testWidgets('fake score and two-factor rows are gone', (tester) async {
      await _pump(tester, AccountVariant.security);
      expect(find.text('92/100'), findsNothing);
      expect(find.textContaining('dos pasos'), findsNothing);
      expect(find.text('iPhone 14 Pro ·\nMonterrey'), findsNothing);
    });

    testWidgets('password change sends the reset email', (tester) async {
      final h = await _pump(tester, AccountVariant.security);
      await _tap(tester, 'Cambiar contraseña por correo');
      expect(h.auth.resetRequests, ['buyer@example.test']);
      expect(find.textContaining('Te enviamos un correo'), findsOneWidget);
    });

    testWidgets('reset email failure is reported', (tester) async {
      final h = await _pump(tester, AccountVariant.security);
      h.auth.failReset = true;
      await _tap(tester, 'Cambiar contraseña por correo');
      expect(find.text('No se pudo enviar el correo.'), findsOneWidget);
      expect(find.textContaining('Te enviamos un correo'), findsNothing);
    });

    testWidgets('sign out calls the API and ends the session', (tester) async {
      final h = await _pump(tester, AccountVariant.security);
      await _tap(tester, 'Cerrar sesión');
      expect(h.auth.signOuts, 1);
      expect(h.container.read(authControllerProvider).session, isNull);
      expect(find.text('login page'), findsOneWidget);
    });
  });
}

Future<void> _tap(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text));
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

Future<({_Profiles profiles, _Auth auth, ProviderContainer container})> _pump(
  WidgetTester tester,
  AccountVariant variant, {
  bool loadFails = false,
  bool guest = false,
}) async {
  final profiles = _Profiles()..failLoad = loadFails;
  final auth = _Auth();
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(auth),
      companyProfileRepositoryProvider.overrideWithValue(profiles),
    ],
  );
  addTearDown(container.dispose);
  final controller = container.read(authControllerProvider.notifier);
  if (guest) {
    controller.continueAsGuest();
  } else {
    await controller.signIn(
      username: 'buyer@example.test',
      password: 'Password1',
      rememberMe: false,
    );
  }
  final router = GoRouter(
    initialLocation: '/page',
    routes: [
      GoRoute(
        path: '/page',
        builder: (_, __) => AccountPage(variant: variant),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const Scaffold(body: Text('login page')),
      ),
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
  await tester.pumpAndSettle();
  return (profiles: profiles, auth: auth, container: container);
}

class _Profiles extends CompanyProfileRepository {
  _Profiles() : super(FullTankApi(ApiClient()));
  String? loaded;
  bool failLoad = false;
  bool failSave = false;
  final saved = <CompanyProfile>[];

  @override
  Future<CompanyProfile> load({required bool provider, required int id}) async {
    if (failLoad) throw Exception('boom');
    loaded = '${provider ? 'provider' : 'buyer'}:$id';
    return CompanyProfile(
      isProvider: provider,
      id: id,
      name: 'PetroAndes',
      ruc: '20123456789',
      sector: 'Mining',
      address: 'Av. Lima 1',
      contactEmail: 'ops@petro.test',
      phone: '555',
    );
  }

  @override
  Future<CompanyProfile> save(CompanyProfile profile) async {
    if (failSave) throw Exception('boom');
    saved.add(profile);
    return profile;
  }
}

class _Auth implements AuthRepository {
  final resetRequests = <String>[];
  bool failReset = false;
  int signOuts = 0;

  @override
  Future<AuthSession> signIn(
    String username,
    String password, {
    required bool rememberMe,
  }) async => AuthSession(
    username: username,
    token: 'token',
    companyId: 17,
    roles: const ['ROLE_BUYER'],
  );

  @override
  Future<AuthSession?> restoreSession() async => null;

  @override
  Future<void> signUp(SignUpRequest request) async {}

  @override
  Future<void> requestPasswordReset(String email) async {
    if (failReset) throw Exception('boom');
    resetRequests.add(email);
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {}

  @override
  Future<void> signOut() async => signOuts++;
}
