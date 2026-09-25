part of 'reports_page.dart';

class _Segmented extends StatelessWidget {
  const _Segmented({required this.items, this.selected = 0});

  final List<String> items;
  final int selected;

  @override
  Widget build(BuildContext context) => Container(
    height: 38,
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Color(0xFFF3F4F6),
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
                color: Color(0xFF2D3748),
                fontSize: 11.6,
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
          color: Color(0xFF4A5568),
          fontSize: 11.6,
          fontWeight: FontWeight.w800,
        ),
      ),
      if (trailing.isNotEmpty)
        Row(
          children: [
            const Icon(Icons.remove, color: Color(0xFF1E40AF), size: 13),
            const SizedBox(width: 4),
            Text(
              trailing,
              style: const TextStyle(color: Color(0xFF4A5568), fontSize: 10.15),
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
      ..color = Color(0xFFE2E8F0)
      ..strokeWidth = 1;
    for (final y in [top, (top + bottom) / 2, bottom])
      canvas.drawLine(Offset(left, y), Offset(right, y), grid);
    final area = Path()..moveTo(points.first.dx, bottom);
    for (final point in points) area.lineTo(point.dx, point.dy);
    area.lineTo(points.last.dx, bottom);
    canvas.drawPath(area, Paint()..color = Color(0xFFEFF4FF));
    final line = Paint()
      ..color = Color(0xFF1E40AF)
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
        i == 5 ? Color(0xFF1A202C) : Color(0xFF94A3B8),
        6,
      );
    _drawText(
      canvas,
      '74.0k L',
      Offset(points.last.dx - 26, points.last.dy - 17),
      Colors.white,
      6,
      background: Color(0xFF1A202C),
    );
    _drawText(canvas, '74k', Offset(0, top - 4), Color(0xFF94A3B8), 6);
    _drawText(
      canvas,
      '37k',
      Offset(0, (top + bottom) / 2 - 4),
      Color(0xFF94A3B8),
      6,
    );
    _drawText(canvas, '0', Offset(left - 2, bottom - 8), Color(0xFF94A3B8), 6);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
