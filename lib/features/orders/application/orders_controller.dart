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

  Future<Order?> create({
    required int fuelProductId,
    required int equipmentId,
    required int providerId,
    required String fuel,
    required double quantity,
    required String unit,
    required String deliveryAddress,
    required DateTime deliveryDate,
  }) async {
    final result = await AsyncValue.guard(
      () => _repository.create(
        fuelProductId: fuelProductId,
        equipmentId: equipmentId,
        providerId: providerId,
        fuel: fuel,
        quantity: quantity,
        unit: unit,
        deliveryAddress: deliveryAddress,
        deliveryDate: deliveryDate,
      ),
    );
    result.whenData(
      (order) => state = AsyncData([order, ...state.value ?? []]),
    );
    if (result.hasError) state = AsyncError(result.error!, result.stackTrace!);
    return result.valueOrNull;
  }

  Future<void> accept(int requestId) async {
    try {
      final accepted = await _repository.accept(requestId);
      final current = state.valueOrNull ?? const <Order>[];
      state = AsyncData([
        accepted,
        ...current.where((o) => o.id != '$requestId'),
      ]);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> reject(int requestId, String reason) async {
    try {
      final rejected = await _repository.reject(requestId, reason);
      final current = state.valueOrNull ?? const <Order>[];
      state = AsyncData([
        rejected,
        ...current.where((o) => o.id != '$requestId'),
      ]);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}
