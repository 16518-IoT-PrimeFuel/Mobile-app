import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/application/auth_providers.dart';
import '../data/api_inventory_repository.dart';
import '../data/mock_inventory_repository.dart';
import '../domain/inventory_repository.dart';
import '../domain/tank.dart';
import '../../orders/data/replenishment_options_repository.dart';

const _useMockInventory = bool.fromEnvironment(
  'USE_MOCK_INVENTORY',
  defaultValue: false,
);

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final session = ref.watch(authControllerProvider).session;
  if (_useMockInventory || session?.token == 'guest')
    return MockInventoryRepository();
  return ApiInventoryRepository(
    ref.watch(fullTankApiProvider),
    providerId: session?.providerId,
  );
});

final inventoryPreviewProvider = Provider<bool>(
  (ref) => ref.watch(inventoryRepositoryProvider) is MockInventoryRepository,
);

final _inventoryScopeProvider = FutureProvider<({int companyId, int siteId})>((
  ref,
) async {
  final session = ref.watch(authControllerProvider).session;
  final companyId = session?.companyId;
  if (companyId == null)
    throw StateError('Inicia sesión con una cuenta de comprador activa.');
  final options = await ApiReplenishmentOptionsRepository(
    ref.watch(fullTankApiProvider),
  ).load(companyId: companyId, memberships: session!.memberships);
  if (options.customerAccountId == null)
    throw StateError(options.unavailableReason ?? 'Cuenta no disponible.');
  if (options.sites.length != 1) {
    throw StateError(
      'Selecciona un sitio único antes de consultar el inventario.',
    );
  }
  return (companyId: companyId, siteId: options.sites.single.id);
});

final inventoryTanksProvider = FutureProvider<List<Tank>>((ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  if (ref.watch(inventoryPreviewProvider)) {
    return repository.listTanks(companyId: 0, siteId: 0);
  }
  final scope = await ref.watch(_inventoryScopeProvider.future);
  return repository.listTanks(companyId: scope.companyId, siteId: scope.siteId);
});

final inventoryTankProvider = FutureProvider.family<Tank?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  if (ref.watch(inventoryPreviewProvider)) {
    return repository.tank(companyId: 0, siteId: 0, id: id);
  }
  final scope = await ref.watch(_inventoryScopeProvider.future);
  return repository.tank(
    companyId: scope.companyId,
    siteId: scope.siteId,
    id: id,
  );
});
