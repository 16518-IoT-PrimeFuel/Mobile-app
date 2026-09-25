import '../../../data/fulltank_api.dart';
import '../domain/report.dart';
import '../domain/reports_repository.dart';

class ApiReportsRepository implements ReportsRepository {
  const ApiReportsRepository(
    this.api, {
    this.providerId,
    this.companyId = 1,
    this.providerMode = false,
  });

  final FullTankApi api;
  final int? providerId;
  final int? companyId;
  final bool providerMode;

  @override
  Future<ReportSummary> summary() async {
    final id = providerMode ? providerId : companyId;
    if (id == null)
      throw StateError('Authenticated business account is required');
    final raw = providerMode
        ? await api.analyticsForProvider(id)
        : await api.analyticsForBuyer(id);
    if (raw is! Map) throw const FormatException('Invalid analytics response');
    final orderResponse = providerMode
        ? await api.providerOrders(id)
        : await api.orders(companyId: id);
    return ReportSummary(
      revenue: _number(
        raw['totalRevenue'] ?? raw['totalSpent'] ?? raw['revenue'],
      ),
      liters: orderResponse is List
          ? orderResponse.whereType<Map>().fold<double>(
              0,
              (sum, order) =>
                  sum +
                  _number(order['requestedQuantity'] ?? order['quantity']),
            )
          : _number(raw['liters'] ?? raw['volume']),
      orders: _number(raw['totalOrders'] ?? raw['orders']).toInt(),
      confirmedOrders: _number(
        raw['confirmedOrders'] ?? raw['completedPayments'],
      ).toInt(),
      monthly:
          (raw[providerMode ? 'monthlyRevenue' : 'monthlySpending'] is List)
          ? (raw[providerMode ? 'monthlyRevenue' : 'monthlySpending'] as List)
                .whereType<Map>()
                .map(
                  (item) => MonthlyReportValue(
                    month: '${item['month'] ?? ''}',
                    amount: _number(item['amount']),
                  ),
                )
                .toList()
          : const [],
    );
  }

  double _number(Object? value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
}
