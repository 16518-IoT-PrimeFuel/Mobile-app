import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/app_router.dart';
import 'package:mobile_app/domain/auth/auth_repository.dart';
import 'package:mobile_app/domain/auth/auth_session.dart';
import 'package:mobile_app/domain/auth/sign_up_request.dart';
import 'package:mobile_app/features/auth/application/auth_providers.dart';
import 'package:mobile_app/features/auth/presentation/sign_up_page.dart';

void main() {
  const cases = <({String path, BusinessRole role, String label})>[
    (path: '/signup', role: BusinessRole.buyer, label: 'Empresa compradora'),
    (
      path: '/signup/requester',
      role: BusinessRole.buyer,
      label: 'Empresa compradora',
    ),
    (
      path: '/signup/provider',
      role: BusinessRole.provider,
      label: 'Empresa proveedora',
    ),
    (
      path: '/signup?role=provider',
      role: BusinessRole.provider,
      label: 'Empresa proveedora',
    ),
  ];

  for (final c in cases) {
    testWidgets('${c.path} renders the API SignUpPage as ${c.role.name}', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(_Repo())],
      );
      addTearDown(container.dispose);
      final router = container.read(appRouterProvider);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      router.go(c.path);
      await tester.pumpAndSettle();

      final page = tester.widget<SignUpPage>(find.byType(SignUpPage));
      expect(page.initialRole, c.role);
      expect(find.text(c.label), findsOneWidget);
    });
  }
}

class _Repo implements AuthRepository {
  @override
  Future<AuthSession> signIn(
    String username,
    String password, {
    required bool rememberMe,
  }) async => AuthSession(username: username, token: 't');

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
