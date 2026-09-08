import 'report.dart';

abstract interface class ReportsRepository {
  Future<ReportSummary> summary();
}
