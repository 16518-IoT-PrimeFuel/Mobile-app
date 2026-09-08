import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/fuel_product.dart';
import '../domain/inventory_repository.dart';
import 'inventory_providers.dart';

final inventoryControllerProvider =
    StateNotifierProvider<InventoryController, AsyncValue<List<FuelProduct>>>(
      (ref) => InventoryController(ref.watch(inventoryRepositoryProvider)),
    );

class InventoryController extends StateNotifier<AsyncValue<List<FuelProduct>>> {
  InventoryController(this._repository) : super(const AsyncLoading()) {
    load();
  }

  final InventoryRepository _repository;

  Future<void> load() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.list);
  }

  Future<void> remove(int id) async {
    await _repository.delete(id);
    await load();
  }
}
