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
      () => _repository.createVehicle(plate, type),
    );
    result.whenData(
      (vehicle) => state = AsyncData([vehicle, ...state.value ?? []]),
    );
    if (result.hasError) state = AsyncError(result.error!, result.stackTrace!);
  }
}
