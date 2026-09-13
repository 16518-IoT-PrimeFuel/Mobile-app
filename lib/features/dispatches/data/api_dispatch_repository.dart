import '../../../data/fulltank_api.dart';
import '../domain/dispatch_repository.dart';
import '../domain/vehicle.dart';
import '../domain/driver.dart';

class ApiDispatchRepository implements DispatchRepository {
  const ApiDispatchRepository(this.api, {required this.providerId});

  final FullTankApi api;
  final int? providerId;

  @override
  Future<List<Vehicle>> vehicles() async {
    final id = providerId;
    if (id == null) return const [];
    final raw = await api.vehicles(providerId: id);
    if (raw is! List) return const [];
    return raw.whereType<Map>().map(_map).toList();
  }

  @override
  Future<Vehicle> createVehicle({
    required String plate,
    required String brand,
    required String model,
    required double capacity,
  }) async {
    final id = providerId;
    if (id == null) throw StateError('Authenticated provider is required');
    final raw = await api.createVehicle({
      'providerId': id,
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
    final provider = providerId;
    if (provider == null)
      throw StateError('Authenticated provider is required');
    final raw = await api.updateVehicle(id, {
      'providerId': provider,
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
  Future<void> deleteVehicle(int id) => api.deleteVehicle(id);

  @override
  Future<List<Driver>> drivers() async {
    final id = providerId;
    if (id == null) return const [];
    final raw = await api.drivers(providerId: id);
    if (raw is! List) return const [];
    return raw.whereType<Map>().map(_mapDriver).toList();
  }

  @override
  Future<Driver> createDriver(Driver driver) async {
    final id = providerId;
    if (id == null) throw StateError('Authenticated provider is required');
    final raw = await api.createDriver(_driverBody(driver, id));
    if (raw is! Map) throw const FormatException('Invalid driver response');
    return _mapDriver(raw);
  }

  @override
  Future<Driver> updateDriver(Driver driver) async {
    if (providerId == null)
      throw StateError('Authenticated provider is required');
    final raw = await api.updateDriver(
      driver.id,
      _driverBody(driver, providerId!),
    );
    if (raw is! Map) throw const FormatException('Invalid driver response');
    return _mapDriver(raw);
  }

  @override
  Future<void> deleteDriver(int id) => api.deleteDriver(id);

  @override
  Future<void> createDelivery({
    required int orderId,
    required int driverId,
    required int vehicleId,
    required DateTime scheduledDate,
  }) async {
    final id = providerId;
    if (id == null) throw StateError('Authenticated provider is required');
    await api.createDelivery({
      'orderId': orderId,
      'providerId': id,
      'driverId': driverId,
      'vehicleId': vehicleId,
      'scheduledDate': scheduledDate.toIso8601String().substring(0, 10),
      'notes': '',
    });
  }

  Map<String, dynamic> _driverBody(Driver driver, int providerId) => {
    'providerId': providerId,
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
