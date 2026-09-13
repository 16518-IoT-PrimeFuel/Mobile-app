import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/dispatch_repository.dart';
import '../domain/vehicle.dart';
import 'dispatch_providers.dart';

final dispatchControllerProvider =
    StateNotifierProvider<DispatchController, AsyncValue<List<Vehicle>>>(
      (ref) => DispatchController(ref.watch(dispatchRepositoryProvider)),
    );

class DispatchController extends StateNotifier<AsyncValue<List<Vehicle>>> {
  DispatchController(this._repository) : super(const AsyncLoading()) {
    load();
  }

  final DispatchRepository _repository;

  Future<void> load() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.vehicles);
  }

  Future<void> createVehicle({
    required String plate,
    required String brand,
    required String model,
    required double capacity,
  }) async {
    final result = await AsyncValue.guard(
      () => _repository.createVehicle(
        plate: plate,
        brand: brand,
        model: model,
        capacity: capacity,
      ),
    );
    result.whenData(
      (vehicle) => state = AsyncData([vehicle, ...state.value ?? []]),
    );
    if (result.hasError) state = AsyncError(result.error!, result.stackTrace!);
  }

  Future<void> deleteVehicle(int id) async {
    await _repository.deleteVehicle(id);
    state = AsyncData(
      state.value?.where((vehicle) => vehicle.id != id).toList() ?? const [],
    );
  }

  Future<void> updateVehicle({
    required int id,
    required String plate,
    required String brand,
    required String model,
    required double capacity,
  }) async {
    final result = await AsyncValue.guard(
      () => _repository.updateVehicle(
        id,
        plate: plate,
        brand: brand,
        model: model,
        capacity: capacity,
      ),
    );
    result.whenData((updated) {
      state = AsyncData([
        for (final vehicle in state.value ?? const [])
          if (vehicle.id == id) updated else vehicle,
      ]);
    });
    if (result.hasError) state = AsyncError(result.error!, result.stackTrace!);
  }
}
