import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/application/auth_providers.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/recover_page.dart';
import '../features/account/presentation/account_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/inventory/presentation/inventory_page.dart';
import '../features/orders/presentation/order_pages.dart';
import '../features/dispatches/presentation/dispatch_pages.dart';
import '../features/reports/presentation/reports_page.dart';
import '../features/gaps/presentation/missing_pages.dart';
import '../features/public/domain/public_content.dart';
import '../features/public/presentation/public_pages.dart';

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
          location.startsWith('/signup') ||
          location == '/splash';
      if (!authenticated &&
          (location.startsWith('/home') ||
              location.startsWith('/reports') ||
              location.startsWith('/account') ||
              location.startsWith('/inventory') ||
              location.startsWith('/orders') ||
              location.startsWith('/dispatches') ||
              location.startsWith('/provider') ||
              location.startsWith('/support') ||
              location.startsWith('/notifications') ||
              location.startsWith('/customers')))
        return '/login';
      if (authenticated && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: '/about',
        builder: (context, state) =>
            const PublicPage(section: PublicSection.about),
      ),
      GoRoute(
        path: '/how-it-works',
        builder: (context, state) =>
            const PublicPage(section: PublicSection.howItWorks),
      ),
      GoRoute(
        path: '/benefits',
        builder: (context, state) =>
            const PublicPage(section: PublicSection.benefits),
      ),
      GoRoute(
        path: '/testimonials',
        builder: (context, state) =>
            const PublicPage(section: PublicSection.testimonials),
      ),
      GoRoute(
        path: '/plans',
        builder: (context, state) =>
            const PublicPage(section: PublicSection.plans),
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
        path: '/inventory',
        builder: (context, state) => const InventoryPage(),
      ),
      GoRoute(
        path: '/inventory/tank/:tankId',
        builder: (context, state) =>
            TankDetailPage(tankId: state.pathParameters['tankId'] ?? 'A-102'),
      ),
      GoRoute(
        path: '/inventory/alerts',
        builder: (context, state) => const InventoryAlertsPage(),
      ),
      GoRoute(
        path: '/inventory/restock/:tankId',
        builder: (context, state) =>
            RestockPage(tankId: state.pathParameters['tankId'] ?? 'A-102'),
      ),
      GoRoute(
        path: '/orders/history',
        builder: (context, state) => OrdersPage(
          history: true,
          state: orderPageStateFromQuery(state.uri.queryParameters['state']),
        ),
      ),
      GoRoute(
        path: '/orders/history/:orderId',
        builder: (context, state) => OrderDetailPage(
          history: true,
          orderId: state.pathParameters['orderId'] ?? 'FT-88402',
        ),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => OrdersPage(
          history: false,
          state: orderPageStateFromQuery(state.uri.queryParameters['state']),
        ),
      ),
      GoRoute(
        path: '/orders/new',
        builder: (context, state) => NewOrderPage(
          initialState: newOrderStateFromQuery(
            state.uri.queryParameters['state'],
          ),
        ),
      ),
      GoRoute(
        path: '/orders/search',
        builder: (context, state) => const SearchOrdersPage(),
      ),
      GoRoute(
        path: '/orders/filter',
        builder: (context, state) => const SearchOrdersPage(),
      ),
      GoRoute(
        path: '/orders/:orderId/payment',
        builder: (context, state) => PaymentPage(
          orderId: state.pathParameters['orderId'] ?? 'FT-88421',
          initialState: switch (state.uri.queryParameters['state']) {
            'processing' => PaymentState.processing,
            'success' => PaymentState.success,
            'error' => PaymentState.error,
            _ => PaymentState.checkout,
          },
        ),
      ),
      GoRoute(
        path: '/orders/:orderId',
        builder: (context, state) => OrderDetailPage(
          history: false,
          orderId: state.pathParameters['orderId'] ?? 'FT-88421',
        ),
      ),
      GoRoute(
        path: '/provider/orders',
        builder: (context, state) => const ProviderOrdersPage(),
      ),
      GoRoute(
        path: '/provider/orders/:orderId',
        builder: (context, state) => ProviderOrderDetailPage(
          orderId: state.pathParameters['orderId'] ?? 'FT-2098',
        ),
      ),
      GoRoute(
        path: '/provider/orders/:orderId/:action',
        builder: (context, state) => ProviderOrderActionPage(
          orderId: state.pathParameters['orderId'] ?? 'FT-2098',
          action: state.pathParameters['action'] ?? 'dispatch',
        ),
      ),
      GoRoute(
        path: '/dispatches',
        builder: (context, state) => TransportAvailabilityPage(
          initialState: dispatchAvailabilityStateFromQuery(
            state.uri.queryParameters['state'],
          ),
        ),
      ),
      GoRoute(
        path: '/dispatches/fleet',
        builder: (context, state) => const FleetPage(),
      ),
      GoRoute(
        path: '/dispatches/fleet/new',
        builder: (context, state) => FleetFormPage(
          initialState: state.uri.queryParameters['state'] == 'duplicate'
              ? VehicleFormState.duplicate
              : VehicleFormState.normal,
          editingPlate: state.uri.queryParameters['edit'],
        ),
      ),
      GoRoute(
        path: '/dispatches/drivers',
        builder: (context, state) => const DriverPage(),
      ),
      GoRoute(
        path: '/dispatches/drivers/new',
        builder: (context, state) => DriverFormPage(
          initialState: state.uri.queryParameters['state'] == 'duplicate'
              ? DriverFormState.duplicate
              : DriverFormState.normal,
          editing: state.uri.queryParameters['edit'] == 'true',
        ),
      ),
      GoRoute(
        path: '/dispatches/assign',
        builder: (context, state) => DispatchAssignmentPage(
          initialState: dispatchAssignmentStateFromQuery(
            state.uri.queryParameters['state'],
          ),
        ),
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
        path: '/support/help',
        builder: (context, state) => const SupportHelpPage(),
      ),
      GoRoute(
        path: '/support/contact',
        builder: (context, state) => const ContactSupportPage(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsCenterPage(),
      ),
      GoRoute(
        path: '/customers',
        builder: (context, state) => const CustomersPage(),
      ),
      GoRoute(
        path: '/customers/new',
        builder: (context, state) => const CustomerFormPage(),
      ),
      GoRoute(
        path: '/customers/:customerId/edit',
        builder: (context, state) =>
            CustomerFormPage(customerId: state.pathParameters['customerId']),
      ),
      GoRoute(
        path: '/customers/:customerId',
        builder: (context, state) => CustomerDetailPage(
          customerId: state.pathParameters['customerId'] ?? 'agronorte',
        ),
      ),
      GoRoute(
        path: '/inventory/products',
        builder: (context, state) => const ProductsPage(),
      ),
      GoRoute(
        path: '/inventory/products/new',
        builder: (context, state) => const ProductFormPage(),
      ),
      GoRoute(
        path: '/inventory/products/:productId/edit',
        builder: (context, state) =>
            ProductFormPage(productId: state.pathParameters['productId']),
      ),
      GoRoute(
        path: '/inventory/products/:productId',
        builder: (context, state) =>
            ProductFormPage(productId: state.pathParameters['productId']),
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
        builder: (context, state) => SalesReportPage(
          initialState: switch (state.uri.queryParameters['state']) {
            'generating' => SalesReportState.generating,
            'ready' => SalesReportState.ready,
            'empty' => SalesReportState.empty,
            _ => SalesReportState.dashboard,
          },
        ),
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
        path: '/signup/requester',
        builder: (context, state) =>
            const SignupPage(role: SignupRole.requester),
      ),
      GoRoute(
        path: '/signup/provider',
        builder: (context, state) =>
            const SignupPage(role: SignupRole.provider),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => SignupPage(
          role: state.uri.queryParameters['role'] == 'provider'
              ? SignupRole.provider
              : SignupRole.requester,
        ),
      ),
    ],
  );
});
