import '../../../data/fulltank_api.dart';
import '../domain/fuel_product.dart';
import '../domain/inventory_repository.dart';
import '../domain/equipment.dart';

class ApiInventoryRepository implements InventoryRepository {
  const ApiInventoryRepository(
    this.api, {
    required this.companyId,
    required this.providerId,
  });

  final FullTankApi api;
  final int? companyId;
  final int? providerId;

  @override
  Future<List<FuelProduct>> list() async {
    final raw = await api.fuelProducts(providerId: providerId);
    if (raw is! List) return const [];
    return raw.whereType<Map>().map(_map).toList();
  }

  @override
  Future<List<Equipment>> equipment({int? companyId}) async {
    final id = companyId ?? this.companyId;
    if (id == null) return const [];
    final raw = await api.equipment(companyId: id);
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(
          (item) => Equipment(
            id: _number(item['id']).toInt(),
            name: '${item['name'] ?? item['equipmentType'] ?? 'Equipo'}',
            fuelType: '${item['fuelType'] ?? ''}',
            capacity: _number(item['tankCapacity']),
            currentLevel: _number(item['currentLevel']),
            location: '${item['location'] ?? ''}',
          ),
        )
        .toList();
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
      'active': product.availability != ProductAvailability.inactive,
    });
    return raw is Map ? _map(raw) : product;
  }

  @override
  Future<void> delete(int id) => api.deleteFuelProduct(id);

  FuelProduct _map(Map raw) => FuelProduct(
    id: raw['id'] is num ? (raw['id'] as num).toInt() : 0,
    name: '${raw['name'] ?? raw['fuelName'] ?? ''}',
    type: '${raw['fuelType'] ?? raw['type'] ?? ''}',
    price: _number(raw['pricePerUnit'] ?? raw['price']),
    unit: '${raw['unit'] ?? 'LITERS'}',
    availableStock: raw['availableStock'] == null
        ? null
        : _number(raw['availableStock']),
    capacity: raw['capacity'] == null ? null : _number(raw['capacity']),
    providerId: raw['providerId'] is num
        ? (raw['providerId'] as num).toInt()
        : null,
    // ponytail: use 10% as the low-stock threshold until products define their own reorder level.
    availability: raw['active'] == false
        ? ProductAvailability.inactive
        : raw['availableStock'] is num &&
              raw['capacity'] is num &&
              (raw['availableStock'] as num) <= (raw['capacity'] as num) * .1
        ? ProductAvailability.lowStock
        : ProductAvailability.available,
  );

  double _number(Object? value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
}
