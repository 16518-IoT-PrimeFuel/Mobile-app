import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/application/auth_providers.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/out_of_scope_page.dart';
import '../features/auth/presentation/recover_page.dart';
import '../features/home/presentation/home_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);
  final authenticated = auth.session != null;

  return GoRouter(
    initialLocation: authenticated ? '/home' : '/login',
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isAuthRoute = location == '/login' ||
          location == '/recover' ||
          location == '/signup';
      if (!authenticated && location == '/home') return '/login';
      if (authenticated && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/recover',
        builder: (context, state) => const RecoverPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const OutOfScopePage(
          title: 'Crear cuenta empresarial',
          message: 'Esta pantalla pertenece a US-40 y se implementará después.',
        ),
      ),
    ],
  );
});
