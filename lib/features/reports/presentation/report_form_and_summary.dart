part of 'reports_page.dart';

class _BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final left = size.width * .1;
    final right = size.width * .97;
    final top = size.height * .15;
    final bottom = size.height * .68;
    final groupWidth = (right - left) / 6;
    final barWidth = groupWidth * .22;
    final grid = Paint()
      ..color = Color(0xFFE2E8F0)
      ..strokeWidth = 1;
    for (final y in [top, (top + bottom) / 2, bottom])
      canvas.drawLine(Offset(left, y), Offset(right, y), grid);
    const current = [22, 30, 17, 42, 53, 65];
    const previous = [18, 24, 20, 33, 43, 52];
    for (var i = 0; i < 6; i++) {
      final x = left + i * groupWidth + groupWidth * .24;
      final currentHeight = (bottom - top) * current[i] / 65;
      final previousHeight = (bottom - top) * previous[i] / 65;
      canvas.drawRect(
        Rect.fromLTWH(x, bottom - currentHeight, barWidth, currentHeight),
        Paint()..color = Color(0xFF1E40AF),
      );
      canvas.drawRect(
        Rect.fromLTWH(
          x + barWidth + 3,
          bottom - previousHeight,
          barWidth,
          previousHeight,
        ),
        Paint()..color = const Color(0xFFB7C2D4),
      );
      _drawText(
        canvas,
        ['MAR', 'ABR', 'MAY', 'JUN', 'JUL', 'AGO'][i],
        Offset(left + i * groupWidth + groupWidth * .13, bottom + 10),
        Color(0xFF94A3B8),
        6,
      );
    }
    _drawText(
      canvas,
      'Anterior',
      Offset(left, size.height - 18),
      Color(0xFF4A5568),
      6,
    );
    _drawText(
      canvas,
      'Actual',
      Offset(left + 42, size.height - 18),
      Color(0xFF4A5568),
      6,
    );
    canvas.drawRect(
      Rect.fromLTWH(left - 9, size.height - 20, 5, 5),
      Paint()..color = const Color(0xFFB7C2D4),
    );
    canvas.drawRect(
      Rect.fromLTWH(left + 33, size.height - 20, 5, 5),
      Paint()..color = Color(0xFF1E40AF),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void _drawText(
  Canvas canvas,
  String text,
  Offset offset,
  Color color,
  double size, {
  Color? background,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: size * 1.45,
        fontWeight: FontWeight.w700,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  if (background != null)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          offset.dx - 5.8,
          offset.dy - 4.35,
          painter.width + 8,
          painter.height + 6,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = background,
    );
  painter.paint(canvas, offset);
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: Color(0xFF4A5568),
      fontSize: 10.15,
      fontWeight: FontWeight.w800,
    ),
  );
}

class _SelectField extends StatelessWidget {
  const _SelectField(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    height: 38,
    margin: const EdgeInsets.only(top: 6),
    padding: const EdgeInsets.symmetric(horizontal: 13),
    decoration: BoxDecoration(
      color: Color(0xFFF3F4F6),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 11.6,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Icon(Icons.chevron_right, size: 13, color: Color(0xFF94A3B8)),
      ],
    ),
  );
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 6),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Color(0xFFEFF4FF),
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.description_outlined,
              color: Color(0xFF1E40AF),
              size: 14,
            ),
            SizedBox(width: 6),
            Text(
              'Reporte de ventas · AGO 2026',
              style: TextStyle(
                color: Color(0xFF1A202C),
                fontSize: 11.6,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        SizedBox(height: 2),
        Text(
          'PDF · A4 · 2 páginas · 980 KB',
          style: TextStyle(color: Color(0xFF4A5568), fontSize: 10.15),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _SummaryMetric('INGRESOS', '\$31.200K')),
            Expanded(child: _SummaryMetric('LITROS VENDIDOS', '1.240.000')),
            Expanded(child: _SummaryMetric('TICKET PROM.', '\$98.1K')),
          ],
        ),
      ],
    ),
  );
}
