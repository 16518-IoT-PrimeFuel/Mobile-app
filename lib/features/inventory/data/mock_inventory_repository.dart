import '../domain/fuel_product.dart';
import '../domain/inventory_repository.dart';
import '../domain/equipment.dart';

class MockInventoryRepository implements InventoryRepository {
  static const _products = [
    FuelProduct(
      id: 1,
      name: 'Diesel B5',
      type: 'DIESEL',
      price: 24.10,
      availability: ProductAvailability.available,
      unit: 'LITERS',
      availableStock: 12000,
      capacity: 18000,
      providerId: 1,
    ),
    FuelProduct(
      id: 2,
      name: 'Diesel Premium',
      type: 'DIESEL',
      price: 25.80,
      availability: ProductAvailability.available,
      unit: 'LITERS',
      availableStock: 8000,
      capacity: 18000,
      providerId: 1,
    ),
    FuelProduct(
      id: 3,
      name: 'Gasoline 95',
      type: 'GASOLINE',
      price: 24.90,
      availability: ProductAvailability.lowStock,
      unit: 'LITERS',
      availableStock: 500,
      capacity: 10000,
      providerId: 1,
    ),
  ];

  @override
  Future<List<FuelProduct>> list() async => _products;

  @override
  Future<List<Equipment>> equipment({int? companyId}) async => const [
    Equipment(
      id: 1,
      name: 'Diesel Tank A-102',
      fuelType: 'DIESEL',
      capacity: 12000,
      currentLevel: 1440,
      location: 'North Yard · Sector 4',
    ),
    Equipment(
      id: 2,
      name: 'Water Tank B-05',
      fuelType: 'COOLANT',
      capacity: 50000,
      currentLevel: 42000,
      location: 'Sector 1',
    ),
    Equipment(
      id: 3,
      name: 'Lube Tank C-12',
      fuelType: 'LUBRICANT',
      capacity: 8000,
      currentLevel: 2800,
      location: 'Sector 9',
    ),
    Equipment(
      id: 4,
      name: 'Diesel Tank A-204',
      fuelType: 'DIESEL',
      capacity: 15000,
      currentLevel: 10800,
      location: 'North Yard · Sector 4',
    ),
    Equipment(
      id: 5,
      name: 'Propane G-11',
      fuelType: 'PROPANE',
      capacity: 6000,
      currentLevel: 1080,
      location: 'Sector 6',
    ),
    Equipment(
      id: 6,
      name: 'Hydraulic D-4',
      fuelType: 'HYDRAULIC',
      capacity: 4000,
      currentLevel: 2320,
      location: 'Sector 2',
    ),
  ];

  @override
  Future<FuelProduct> save(FuelProduct product) async => product;

  @override
  Future<void> delete(int id) async {}
}
