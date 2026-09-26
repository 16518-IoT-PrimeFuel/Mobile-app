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
      'fuelType': product.type,
      'pricePerUnit': product.price,
      'unit': product.unit,
      'availableStock': product.availableStock,
      'capacity': product.capacity,
      'active': product.active && product.availability != ProductAvailability.inactive,
    });
    return raw is Map ? _map(raw) : product;
  }

  @override
  Future<void> delete(int id) => api.deleteFuelProduct(id);

  FuelProduct _map(Map raw) => FuelProduct(
    id: raw['id'] is num ? (raw['id'] as num).toInt() : 0,
    name: '${raw['name'] ?? raw['fuelName'] ?? ''}',
    type: '${raw['type'] ?? raw['fuelType'] ?? ''}',
    price: raw['pricePerUnit'] is num
        ? (raw['pricePerUnit'] as num).toDouble()
        : raw['price'] is num
        ? (raw['price'] as num).toDouble()
        : 0,
    availability: _availability(raw),
    unit: '${raw['unit'] ?? 'L'}',
    availableStock: raw['availableStock'] is num
        ? (raw['availableStock'] as num).toDouble()
        : 0,
    capacity: raw['capacity'] is num ? (raw['capacity'] as num).toDouble() : 0,
    providerId: raw['providerId'] is num ? (raw['providerId'] as num).toInt() : null,
    active: raw['active'] != false,
  );

  ProductAvailability _availability(Map raw) {
    if (raw['active'] == false) return ProductAvailability.inactive;
    final stock = raw['availableStock'];
    final capacity = raw['capacity'];
    if (stock is num && capacity is num && capacity > 0 && stock / capacity <= .2) {
      return ProductAvailability.lowStock;
    }
    return switch ('${raw['availability'] ?? 'available'}'.toLowerCase()) {
      'low_stock' || 'lowstock' => ProductAvailability.lowStock,
      'inactive' => ProductAvailability.inactive,
      _ => ProductAvailability.available,
    };
  }
}
