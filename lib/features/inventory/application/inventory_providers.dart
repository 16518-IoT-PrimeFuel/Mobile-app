import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/application/auth_providers.dart';
import '../data/api_inventory_repository.dart';
import '../data/mock_inventory_repository.dart';
import '../domain/inventory_repository.dart';
import '../domain/tank.dart';

const _useMockInventory = bool.fromEnvironment(
  'USE_MOCK_INVENTORY',
  defaultValue: false,
);

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  if (_useMockInventory) return MockInventoryRepository();
  return ApiInventoryRepository(ref.watch(fullTankApiProvider));
});

const _companyId = int.fromEnvironment('BUYER_COMPANY_ID', defaultValue: 1);
const _siteId = int.fromEnvironment('SITE_ID', defaultValue: 1);

final inventoryTanksProvider = FutureProvider<List<Tank>>((ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  try {
    return await repository.listTanks(companyId: _companyId, siteId: _siteId);
  } catch (_) {
    return MockInventoryRepository().listTanks(
      companyId: _companyId,
      siteId: _siteId,
    );
  }
});

final inventoryTankProvider = FutureProvider.family<Tank?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  try {
    return await repository.tank(
      companyId: _companyId,
      siteId: _siteId,
      id: id,
    );
  } catch (_) {
    return MockInventoryRepository().tank(
      companyId: _companyId,
      siteId: _siteId,
      id: id,
    );
  }
});
