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

  Future<void> createVehicle(String plate, String type) async {
    final result = await AsyncValue.guard(
      () => _repository.createVehicle(
        plate: plate,
        brand: type,
        model: '',
        capacity: 0,
      ),
    );
    result.whenData(
      (vehicle) => state = AsyncData([vehicle, ...state.value ?? []]),
    );
    if (result.hasError) state = AsyncError(result.error!, result.stackTrace!);
  }

  Future<bool> updateVehicle(
    int id, {
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
    if (result.hasError) {
      state = AsyncError(result.error!, result.stackTrace!);
      return false;
    }
    state = AsyncData(
      (state.value ?? [])
          .map((vehicle) => vehicle.id == id ? result.value! : vehicle)
          .toList(),
    );
    return true;
  }

  Future<bool> deleteVehicle(int id) async {
    final result = await AsyncValue.guard(() => _repository.deleteVehicle(id));
    if (result.hasError) {
      state = AsyncError(result.error!, result.stackTrace!);
      return false;
    }
    state = AsyncData(
      (state.value ?? []).where((vehicle) => vehicle.id != id).toList(),
    );
    return true;
  }
}
