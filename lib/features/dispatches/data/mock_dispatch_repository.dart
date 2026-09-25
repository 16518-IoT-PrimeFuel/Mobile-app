import '../domain/dispatch_repository.dart';
import '../domain/driver.dart';
import '../domain/vehicle.dart';

class MockDispatchRepository implements DispatchRepository {
  static const _vehicles = [
    Vehicle(id: 1, plate: 'ABC-921', type: 'Cisterna 12.000 L'),
    Vehicle(id: 2, plate: 'MNO-442', type: 'Cisterna 8.000 L'),
  ];

  @override
  Future<List<Vehicle>> vehicles() async => _vehicles;

  @override
  Future<Vehicle> createVehicle({
    required String plate,
    required String brand,
    required String model,
    required double capacity,
  }) async => Vehicle(
    id: 99,
    plate: plate,
    type: '$brand $model'.trim(),
    brand: brand,
    model: model,
    capacity: capacity,
  );

  @override
  Future<Vehicle> updateVehicle(
    int id, {
    required String plate,
    required String brand,
    required String model,
    required double capacity,
  }) async => Vehicle(
    id: id,
    plate: plate,
    type: '$brand $model'.trim(),
    brand: brand,
    model: model,
    capacity: capacity,
  );

  @override
  Future<void> deleteVehicle(int id) async {}

  @override
  Future<List<Driver>> drivers() async => const [];

  @override
  Future<Driver> createDriver(Driver driver) async => driver;

  @override
  Future<Driver> updateDriver(Driver driver) async => driver;

  @override
  Future<void> deleteDriver(int id) async {}

  @override
  Future<void> createDelivery({
    required int orderId,
    required int driverId,
    required int vehicleId,
    required DateTime scheduledDate,
  }) async {}
}
