import 'order.dart';

abstract interface class OrdersRepository {
  Future<List<Order>> list({bool history = false});
  Future<Order?> find(String id);
  Future<Order> create({required String fuel, required double quantity});
}
