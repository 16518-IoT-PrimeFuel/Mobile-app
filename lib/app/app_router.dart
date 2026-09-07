import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/application/auth_providers.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/out_of_scope_page.dart';
import '../features/auth/presentation/recover_page.dart';
import '../features/account/presentation/account_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/reports/presentation/reports_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);
  final authenticated = auth.session != null;

  return GoRouter(
    initialLocation: authenticated ? '/home' : '/login',
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isAuthRoute =
          location == '/login' ||
          location == '/recover' ||
          location == '/signup';
      if (!authenticated &&
          (location.startsWith('/home') ||
              location.startsWith('/reports') ||
              location.startsWith('/account') ||
              location == '/inventory'))
        return '/login';
      if (authenticated && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
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
        path: '/inventory',
        builder: (context, state) => const InventoryPage(),
      ),
      GoRoute(
        path: '/account',
        builder: (context, state) =>
            const AccountPage(variant: AccountVariant.overview),
      ),
      GoRoute(
        path: '/account/profile',
        builder: (context, state) =>
            const AccountPage(variant: AccountVariant.profile),
      ),
      GoRoute(
        path: '/account/security',
        builder: (context, state) =>
            const AccountPage(variant: AccountVariant.security),
      ),
      GoRoute(
        path: '/account/notifications',
        builder: (context, state) =>
            const AccountPage(variant: AccountVariant.notifications),
      ),
      GoRoute(
        path: '/account/help',
        builder: (context, state) =>
            const AccountPage(variant: AccountVariant.help),
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
        path: '/reports/consumption',
        builder: (context, state) =>
            const ReportsPage(variant: ReportVariant.consumption),
      ),
      GoRoute(
        path: '/reports/sales',
        builder: (context, state) =>
            const ReportsPage(variant: ReportVariant.sales),
      ),
      GoRoute(
        path: '/reports/export',
        builder: (context, state) =>
            const ReportsPage(variant: ReportVariant.export),
      ),
      GoRoute(
        path: '/reports/industry',
        builder: (context, state) =>
            const ReportsPage(variant: ReportVariant.industry),
      ),
      GoRoute(
        path: '/home/empty/requester',
        builder: (context, state) =>
            const EmptyHomePage(role: HomeRole.requester),
      ),
      GoRoute(
        path: '/home/empty/provider',
        builder: (context, state) =>
            const EmptyHomePage(role: HomeRole.provider),
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
