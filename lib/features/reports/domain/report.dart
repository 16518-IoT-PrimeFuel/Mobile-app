class ReportSummary {
  const ReportSummary({
    required this.revenue,
    required this.liters,
    required this.orders,
    this.confirmedOrders = 0,
    this.monthly = const [],
  });

  final double revenue;
  final double liters;
  final int orders;
  final int confirmedOrders;
  final List<MonthlyReportValue> monthly;
}

class MonthlyReportValue {
  const MonthlyReportValue({required this.month, required this.amount});

  final String month;
  final double amount;
}
