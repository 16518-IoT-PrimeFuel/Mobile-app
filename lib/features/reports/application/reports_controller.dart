import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/report.dart';
import 'reports_providers.dart';

final reportsControllerProvider = FutureProvider<ReportSummary>(
  (ref) => ref.watch(reportsRepositoryProvider).summary(),
);
