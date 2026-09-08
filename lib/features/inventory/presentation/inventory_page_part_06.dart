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
        minHeight: 6 * _uiScale,
        value: value,
        backgroundColor: FullTankColors.line,
        valueColor: AlwaysStoppedAnimation(_statusColor(status)),
      ),
    );
  }
}

class _LivePill extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: 10 * _uiScale,
      vertical: 5 * _uiScale,
    ),
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
            fontSize: 10.5,
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
    padding: EdgeInsets.fromLTRB(
      16 * _uiScale,
      20 * _uiScale,
      16 * _uiScale,
      18 * _uiScale,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: FullTankColors.line),
      borderRadius: BorderRadius.circular(8 * _uiScale),
    ),
    child: Column(
      children: [
        SizedBox.square(
          dimension: 200 * _uiScale,
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
                        color: FullTankColors.navy,
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.5,
                      ),
                      children: const [
                        TextSpan(
                          text: '%',
                          style: TextStyle(
                            color: FullTankColors.inkSoft,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'CURRENT LEVEL',
                    style: TextStyle(
                      color: FullTankColors.inkMid,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: .8,
                    ),
                  ),
                  SizedBox(height: 6 * _uiScale),
                  _StatusPill(status: status),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16 * _uiScale),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _GaugeMetric(label: 'Current', value: tank.current),
            Container(
              width: 1,
              height: 36 * _uiScale,
              color: FullTankColors.line,
            ),
            _GaugeMetric(label: 'Capacity', value: tank.capacity),
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
          color: FullTankColors.inkMid,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: .5,
        ),
      ),
      Text.rich(
        TextSpan(
          text: _liters(value),
          style: const TextStyle(
            color: FullTankColors.navy,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          children: const [
            TextSpan(
              text: ' L',
              style: TextStyle(
                color: FullTankColors.inkSoft,
                fontSize: 11,
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
    final radius = size.shortestSide / 2 - 16 * _uiScale;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final track = Paint()
      ..color = FullTankColors.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12 * _uiScale
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12 * _uiScale
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
