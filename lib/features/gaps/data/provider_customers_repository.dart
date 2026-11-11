import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/fulltank_api.dart';
import '../../auth/application/auth_providers.dart';

class CustomerSite {
  const CustomerSite({
    required this.id,
    required this.name,
    required this.address,
  });

  final int id;
  final String name;
  final String address;
}

/// Buyer company linked to the authenticated provider
/// (`GET /api/provider/buyer-companies`).
class ProviderCustomer {
  const ProviderCustomer({
    required this.id,
    required this.name,
    required this.ruc,
    required this.sector,
    required this.tankCount,
    required this.criticalTankCount,
    required this.activeOrderCount,
    required this.historicalOrderCount,
    required this.sites,
  });

  final int id;
  final String name;
  final String ruc;
  final String sector;
  final int tankCount;
  final int criticalTankCount;
  final int activeOrderCount;
  final int historicalOrderCount;
  final List<CustomerSite> sites;
}

class ProviderCustomersRepository {
  const ProviderCustomersRepository(this.api);
  final FullTankApi api;

  Future<List<ProviderCustomer>> list() async {
    final raw = await api.providerBuyerCompanies();
    if (raw is! List) throw const FormatException('Invalid customers response');
    return raw.whereType<Map>().map(_map).toList();
  }

  /// Registers a new buyer company for the provider (name and RUC are the
  /// only required fields of the backend contract).
  Future<void> create({
    required String name,
    required String ruc,
    String? contactEmail,
    String? phone,
  }) async {
    await api.createProviderBuyerCompany({
      'name': name,
      'ruc': ruc,
      if (contactEmail != null && contactEmail.isNotEmpty)
        'contactEmail': contactEmail,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
    });
  }

  ProviderCustomer _map(Map raw) => ProviderCustomer(
    id: _int(raw['id']),
    name: _text(raw['name']),
    ruc: _text(raw['ruc']),
    sector: _text(raw['sector']),
    tankCount: _int(raw['tankCount']),
    criticalTankCount: _int(raw['criticalTankCount']),
    activeOrderCount: _int(raw['activeOrderCount']),
    historicalOrderCount: _int(raw['historicalOrderCount']),
    sites: raw['sites'] is List
        ? [
            for (final site in (raw['sites'] as List).whereType<Map>())
              CustomerSite(
                id: _int(site['id']),
                name: _text(site['name']),
                address: _text(site['address']),
              ),
          ]
        : const [],
  );

  int _int(Object? value) => value is num ? value.toInt() : 0;
  String _text(Object? value) => value == null ? '' : '$value';
}

final providerCustomersRepositoryProvider =
    Provider<ProviderCustomersRepository>(
      (ref) => ProviderCustomersRepository(ref.watch(fullTankApiProvider)),
    );

final providerCustomersProvider =
    FutureProvider.autoDispose<List<ProviderCustomer>>(
      (ref) => ref.watch(providerCustomersRepositoryProvider).list(),
    );
