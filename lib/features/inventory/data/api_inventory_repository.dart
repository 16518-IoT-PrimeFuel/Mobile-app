import '../../../data/fulltank_api.dart';
import '../domain/fuel_product.dart';
import '../domain/inventory_repository.dart';

class ApiInventoryRepository implements InventoryRepository {
  const ApiInventoryRepository(this.api);

  final FullTankApi api;

  @override
  Future<List<FuelProduct>> list() async {
    final raw = await api.fuelProducts();
    if (raw is! List) return const [];
    return raw.whereType<Map>().map(_map).toList();
  }

  @override
  Future<FuelProduct> save(FuelProduct product) async {
    final raw = await api.updateFuelProduct(product.id, {
      'name': product.name,
      'type': product.type,
      'price': product.price,
      'availability': product.availability.name,
    });
    return raw is Map ? _map(raw) : product;
  }

  @override
  Future<void> delete(int id) => api.deleteFuelProduct(id);

  FuelProduct _map(Map raw) => FuelProduct(
    id: raw['id'] is num ? (raw['id'] as num).toInt() : 0,
    name: '${raw['name'] ?? raw['fuelName'] ?? ''}',
    type: '${raw['type'] ?? raw['fuelType'] ?? ''}',
    price: raw['price'] is num ? (raw['price'] as num).toDouble() : 0,
    availability: switch ('${raw['availability'] ?? 'available'}'
        .toLowerCase()) {
      'low_stock' || 'lowstock' => ProductAvailability.lowStock,
      'inactive' => ProductAvailability.inactive,
      _ => ProductAvailability.available,
    },
  );
}
