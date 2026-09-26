import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/application/auth_providers.dart';
import '../data/api_orders_repository.dart';
import '../data/mock_orders_repository.dart';
import '../domain/order.dart';
import '../domain/orders_repository.dart';

const _useMockOrders = bool.fromEnvironment(
  'USE_MOCK_ORDERS',
  defaultValue: false,
);

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  if (_useMockOrders) return MockOrdersRepository();
  return ApiOrdersRepository(ref.watch(fullTankApiProvider));
});

final orderProvider = FutureProvider.family<Order?, String>((ref, id) {
  return ref.watch(ordersRepositoryProvider).find(id);
});
