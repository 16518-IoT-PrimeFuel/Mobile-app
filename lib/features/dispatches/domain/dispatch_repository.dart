import 'vehicle.dart';

abstract interface class DispatchRepository {
  Future<List<Vehicle>> vehicles();
  Future<Vehicle> createVehicle(String plate, String type);
  Future<void> deleteVehicle(int id);
}
