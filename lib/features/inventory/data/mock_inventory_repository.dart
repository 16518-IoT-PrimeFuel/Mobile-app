import '../domain/fuel_product.dart';
import '../domain/inventory_repository.dart';

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
}
