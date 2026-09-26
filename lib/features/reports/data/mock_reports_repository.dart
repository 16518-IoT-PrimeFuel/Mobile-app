import '../domain/report.dart';
import '../domain/reports_repository.dart';

class MockReportsRepository implements ReportsRepository {
  @override
  Future<ReportSummary> summary() async =>
      const ReportSummary(revenue: 31200, liters: 1240000, orders: 318);

  @override
  Future<String> exportCsv() async =>
      'report,metric,value\nsummary,revenue,31200\n';
}
