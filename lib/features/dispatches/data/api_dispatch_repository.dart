import '../../../data/fulltank_api.dart';
import '../domain/dispatch_repository.dart';
import '../domain/driver.dart';
import '../domain/vehicle.dart';

class ApiDispatchRepository implements DispatchRepository {
  const ApiDispatchRepository(this.api, {this.providerId});
  final FullTankApi api;
  final int? providerId;

  @override
  Future<List<Vehicle>> vehicles() async {
    final raw = await api.vehicles();
    return raw is List ? raw.whereType<Map>().map(_map).toList() : const [];
  }

  @override
  Future<Vehicle> createVehicle({
    required String plate,
    required String brand,
    required String model,
    required double capacity,
  }) async {
    final raw = await api.createVehicle({
      'licensePlate': plate,
      'brand': brand,
      'model': model,
      'capacity': capacity,
      'unit': 'LITERS',
      'status': 'AVAILABLE',
    });
    if (raw is! Map) throw const FormatException('Invalid vehicle response');
    return _map(raw);
  }

  @override
  Future<Vehicle> updateVehicle(
    int id, {
    required String plate,
    required String brand,
    required String model,
    required double capacity,
  }) async {
    final raw = await api.updateVehicle(id, {
      'licensePlate': plate,
      'brand': brand,
      'model': model,
      'capacity': capacity,
      'unit': 'LITERS',
      'status': 'AVAILABLE',
    });
    if (raw is! Map) throw const FormatException('Invalid vehicle response');
    return _map(raw);
  }

  @override
  Future<void> deleteVehicle(int id) async {
    await api.deactivateVehicle(id);
  }

  @override
  Future<List<Driver>> drivers() async {
    final raw = await api.drivers();
    return raw is List
        ? raw.whereType<Map>().map(_mapDriver).toList()
        : const [];
  }

  @override
  Future<Driver> createDriver(Driver driver) async {
    final raw = await api.createDriver(_driverBody(driver));
    if (raw is! Map) throw const FormatException('Invalid driver response');
    return _mapDriver(raw);
  }

  @override
  Future<Driver> updateDriver(Driver driver) async {
    final raw = await api.updateDriver(driver.id, _driverBody(driver));
    if (raw is! Map) throw const FormatException('Invalid driver response');
    return _mapDriver(raw);
  }

  @override
  Future<void> deleteDriver(int id) async {
    await api.deactivateDriver(id);
  }

  @override
  Future<String> createDelivery({
    required int orderId,
    required int driverId,
    required int tankerId,
    required DateTime scheduledDate,
    required String commandId,
    required DateTime windowStart,
    required DateTime windowEnd,
    required String notes,
  }) async {
    final raw = await api.createDelivery({
      'orderId': orderId,
      'commandId': commandId,
      'driverId': driverId,
      'tankerId': tankerId,
      'windowStart': windowStart.toIso8601String(),
      'windowEnd': windowEnd.toIso8601String(),
      'scheduledDate': scheduledDate.toIso8601String().substring(0, 10),
      'notes': notes,
    });
    final id = raw is Map ? raw['deliveryId'] ?? raw['id'] : null;
    if (id == null || '$id'.isEmpty) {
      throw const FormatException('Invalid delivery assignment response');
    }
    return '$id';
  }

  Map<String, dynamic> _driverBody(Driver driver) => {
    'firstName': driver.firstName,
    'lastName': driver.lastName,
    'licenseNumber': driver.licenseNumber,
    'phoneNumber': driver.phoneNumber,
    'email': driver.email,
    'status': driver.status,
  };
  Driver _mapDriver(Map raw) => Driver(
    id: raw['id'] is num ? (raw['id'] as num).toInt() : 0,
    firstName: '${raw['firstName'] ?? ''}',
    lastName: '${raw['lastName'] ?? ''}',
    licenseNumber: '${raw['licenseNumber'] ?? ''}',
    phoneNumber: '${raw['phoneNumber'] ?? ''}',
    email: '${raw['email'] ?? ''}',
    status: '${raw['status'] ?? 'AVAILABLE'}',
  );
  Vehicle _map(Map raw) => Vehicle(
    id: raw['id'] is num ? (raw['id'] as num).toInt() : 0,
    plate: '${raw['licensePlate'] ?? raw['plate'] ?? ''}',
    type: '${raw['brand'] ?? ''} ${raw['model'] ?? raw['type'] ?? ''}'.trim(),
    brand: '${raw['brand'] ?? ''}',
    model: '${raw['model'] ?? ''}',
    capacity: raw['capacity'] is num
        ? (raw['capacity'] as num).toDouble()
        : double.tryParse('${raw['capacity']}') ?? 0,
    status: '${raw['status'] ?? 'AVAILABLE'}',
  );
}
