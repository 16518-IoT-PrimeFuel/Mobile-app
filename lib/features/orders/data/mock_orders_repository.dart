import '../domain/order.dart';
import '../domain/orders_repository.dart';

class MockOrdersRepository implements OrdersRepository {
  static const _orders = [
    Order(
      id: '42',
      fuel: 'Diesel',
      quantity: 8000,
      total: 12320,
      status: OrderStatus.pending,
    ),
    Order(
      id: 'FT-88421',
      fuel: 'Diesel · ULSD B5',
      quantity: 6000,
      total: 9274.80,
      status: OrderStatus.inTransit,
    ),
    Order(
      id: 'FT-88418',
      fuel: 'Gasoline',
      quantity: 3200,
      total: 5120,
      status: OrderStatus.approved,
    ),
  ];

  @override
  Future<List<Order>> list({bool history = false}) async => _orders;

  @override
  Future<Order?> find(String id) async => _orders.cast<Order?>().firstWhere(
    (order) => order!.id == id,
    orElse: () => null,
  );

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
  }) async => Order(
    id: 'FT-MOCK-001',
    fuel: fuel,
    quantity: quantity,
    total: quantity * 1.54,
    status: OrderStatus.pending,
    request: true,
    deliveryAddress: deliveryAddress,
  );

  @override
  Future<Order> accept(int requestId) async => Order(
    id: '$requestId',
    fuel: 'Diesel',
    quantity: 100,
    total: 154,
    status: OrderStatus.approved,
  );

  @override
  Future<Order> reject(int requestId, String reason) async => Order(
    id: '$requestId',
    fuel: 'Diesel',
    quantity: 100,
    total: 0,
    status: OrderStatus.rejected,
    request: true,
  );
}
