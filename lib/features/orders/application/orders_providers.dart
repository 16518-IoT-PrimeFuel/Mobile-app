import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/application/auth_providers.dart';
import '../data/api_orders_repository.dart';
import '../data/mock_orders_repository.dart';
import '../domain/orders_repository.dart';
import '../domain/order.dart';

const _useMockOrders = bool.fromEnvironment(
  'USE_MOCK_ORDERS',
  defaultValue: false,
);

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  if (_useMockOrders) return MockOrdersRepository();
  return ApiOrdersRepository(
    ref.watch(fullTankApiProvider),
    companyId: ref.watch(authControllerProvider).session?.companyId,
    providerId: ref.watch(authControllerProvider).session?.providerId,
    providerMode:
        ref
            .watch(authControllerProvider)
            .session
            ?.roles
            .contains('ROLE_PROVIDER') ??
        false,
  );
});

final orderDetailProvider = FutureProvider.family<Order?, String>(
  (ref, id) => ref.watch(ordersRepositoryProvider).find(id),
);
