import '../../../data/api_client.dart';
import '../../../data/fulltank_api.dart';
import '../domain/order.dart';
import '../domain/orders_repository.dart';

class ApiOrdersRepository implements OrdersRepository {
  const ApiOrdersRepository(
    this.api, {
    this.companyId = 1,
    this.providerId,
    this.providerMode = false,
  });
  final FullTankApi api;
  final int? companyId;
  final int? providerId;
  final bool providerMode;

  @override
  Future<List<Order>> list({bool history = false}) async {
    final id = providerMode ? providerId : companyId;
    if (id == null) return const [];
    final rawOrders = providerMode
        ? await api.providerOrders(id)
        : await api.orders(companyId: id);
    final rawRequests = await api.fuelRequests(
      buyerCompanyId: providerMode ? null : id,
      providerId: providerMode ? id : null,
    );
    final rawProducts = await api.fuelProducts(
      providerId: providerMode ? id : null,
    );
    final names = rawProducts is List
        ? {
            for (final item in rawProducts.whereType<Map>())
              _int(item['id']): '${item['name'] ?? item['fuelType'] ?? ''}',
          }
        : const <int?, String>{};
    final orders = rawOrders is List
        ? rawOrders
              .whereType<Map>()
              .map((raw) => _mapOrder(raw, names))
              .toList()
        : <Order>[];
    final ids = orders.map((order) => order.requestId).whereType<int>().toSet();
    final requests = rawRequests is List
        ? rawRequests
              .whereType<Map>()
              .where((raw) => !ids.contains(_int(raw['id'])))
              .map(_mapRequest)
              .toList()
        : <Order>[];
    final result = [...orders, ...requests];
    return result
        .where(
          (order) =>
              history ? _isHistory(order.status) : !_isHistory(order.status),
        )
        .toList();
  }

  @override
  Future<Order?> find(String id) async {
    final numericId = int.tryParse(id);
    if (numericId == null) return null;
    try {
      final raw = await api.order(numericId);
      if (raw is Map) return _mapOrder(raw);
    } on ApiException catch (error) {
      if (error.statusCode != 404) rethrow;
    }
    final request = await api.fuelRequest(numericId);
    return request is Map ? _mapRequest(request) : null;
  }

  @override
  Future<Order> create({
    required int fuelProductId,
    required int equipmentId,
    required int providerId,
    required String fuel,
    required double quantity,
    required String unit,
    required String deliveryAddress,
    required DateTime deliveryDate,
  }) async {
    final buyerId = companyId;
    if (buyerId == null)
      throw StateError('Authenticated buyer company is required');
    final raw = await api.createFuelRequest({
      'buyerCompanyId': buyerId,
      'providerId': providerId,
      'fuelProductId': fuelProductId,
      'equipmentId': equipmentId,
      'quantity': quantity,
      'unit': unit,
      'deliveryAddress': deliveryAddress,
      'deliveryDate': deliveryDate.toIso8601String().substring(0, 10),
      'source': 'MOBILE',
    });
    if (raw is! Map)
      throw const FormatException('Invalid fuel request response');
    return _mapRequest(raw);
  }

  @override
  Future<Order> accept(int requestId) async {
    final raw = await api.acceptFuelRequest(requestId);
    if (raw is! Map)
      throw const FormatException('Invalid accepted order response');
    return _mapOrder(raw);
  }

  @override
  Future<Order> reject(int requestId, String reason) async {
    final raw = await api.rejectFuelRequest(requestId, reason);
    if (raw is! Map)
      throw const FormatException('Invalid rejected request response');
    return _mapRequest(raw);
  }

  Order _mapOrder(Map raw, [Map<int?, String> names = const {}]) => Order(
    id: '${raw['id'] ?? 'UNKNOWN'}',
    fuel:
        '${raw['fuel'] ?? raw['fuelType'] ?? names[_int(raw['fuelProductId'])] ?? 'Producto #${raw['fuelProductId'] ?? ''}'}',
    quantity: _number(raw['requestedQuantity'] ?? raw['quantity']),
    total: _number(raw['totalPrice'] ?? raw['total'] ?? raw['amount']),
    status: _status('${raw['status'] ?? 'PENDING'}'),
    requestId: _int(raw['requestId']),
    deliveryAddress: '${raw['deliveryAddress'] ?? ''}',
  );
  Order _mapRequest(Map raw) => Order(
    id: '${raw['id'] ?? 'UNKNOWN'}',
    fuel:
        '${raw['productName'] ?? raw['fuelType'] ?? 'Producto #${raw['fuelProductId'] ?? ''}'}',
    quantity: _number(raw['quantity']),
    total: _number(raw['unitPrice']) * _number(raw['quantity']),
    status: _status('${raw['status'] ?? 'PENDING'}'),
    request: true,
    deliveryAddress: '${raw['deliveryAddress'] ?? ''}',
  );
  int? _int(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value');
  double _number(Object? value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
  bool _isHistory(OrderStatus status) =>
      status == OrderStatus.delivered ||
      status == OrderStatus.cancelled ||
      status == OrderStatus.rejected;
  OrderStatus _status(String value) => switch (value.toLowerCase()) {
    'approved' ||
    'confirmed' ||
    'pending_payment' ||
    'paid' => OrderStatus.approved,
    'dispatched' ||
    'in_progress' ||
    'in_transit' ||
    'transit' => OrderStatus.inTransit,
    'delivered' => OrderStatus.delivered,
    'cancelled' || 'canceled' => OrderStatus.cancelled,
    'rejected' => OrderStatus.rejected,
    _ => OrderStatus.pending,
  };
}
