import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/storage/token_storage.dart';
import '../../../data/api_client.dart';
import '../../../data/auth/auth_api_repository.dart';
import '../../../data/auth/mock_auth_repository.dart';
import '../../../data/fulltank_api.dart';
import '../../../domain/auth/auth_repository.dart';
import 'auth_controller.dart';

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => const TokenStorage(FlutterSecureStorage()),
);

final fullTankApiProvider = Provider<FullTankApi>(
  (ref) => FullTankApi(ApiClient()),
);

const _useMockAuth = bool.fromEnvironment(
  'USE_MOCK_AUTH',
  defaultValue: true,
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(tokenStorageProvider);
  if (_useMockAuth) return MockAuthRepository(storage);
  return AuthApiRepository(
    api: ref.watch(fullTankApiProvider),
    storage: storage,
  );
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref.watch(authRepositoryProvider)),
);
