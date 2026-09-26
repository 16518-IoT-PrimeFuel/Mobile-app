import 'fuel_product.dart';
import 'tank.dart';

abstract interface class InventoryRepository {
  Future<List<FuelProduct>> list();
  Future<FuelProduct> save(FuelProduct product);
  Future<void> delete(int id);
  Future<List<Tank>> listTanks({required int companyId, required int siteId});
  Future<Tank?> tank({
    required int companyId,
    required int siteId,
    required String id,
  });
}
