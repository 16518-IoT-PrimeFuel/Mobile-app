import 'order.dart';

abstract interface class OrdersRepository {
  Future<List<Order>> list({bool history = false});
  Future<Order?> find(String id);
  Future<Order> create({
    required int fuelProductId,
    required int equipmentId,
    required int providerId,
    required String fuel,
    required double quantity,
    required String unit,
    required String deliveryAddress,
    required DateTime deliveryDate,
  });
  Future<Order> accept(int requestId);
  Future<Order> reject(int requestId, String reason);
}
