part of 'reports_page.dart';

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: FullTankColors.inkMid,
          fontSize: 5.5,
          fontWeight: FontWeight.w800,
        ),
      ),
      Text(
        value,
        style: const TextStyle(
          color: FullTankColors.navy,
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton({required this.summary});
  final ReportSummary summary;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () async {
      final rows = [
        'metric,value',
        'revenue,${summary.revenue}',
        'liters,${summary.liters}',
        'orders,${summary.orders}',
        'confirmed_orders,${summary.confirmedOrders}',
        ...summary.monthly.map((item) => '${item.month},${item.amount}'),
      ];
      await Clipboard.setData(ClipboardData(text: rows.join('\n')));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CSV copiado al portapapeles')),
        );
      }
    },
    child: Container(
      height: 46,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [FullTankColors.ctaFrom, FullTankColors.ctaTo],
        ),
        borderRadius: BorderRadius.circular(99),
        boxShadow: const [
          BoxShadow(
            color: Color(0x44FFA500),
            blurRadius: 14,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.download_outlined, size: 14, color: Colors.white),
          SizedBox(width: 6),
          Text(
            'Copiar reporte CSV',
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    ),
  );
}
