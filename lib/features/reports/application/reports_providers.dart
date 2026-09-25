import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/application/auth_providers.dart';
import '../data/api_reports_repository.dart';
import '../data/mock_reports_repository.dart';
import '../domain/reports_repository.dart';

const _useMockReports = bool.fromEnvironment(
  'USE_MOCK_REPORTS',
  defaultValue: true,
);

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  if (_useMockReports) return MockReportsRepository();
  return ApiReportsRepository(ref.watch(fullTankApiProvider));
});
