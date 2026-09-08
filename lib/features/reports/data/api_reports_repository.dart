import '../../../data/fulltank_api.dart';
import '../domain/report.dart';
import '../domain/reports_repository.dart';

class ApiReportsRepository implements ReportsRepository {
  const ApiReportsRepository(this.api);

  final FullTankApi api;

  @override
  Future<ReportSummary> summary() async {
    final raw = await api.analyticsForProvider(1);
    if (raw is! Map) throw const FormatException('Invalid analytics response');
    return ReportSummary(
      revenue: _number(raw['revenue']),
      liters: _number(raw['liters'] ?? raw['volume']),
      orders: raw['orders'] is num ? (raw['orders'] as num).toInt() : 0,
    );
  }

  double _number(Object? value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
}
