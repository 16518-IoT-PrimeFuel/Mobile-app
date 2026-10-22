import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/application/auth_providers.dart';
import '../data/api_dispatch_repository.dart';
import '../data/mock_dispatch_repository.dart';
import '../domain/dispatch_repository.dart';
import '../domain/driver.dart';

const _useMockDispatch = bool.fromEnvironment(
  'USE_MOCK_DISPATCH',
  defaultValue: false,
);

final dispatchRepositoryProvider = Provider<DispatchRepository>((ref) {
  if (_useMockDispatch) return MockDispatchRepository();
  final session = ref.watch(authControllerProvider).session;
  return ApiDispatchRepository(
    ref.watch(fullTankApiProvider),
    providerId: session?.providerId,
  );
});

final dispatchDriversProvider = FutureProvider<List<Driver>>(
  (ref) => ref.watch(dispatchRepositoryProvider).drivers(),
);
