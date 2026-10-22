import '../../../data/fulltank_api.dart';
import '../../inventory/domain/tank.dart';

class ReplenishmentSite {
  const ReplenishmentSite({required this.id, required this.name});
  final int id;
  final String name;
}

class ReplenishmentProvider {
  const ReplenishmentProvider({required this.id, required this.name});
  final int id;
  final String name;
}

class ReplenishmentProduct {
  const ReplenishmentProduct({
    required this.id,
    required this.providerId,
    required this.name,
  });
  final int id;
  final int providerId;
  final String name;
}

class ReplenishmentOptions {
  const ReplenishmentOptions({
    this.customerAccountId,
    this.sites = const [],
    this.providers = const [],
    this.products = const [],
    this.unavailableReason,
  });

  final int? customerAccountId;
  final List<ReplenishmentSite> sites;
  final List<ReplenishmentProvider> providers;
  final List<ReplenishmentProduct> products;
  final String? unavailableReason;
}

class ApiReplenishmentOptionsRepository {
  const ApiReplenishmentOptionsRepository(this.api);
  final FullTankApi api;

  Future<ReplenishmentOptions> load({
    required int? companyId,
    required List<Map<String, Object?>> memberships,
  }) async {
    if (companyId == null) {
      return const ReplenishmentOptions(
        unavailableReason: 'Inicia sesión con una cuenta de comprador activa.',
      );
    }
    final organizations = memberships
        .map((item) => _int(item['organizationId']))
        .whereType<int>()
        .toSet();
    if (organizations.length > 1) {
      return const ReplenishmentOptions(
        unavailableReason:
            'Selecciona una organización activa antes de crear una solicitud.',
      );
    }

    final customers = await api.customers();
    final matching = customers is List
        ? customers
              .whereType<Map>()
              .where(
                (item) =>
                    _int(item['legacyCompanyId']) == companyId &&
                    item['active'] != false,
              )
              .toList()
        : <Map>[];
    if (matching.length != 1) {
      return const ReplenishmentOptions(
        unavailableReason:
            'No hay una cuenta de cliente única vinculada a este perfil.',
      );
    }
    final customerId = _int(matching.single['id']);
    if (customerId == null) {
      return const ReplenishmentOptions(
        unavailableReason:
            'La cuenta de cliente no tiene un identificador válido.',
      );
    }

    final responses = await Future.wait([
      api.customerSites(customerId),
      api.providerCompanies(),
      api.fuelProducts(),
    ]);
    final sites = responses[0] is List
        ? (responses[0] as List)
              .whereType<Map>()
              .where((item) => item['active'] != false)
              .map(
                (item) => ReplenishmentSite(
                  id: _int(item['id']) ?? 0,
                  name: '${item['name'] ?? 'Site'}',
                ),
              )
              .where((site) => site.id > 0)
              .toList()
        : <ReplenishmentSite>[];
    final providers = responses[1] is List
        ? (responses[1] as List)
              .whereType<Map>()
              .where((item) => item['active'] != false)
              .map(
                (item) => ReplenishmentProvider(
                  id: _int(item['id']) ?? 0,
                  name: '${item['name'] ?? ''}',
                ),
              )
              .where((provider) => provider.id > 0 && provider.name.isNotEmpty)
              .toList()
        : <ReplenishmentProvider>[];
    final products = responses[2] is List
        ? (responses[2] as List)
              .whereType<Map>()
              .where((item) => item['active'] != false)
              .map(
                (item) => ReplenishmentProduct(
                  id: _int(item['id']) ?? 0,
                  providerId: _int(item['providerId']) ?? 0,
                  name: '${item['name'] ?? item['fuelType'] ?? ''}',
                ),
              )
              .where(
                (product) =>
                    product.id > 0 &&
                    product.providerId > 0 &&
                    product.name.isNotEmpty,
              )
              .toList()
        : <ReplenishmentProduct>[];

    return ReplenishmentOptions(
      customerAccountId: customerId,
      sites: sites,
      providers: providers,
      products: products,
      unavailableReason: sites.isEmpty
          ? 'No hay sitios de entrega activos para esta cuenta de cliente.'
          : providers.isEmpty
          ? 'No hay proveedores activos disponibles en este momento.'
          : products.isEmpty
          ? 'No hay productos de combustible activos disponibles.'
          : null,
    );
  }

  Future<List<Tank>> tanks({
    required int companyId,
    required int siteId,
  }) async {
    final raw = await api.tanks(companyId, siteId);
    return raw is List
        ? raw
              .whereType<Map>()
              .map(_tank)
              .where((tank) => tank.id.isNotEmpty)
              .toList()
        : const [];
  }

  Tank _tank(Map raw) => Tank(
    id: '${raw['id'] ?? ''}',
    siteId: _int(raw['siteId']) ?? 0,
    name: '${raw['name'] ?? ''}',
    fuelType: '${raw['fuelType'] ?? ''}',
    capacity: _number(raw['capacity']),
    unit: '${raw['unit'] ?? 'L'}',
    currentLevel: _number(raw['currentLevel']),
    status: '${raw['status'] ?? ''}',
    lastReadingAt: DateTime.tryParse('${raw['lastReadingAt'] ?? ''}'),
  );

  int? _int(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value');
  double _number(Object? value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
}
