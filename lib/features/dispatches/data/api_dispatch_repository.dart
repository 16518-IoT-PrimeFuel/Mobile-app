import '../../../data/fulltank_api.dart';
import '../domain/dispatch_repository.dart';
import '../domain/vehicle.dart';

class ApiDispatchRepository implements DispatchRepository {
  const ApiDispatchRepository(this.api);

  final FullTankApi api;

  @override
  Future<List<Vehicle>> vehicles() async {
    final raw = await api.vehicles();
    if (raw is! List) return const [];
    return raw.whereType<Map>().map(_map).toList();
  }

  @override
  Future<Vehicle> createVehicle(String plate, String type) async {
    final raw = await api.createVehicle({'plate': plate, 'type': type});
    if (raw is! Map) throw const FormatException('Invalid vehicle response');
    return _map(raw);
  }

  @override
  Future<void> deleteVehicle(int id) => api.deleteVehicle(id);

  Vehicle _map(Map raw) => Vehicle(
    id: raw['id'] is num ? (raw['id'] as num).toInt() : 0,
    plate: '${raw['plate'] ?? ''}',
    type: '${raw['type'] ?? raw['vehicleType'] ?? ''}',
  );
}
