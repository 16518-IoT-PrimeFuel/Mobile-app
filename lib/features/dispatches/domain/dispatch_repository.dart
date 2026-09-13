import 'vehicle.dart';
import 'driver.dart';

abstract interface class DispatchRepository {
  Future<List<Vehicle>> vehicles();
  Future<Vehicle> createVehicle({
    required String plate,
    required String brand,
    required String model,
    required double capacity,
  });
  Future<Vehicle> updateVehicle(
    int id, {
    required String plate,
    required String brand,
    required String model,
    required double capacity,
  });
  Future<void> deleteVehicle(int id);
  Future<List<Driver>> drivers();
  Future<Driver> createDriver(Driver driver);
  Future<Driver> updateDriver(Driver driver);
  Future<void> deleteDriver(int id);
  Future<void> createDelivery({
    required int orderId,
    required int driverId,
    required int vehicleId,
    required DateTime scheduledDate,
  });
}
