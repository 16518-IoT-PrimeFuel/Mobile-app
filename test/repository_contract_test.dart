import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/inventory/data/mock_inventory_repository.dart';
import 'package:mobile_app/features/orders/data/mock_orders_repository.dart';
import 'package:mobile_app/features/orders/domain/order.dart';

void main() {
  test('mock repositories expose typed domain entities', () async {
    final orders = await MockOrdersRepository().list();
    final products = await MockInventoryRepository().list();

    expect(orders, isNotEmpty);
    expect(orders.first, isA<Order>());
    expect(products, isNotEmpty);
    expect(products.first.name, isNotEmpty);
  });
}
