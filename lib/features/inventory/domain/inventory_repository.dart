import 'fuel_product.dart';
import 'equipment.dart';

abstract interface class InventoryRepository {
  Future<List<FuelProduct>> list();
  Future<List<Equipment>> equipment({int? companyId});
  Future<FuelProduct> save(FuelProduct product);
  Future<void> delete(int id);
}
