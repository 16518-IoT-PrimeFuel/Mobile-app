import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/application/auth_providers.dart';
import '../data/api_inventory_repository.dart';
import '../data/mock_inventory_repository.dart';
import '../domain/inventory_repository.dart';

const _useMockInventory = bool.fromEnvironment(
  'USE_MOCK_INVENTORY',
  defaultValue: false,
);

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  if (_useMockInventory) return MockInventoryRepository();
  return ApiInventoryRepository(
    ref.watch(fullTankApiProvider),
    companyId: ref.watch(authControllerProvider).session?.companyId,
    providerId:
        ref
                .watch(authControllerProvider)
                .session
                ?.roles
                .contains('ROLE_PROVIDER') ==
            true
        ? ref.watch(authControllerProvider).session?.providerId
        : null,
  );
});

final inventoryEquipmentProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(inventoryRepositoryProvider).equipment();
});
