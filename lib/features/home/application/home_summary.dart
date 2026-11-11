import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/fulltank_api.dart';
import '../../account/application/account_providers.dart';
import '../../account/data/company_profile_repository.dart';
import '../../auth/application/auth_providers.dart';
import '../../inventory/application/inventory_providers.dart';
import '../../inventory/domain/tank.dart';
import '../../orders/application/orders_providers.dart';
import '../../orders/domain/order.dart';

/// Provider analytics the Home dashboard can show.
class ProviderAnalytics {
  const ProviderAnalytics({
    required this.pendingOrders,
    required this.totalFuelSoldLitres,
  });

  final int pendingOrders;
  final double totalFuelSoldLitres;
}

class HomeAnalyticsRepository {
  const HomeAnalyticsRepository(this.api);
  final FullTankApi api;

  Future<ProviderAnalytics> provider(int providerId) async {
    final raw = await api.analyticsForProvider(providerId);
    if (raw is! Map) throw const FormatException('Invalid analytics response');
    return ProviderAnalytics(
      pendingOrders: raw['pendingOrders'] is num
          ? (raw['pendingOrders'] as num).toInt()
          : 0,
      totalFuelSoldLitres: raw['totalFuelSoldLitres'] is num
          ? (raw['totalFuelSoldLitres'] as num).toDouble()
          : 0,
    );
  }
}

final homeAnalyticsRepositoryProvider = Provider<HomeAnalyticsRepository>(
  (ref) => HomeAnalyticsRepository(ref.watch(fullTankApiProvider)),
);

/// Device clock, replaceable in tests.
final homeClockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Everything the Home screen needs for the current session.
class HomeSummary {
  const HomeSummary({
    required this.isProvider,
    required this.companyName,
    required this.fetchedAt,
    this.isPreview = false,
    this.tank,
    this.tankUnavailable = false,
    this.activeOrder,
    this.activeOrderCount = 0,
    this.pendingOrders,
    this.totalFuelSoldLitres,
  });

  final bool isProvider;
  final String companyName;
  final DateTime fetchedAt;

  /// True for the guest session: values are labelled sample data.
  final bool isPreview;

  /// Buyer: tank with the lowest fill level.
  final Tank? tank;
  final bool tankUnavailable;

  /// Buyer: most recent order that is not finished.
  final Order? activeOrder;
  final int activeOrderCount;

  /// Provider analytics.
  final int? pendingOrders;
  final double? totalFuelSoldLitres;
}

const _months = [
  'ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN',
  'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC', // keep one per line below
];
const _days = [
  'LUNES',
  'MARTES',
  'MIÉRCOLES',
  'JUEVES',
  'VIERNES',
  'SÁBADO',
  'DOMINGO',
];

/// Greeting line built from the device clock, e.g.
/// `BUENOS DÍAS · MIÉRCOLES, 11 NOV`.
String homeGreeting(DateTime now) {
  final salute = now.hour < 12
      ? 'BUENOS DÍAS'
      : now.hour < 19
      ? 'BUENAS TARDES'
      : 'BUENAS NOCHES';
  return '$salute · ${_days[now.weekday - 1]}, ${now.day} '
      '${_months[now.month - 1]}';
}

final homeSummaryProvider = FutureProvider<HomeSummary>((ref) async {
  final now = ref.read(homeClockProvider)();
  final session = ref.watch(authControllerProvider).session;
  final isProvider = session?.roles.contains('ROLE_PROVIDER') ?? false;
  if (session?.token == 'guest') return _preview(isProvider, now);

  final profiles = ref.watch(companyProfileRepositoryProvider);
  if (isProvider) {
    final id = session?.providerId;
    if (id == null) return _empty(true, now);
    late final CompanyProfile profile;
    late final ProviderAnalytics analytics;
    await Future.wait([
      profiles.load(provider: true, id: id).then((value) => profile = value),
      ref
          .watch(homeAnalyticsRepositoryProvider)
          .provider(id)
          .then((value) => analytics = value),
    ]);
    return HomeSummary(
      isProvider: true,
      companyName: profile.name,
      fetchedAt: now,
      pendingOrders: analytics.pendingOrders,
      totalFuelSoldLitres: analytics.totalFuelSoldLitres,
    );
  }

  final id = session?.companyId;
  if (id == null) return _empty(false, now);
  final profile = await profiles.load(provider: false, id: id);
  final orders = await ref.watch(ordersRepositoryProvider).list();
  Tank? tank;
  var tankUnavailable = false;
  try {
    final tanks = await ref.watch(inventoryTanksProvider.future);
    for (final candidate in tanks.where((t) => t.capacity > 0)) {
      if (tank == null || candidate.level < tank.level) tank = candidate;
    }
  } catch (_) {
    tankUnavailable = true;
  }
  return HomeSummary(
    isProvider: false,
    companyName: profile.name,
    fetchedAt: now,
    tank: tank,
    tankUnavailable: tankUnavailable,
    activeOrder: orders.isEmpty ? null : orders.first,
    activeOrderCount: orders.length,
  );
});

HomeSummary _empty(bool provider, DateTime now) => HomeSummary(
  isProvider: provider,
  companyName: 'Tu empresa',
  fetchedAt: now,
);

HomeSummary _preview(bool provider, DateTime now) => HomeSummary(
  isProvider: provider,
  companyName: 'Empresa de ejemplo',
  fetchedAt: now,
  isPreview: true,
  tank: provider
      ? null
      : const Tank(
          id: 'preview',
          siteId: 0,
          name: 'Tanque de ejemplo',
          fuelType: 'Diésel',
          capacity: 15000,
          unit: 'L',
          currentLevel: 10200,
          status: 'OPTIMAL',
          lastReadingAt: null,
        ),
  pendingOrders: provider ? 12 : null,
  totalFuelSoldLitres: provider ? 74000 : null,
);
