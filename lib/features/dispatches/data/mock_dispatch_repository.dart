import '../domain/dispatch_repository.dart';
import '../domain/vehicle.dart';

class MockDispatchRepository implements DispatchRepository {
  static const _vehicles = [
    Vehicle(id: 1, plate: 'ABC-921', type: 'Cisterna 12.000 L'),
    Vehicle(id: 2, plate: 'MNO-442', type: 'Cisterna 8.000 L'),
  ];

  @override
  Future<List<Vehicle>> vehicles() async => _vehicles;

  @override
  Future<Vehicle> createVehicle(String plate, String type) async =>
      Vehicle(id: 99, plate: plate, type: type);

  @override
  Future<void> deleteVehicle(int id) async {}
}
