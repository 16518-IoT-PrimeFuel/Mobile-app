part of 'reports_page.dart';

class _ChartHeading extends StatelessWidget {
  const _ChartHeading({required this.label, required this.trailing});

  final String label;
  final String trailing;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: FullTankColors.inkMid,
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
      if (trailing.isNotEmpty)
        Row(
          children: [
            const Icon(Icons.remove, color: FullTankColors.blue, size: 13),
            const SizedBox(width: 4),
            Text(
              trailing,
              style: const TextStyle(color: FullTankColors.inkMid, fontSize: 7),
            ),
          ],
        ),
    ],
  );
}

class _ChartBox extends StatelessWidget {
  const _ChartBox({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    height: 255,
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(13, 17, 13, 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Color(0x10000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}

class _SalesChart extends StatelessWidget {
  const _SalesChart({required this.monthly});
  final List<MonthlyReportValue> monthly;
  @override
  Widget build(BuildContext context) => monthly.isEmpty
      ? const Center(child: Text('Sin movimientos mensuales'))
      : CustomPaint(
          painter: _BarChartPainter(monthly),
          child: const SizedBox.expand(),
        );
}
