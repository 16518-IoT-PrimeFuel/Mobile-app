import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/order.dart';
import '../domain/orders_repository.dart';
import 'orders_providers.dart';

final ordersControllerProvider =
    StateNotifierProvider<OrdersController, AsyncValue<List<Order>>>(
      (ref) => OrdersController(ref.watch(ordersRepositoryProvider)),
    );

class OrdersController extends StateNotifier<AsyncValue<List<Order>>> {
  OrdersController(this._repository) : super(const AsyncLoading()) {
    load();
  }

  final OrdersRepository _repository;

  Future<void> load({bool history = false}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.list(history: history));
  }

  Future<void> create({required String fuel, required double quantity}) async {
    final result = await AsyncValue.guard(
      () => _repository.create(fuel: fuel, quantity: quantity),
    );
    result.whenData(
      (order) => state = AsyncData([order, ...state.value ?? []]),
    );
    if (result.hasError) state = AsyncError(result.error!, result.stackTrace!);
  }
}
