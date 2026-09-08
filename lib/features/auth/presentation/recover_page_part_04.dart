part of 'recover_page.dart';

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6EE7B7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 4;
    const segment = 0.22;
    const gap = 0.11;
    for (var start = 0.0; start < 6.283; start += segment + gap) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        segment,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
