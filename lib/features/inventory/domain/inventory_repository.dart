import 'fuel_product.dart';

abstract interface class InventoryRepository {
  Future<List<FuelProduct>> list();
  Future<FuelProduct> save(FuelProduct product);
  Future<void> delete(int id);
}
