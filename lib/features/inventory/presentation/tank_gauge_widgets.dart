part of 'inventory_page.dart';

class _LevelBar extends StatelessWidget {
  const _LevelBar({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    final status = _statusFor((value * 100).round());
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        minHeight: 8.7,
        value: value,
        backgroundColor: Color(0xFFE2E8F0),
        valueColor: AlwaysStoppedAnimation(_statusColor(status)),
      ),
    );
  }
}

class _LivePill extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 14.5, vertical: 7.25),
    decoration: BoxDecoration(
      color: _greenSoft,
      borderRadius: BorderRadius.circular(999),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 6, color: _green),
        SizedBox(width: 5),
        Text(
          'LIVE',
          style: TextStyle(
            color: _green,
            fontSize: 15.225,
            fontWeight: FontWeight.w700,
            letterSpacing: .4,
          ),
        ),
      ],
    ),
  );
}

class _GaugeCard extends StatelessWidget {
  const _GaugeCard({required this.tank, required this.status});
  final TankData tank;
  final _TankStatus status;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.fromLTRB(23.2, 29.0, 23.2, 26.1),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Color(0xFFE2E8F0)),
      borderRadius: BorderRadius.circular(11.6),
    ),
    child: Column(
      children: [
        SizedBox.square(
          dimension: 290.0,
          child: CustomPaint(
            painter: _GaugePainter(
              value: tank.level / 100,
              color: _statusColor(status),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      text: '${tank.level}',
                      style: const TextStyle(
                        color: Color(0xFF1A202C),
                        fontSize: 63.8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.5,
                      ),
                      children: const [
                        TextSpan(
                          text: '%',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 29.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'CURRENT LEVEL',
                    style: TextStyle(
                      color: Color(0xFF4A5568),
                      fontSize: 15.95,
                      fontWeight: FontWeight.w600,
                      letterSpacing: .8,
                    ),
                  ),
                  SizedBox(height: 8.7),
                  _StatusPill(status: status),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 23.2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _GaugeMetric(label: 'Actual', value: tank.current),
            Container(width: 1, height: 52.2, color: Color(0xFFE2E8F0)),
            _GaugeMetric(label: 'Capacidad', value: tank.capacity),
          ],
        ),
      ],
    ),
  );
}

class _GaugeMetric extends StatelessWidget {
  const _GaugeMetric({required this.label, required this.value});
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF4A5568),
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          letterSpacing: .5,
        ),
      ),
      Text.rich(
        TextSpan(
          text: _liters(value),
          style: const TextStyle(
            color: Color(0xFF1A202C),
            fontSize: 23.2,
            fontWeight: FontWeight.w800,
          ),
          children: const [
            TextSpan(
              text: ' L',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 15.95,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter({required this.value, required this.color});
  final double value;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 23.2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final track = Paint()
      ..color = Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 17.4
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 17.4
      ..strokeCap = StrokeCap.round;
    const start = 3 * 3.141592653589793 / 4;
    const sweep = 3 * 3.141592653589793 / 2;
    canvas.drawArc(rect, start, sweep, false, track);
    canvas.drawArc(rect, start, sweep * value, false, fill);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.color != color;
}
