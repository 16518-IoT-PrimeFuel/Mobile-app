import '../domain/report.dart';
import '../domain/reports_repository.dart';

class MockReportsRepository implements ReportsRepository {
  @override
  Future<ReportSummary> summary() async =>
      const ReportSummary(revenue: 31200, liters: 1240000, orders: 318);
}
