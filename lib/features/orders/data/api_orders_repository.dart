import '../../../data/fulltank_api.dart';
import '../domain/order.dart';
import '../domain/orders_repository.dart';

class ApiOrdersRepository implements OrdersRepository {
  const ApiOrdersRepository(this.api);

  final FullTankApi api;

  @override
  Future<List<Order>> list({bool history = false}) async {
    final raw = await api.orders();
    if (raw is! List) return const [];
    return raw.whereType<Map>().map(_map).toList();
  }

  @override
  Future<Order?> find(String id) async {
    final numericId = int.tryParse(id.replaceAll(RegExp(r'\D'), ''));
    if (numericId == null) return null;
    final raw = await api.order(numericId);
    return raw is Map ? _map(raw) : null;
  }

  @override
  Future<Order> create({required String fuel, required double quantity}) async {
    final raw = await api.createOrder({'fuel': fuel, 'quantity': quantity});
    if (raw is! Map) throw const FormatException('Invalid order response');
    return _map(raw);
  }

  Order _map(Map raw) => Order(
    id: '${raw['code'] ?? raw['id'] ?? 'UNKNOWN'}',
    fuel: '${raw['fuel'] ?? raw['fuelType'] ?? ''}',
    quantity: _number(raw['quantity']),
    total: _number(raw['total'] ?? raw['amount']),
    status: _status('${raw['status'] ?? 'pending'}'),
  );

  double _number(Object? value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;

  OrderStatus _status(String value) => switch (value.toLowerCase()) {
    'approved' => OrderStatus.approved,
    'in_transit' || 'transit' => OrderStatus.inTransit,
    'delivered' => OrderStatus.delivered,
    'rejected' => OrderStatus.rejected,
    _ => OrderStatus.pending,
  };
}
