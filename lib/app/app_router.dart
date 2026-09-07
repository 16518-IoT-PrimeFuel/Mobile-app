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
      if (!authenticated && location.startsWith('/home')) return '/login';
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
        builder: (context, state) => HomePage(
          role: state.uri.queryParameters['role'] == 'provider'
              ? HomeRole.provider
              : HomeRole.requester,
        ),
      ),
      GoRoute(
        path: '/home/provider',
        builder: (context, state) => const HomePage(role: HomeRole.provider),
      ),
      GoRoute(
        path: '/home/search',
        builder: (context, state) => const GlobalSearchPage(),
      ),
      GoRoute(
        path: '/home/quick-actions',
        builder: (context, state) => const QuickActionsPage(),
      ),
      GoRoute(
        path: '/home/activity',
        builder: (context, state) => const ActivityCenterPage(),
      ),
      GoRoute(
        path: '/home/empty/requester',
        builder: (context, state) => const EmptyHomePage(role: HomeRole.requester),
      ),
      GoRoute(
        path: '/home/empty/provider',
        builder: (context, state) => const EmptyHomePage(role: HomeRole.provider),
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
