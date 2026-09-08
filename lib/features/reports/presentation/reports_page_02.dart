part of 'reports_page.dart';

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.detail,
  });

  final String label;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) => Container(
    height: 86,
    padding: const EdgeInsets.fromLTRB(13, 13, 7, 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      boxShadow: const [
        BoxShadow(
          color: Color(0x10000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: FullTankColors.inkMid,
            fontSize: 6,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: FullTankColors.navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              detail,
              style: const TextStyle(color: FullTankColors.inkMid, fontSize: 6),
            ),
          ],
        ),
      ],
    ),
  );
}

class _CurrentPeriodCard extends StatelessWidget {
  const _CurrentPeriodCard();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      boxShadow: const [
        BoxShadow(
          color: Color(0x10000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PERÍODO ACTUAL',
          style: TextStyle(
            color: FullTankColors.inkMid,
            fontSize: 7,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Text(
              '\$31.200',
              style: TextStyle(
                color: FullTankColors.navy,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              ' K',
              style: TextStyle(color: FullTankColors.inkMid, fontSize: 8),
            ),
            SizedBox(width: 10),
            _DeltaBadge('+16%'),
          ],
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'vs. anterior',
              style: TextStyle(color: FullTankColors.inkMid, fontSize: 7.5),
            ),
            Text(
              '\$27.000K',
              style: TextStyle(
                color: FullTankColors.navyMid,
                fontSize: 7.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _Segmented extends StatelessWidget {
  const _Segmented({required this.items, this.selected = 0});

  final List<String> items;
  final int selected;

  @override
  Widget build(BuildContext context) => Container(
    height: 38,
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: FullTankColors.card,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      children: List.generate(
        items.length,
        (index) => Expanded(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: index == selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(99),
              boxShadow: index == selected
                  ? const [BoxShadow(color: Color(0x10000000), blurRadius: 3)]
                  : null,
            ),
            child: Text(
              items[index],
              style: TextStyle(
                color: FullTankColors.navyMid,
                fontSize: 8,
                fontWeight: index == selected
                    ? FontWeight.w800
                    : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

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

class _ConsumptionChart extends StatelessWidget {
  const _ConsumptionChart();
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _LineChartPainter(), child: const SizedBox.expand());
}

class _SalesChart extends StatelessWidget {
  const _SalesChart();
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _BarChartPainter(), child: const SizedBox.expand());
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final left = size.width * .1;
    final right = size.width * .97;
    final top = size.height * .16;
    final bottom = size.height * .76;
    final step = (right - left) / 5;
    final values = [.62, .38, .5, .25, .36, .08];
    final points = [
      for (var i = 0; i < values.length; i++)
        Offset(left + i * step, top + values[i] * (bottom - top)),
    ];
    final grid = Paint()
      ..color = FullTankColors.line
      ..strokeWidth = 1;
    for (final y in [top, (top + bottom) / 2, bottom])
      canvas.drawLine(Offset(left, y), Offset(right, y), grid);
    final area = Path()..moveTo(points.first.dx, bottom);
    for (final point in points) area.lineTo(point.dx, point.dy);
    area.lineTo(points.last.dx, bottom);
    canvas.drawPath(area, Paint()..color = FullTankColors.blueSoft);
    final line = Paint()
      ..color = FullTankColors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) path.lineTo(point.dx, point.dy);
    canvas.drawPath(path, line);
    for (final point in points)
      canvas.drawCircle(point, 2, Paint()..color = Colors.white);
    for (var i = 0; i < 6; i++)
      _drawText(
        canvas,
        ['MAR', 'ABR', 'MAY', 'JUN', 'JUL', 'AGO'][i],
        Offset(left - 5 + i * step, bottom + 10),
        i == 5 ? FullTankColors.navy : FullTankColors.inkSoft,
        6,
      );
    _drawText(
      canvas,
      '74.0k L',
      Offset(points.last.dx - 26, points.last.dy - 17),
      Colors.white,
      6,
      background: FullTankColors.navy,
    );
    _drawText(canvas, '74k', Offset(0, top - 4), FullTankColors.inkSoft, 6);
    _drawText(
      canvas,
      '37k',
      Offset(0, (top + bottom) / 2 - 4),
      FullTankColors.inkSoft,
      6,
    );
    _drawText(
      canvas,
      '0',
      Offset(left - 2, bottom - 8),
      FullTankColors.inkSoft,
      6,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
