import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/application/auth_providers.dart';
import '../data/api_inventory_repository.dart';
import '../data/mock_inventory_repository.dart';
import '../domain/inventory_repository.dart';

const _useMockInventory = bool.fromEnvironment(
  'USE_MOCK_INVENTORY',
  defaultValue: true,
);

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  if (_useMockInventory) return MockInventoryRepository();
  return ApiInventoryRepository(ref.watch(fullTankApiProvider));
});
