import '../domain/fuel_product.dart';
import '../domain/inventory_repository.dart';
import '../domain/tank.dart';

class MockInventoryRepository implements InventoryRepository {
  static const _products = [
    FuelProduct(
      id: 1,
      name: 'Diesel B5',
      type: 'DIESEL',
      price: 24.10,
      availability: ProductAvailability.available,
    ),
    FuelProduct(
      id: 2,
      name: 'Diesel Premium',
      type: 'DIESEL',
      price: 25.80,
      availability: ProductAvailability.available,
    ),
    FuelProduct(
      id: 3,
      name: 'Gasoline 95',
      type: 'GASOLINE',
      price: 24.90,
      availability: ProductAvailability.lowStock,
    ),
  ];

  @override
  Future<List<FuelProduct>> list() async => _products;

  @override
  Future<FuelProduct> save(FuelProduct product) async => product;

  @override
  Future<void> delete(int id) async {}

  @override
  Future<List<Tank>> listTanks({
    required int companyId,
    required int siteId,
  }) async => _tanks;

  @override
  Future<Tank?> tank({
    required int companyId,
    required int siteId,
    required String id,
  }) async => _tanks.where((tank) => tank.id == id).firstOrNull;

  static const _tanks = [
    Tank(
      id: 'A-102',
      siteId: 1,
      name: 'Tanque diésel A-102',
      fuelType: 'Diésel',
      capacity: 12000,
      unit: 'L',
      currentLevel: 1440,
      status: 'CRITICAL',
      lastReadingAt: null,
    ),
    Tank(
      id: 'B-05',
      siteId: 1,
      name: 'Tanque de agua B-05',
      fuelType: 'Refrigerante',
      capacity: 50000,
      unit: 'L',
      currentLevel: 42000,
      status: 'OPTIMAL',
      lastReadingAt: null,
    ),
    Tank(
      id: 'C-12',
      siteId: 1,
      name: 'Tanque de lubricante C-12',
      fuelType: 'Lubricante',
      capacity: 8000,
      unit: 'L',
      currentLevel: 2800,
      status: 'WARNING',
      lastReadingAt: null,
    ),
    Tank(
      id: 'A-204',
      siteId: 1,
      name: 'Tanque diésel A-204',
      fuelType: 'Diésel',
      capacity: 15000,
      unit: 'L',
      currentLevel: 10800,
      status: 'OPTIMAL',
      lastReadingAt: null,
    ),
    Tank(
      id: 'G-11',
      siteId: 1,
      name: 'Propano G-11',
      fuelType: 'Propano',
      capacity: 6000,
      unit: 'L',
      currentLevel: 1080,
      status: 'CRITICAL',
      lastReadingAt: null,
    ),
    Tank(
      id: 'D-4',
      siteId: 1,
      name: 'Hidráulico D-4',
      fuelType: 'Hidráulico',
      capacity: 4000,
      unit: 'L',
      currentLevel: 2320,
      status: 'OPTIMAL',
      lastReadingAt: null,
    ),
  ];
}
