import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/application/auth_providers.dart';
import '../data/api_reports_repository.dart';
import '../data/mock_reports_repository.dart';
import '../domain/reports_repository.dart';

const _useMockReports = bool.fromEnvironment(
  'USE_MOCK_REPORTS',
  defaultValue: false,
);

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  if (_useMockReports) return MockReportsRepository();
  final session = ref.watch(authControllerProvider).session;
  final isProvider = session?.roles.contains('ROLE_PROVIDER') ?? false;
  return ApiReportsRepository(
    ref.watch(fullTankApiProvider),
    companyId: session?.companyId,
    providerId: session?.providerId,
    providerMode: isProvider,
  );
});
