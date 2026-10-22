import '../../../data/api_client.dart';
import '../../../data/fulltank_api.dart';

class ProviderOrder {
  const ProviderOrder({
    required this.id,
    required this.customer,
    required this.detail,
    required this.status,
  });

  final String id;
  final String customer;
  final String detail;
  final String status;
}

abstract interface class ProviderOrderRepository {
  Future<List<ProviderOrder>> list();
  Future<void> accept(int requestId);
  Future<void> reject(int requestId, String reason);
  Future<void> dispatch(int deliveryId);
  Future<void> complete(int deliveryId, double deliveredVolume);
}

class ApiProviderOrderRepository implements ProviderOrderRepository {
  ApiProviderOrderRepository({FullTankApi? api, this.providerId})
    : api = api ?? FullTankApi(ApiClient());

  final FullTankApi api;
  final int? providerId;

  @override
  Future<List<ProviderOrder>> list() async {
    final id = providerId;
    if (id == null) return const [];
    final responses = await Future.wait([
      api.providerOrders(id),
      api.fuelRequests(providerId: id),
    ]);
    return [..._map(responses[0]), ..._map(responses[1])];
  }

  @override
  Future<void> accept(int requestId) async {
    await api.acceptFuelRequest(requestId);
  }

  @override
  Future<void> reject(int requestId, String reason) async {
    await api.rejectFuelRequest(requestId, reason);
  }

  @override
  Future<void> dispatch(int deliveryId) async {
    throw UnsupportedError(
      'Delivery assignment requires a driver, tanker, command ID, and time window',
    );
  }

  @override
  Future<void> complete(int deliveryId, double deliveredVolume) async {
    await api.completeDelivery(deliveryId, deliveredVolume: deliveredVolume);
  }

  List<ProviderOrder> _map(Object? raw) => raw is List
      ? raw
            .whereType<Map>()
            .map(
              (item) => ProviderOrder(
                id: '${item['id'] ?? 'UNKNOWN'}',
                customer:
                    '${item['buyerCompanyName'] ?? item['customerName'] ?? 'Cliente'}',
                detail:
                    '${item['quantity'] ?? item['requestedQuantity'] ?? 0} L · ${item['fuelType'] ?? item['productName'] ?? 'Combustible'}',
                status: _label(item['status']),
              ),
            )
            .toList()
      : const [];

  String _label(Object? value) => switch ('$value'.toUpperCase()) {
    'APPROVED' || 'CONFIRMED' || 'PAID' => 'Aprobado',
    'DISPATCHED' || 'IN_PROGRESS' || 'IN_TRANSIT' => 'En tránsito',
    'DELIVERED' => 'Entregado',
    'REJECTED' => 'Rechazado',
    _ => 'Pendiente',
  };
}

class MockProviderOrderRepository implements ProviderOrderRepository {
  static const orders = [
    ProviderOrder(
      id: 'FT-2098',
      customer: 'AgroNorte',
      detail: '12,000 L · Diésel B5 · entrega hoy',
      status: 'Pendiente',
    ),
    ProviderOrder(
      id: 'FT-2091',
      customer: 'Transportes Delta',
      detail: '8,000 L · Gasolina regular · 3:00 PM',
      status: 'Aprobado',
    ),
  ];

  @override
  Future<List<ProviderOrder>> list() async => orders;
  @override
  Future<void> accept(int requestId) async {}
  @override
  Future<void> reject(int requestId, String reason) async {}
  @override
  Future<void> dispatch(int deliveryId) async {}
  @override
  Future<void> complete(int deliveryId, double deliveredVolume) async {}
}

ProviderOrderRepository providerOrderRepository({int? providerId}) =>
    const bool.fromEnvironment('USE_MOCK_PROVIDER_ORDERS', defaultValue: false)
    ? MockProviderOrderRepository()
    : ApiProviderOrderRepository(providerId: providerId);
