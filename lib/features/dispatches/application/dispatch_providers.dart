import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/application/auth_providers.dart';
import '../data/api_dispatch_repository.dart';
import '../data/mock_dispatch_repository.dart';
import '../domain/dispatch_repository.dart';

const _useMockDispatch = bool.fromEnvironment(
  'USE_MOCK_DISPATCH',
  defaultValue: true,
);

final dispatchRepositoryProvider = Provider<DispatchRepository>((ref) {
  if (_useMockDispatch) return MockDispatchRepository();
  return ApiDispatchRepository(ref.watch(fullTankApiProvider));
});
