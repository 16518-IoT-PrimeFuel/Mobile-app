part of 'inventory_page.dart';

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    this.unit,
    this.status = _TankStatus.optimal,
    this.trend,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? unit;
  final _TankStatus status;
  final String? trend;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(17.4),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Color(0xFFE2E8F0)),
      borderRadius: BorderRadius.circular(11.6),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 43.5,
              height: 43.5,
              decoration: BoxDecoration(
                color: _statusSoft(status),
                borderRadius: BorderRadius.circular(11.6),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 26.1, color: _statusColor(status)),
            ),
            if (trend != null)
              Text(
                trend!,
                style: TextStyle(
                  color: _statusColor(status),
                  fontSize: 15.95,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        const Spacer(),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF4A5568),
            fontSize: 15.225,
            fontWeight: FontWeight.w600,
            letterSpacing: .5,
          ),
        ),
        Text.rich(
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Color(0xFF1A202C),
              fontSize: 29.0,
              fontWeight: FontWeight.w800,
              letterSpacing: -.4,
            ),
            children: [
              if (unit != null)
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 15.95,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SensorCard extends StatelessWidget {
  const _SensorCard({required this.tank});
  final TankData tank;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(17.4),
    decoration: BoxDecoration(
      color: Color(0xFFF3F4F6),
      borderRadius: BorderRadius.circular(11.6),
    ),
    child: Row(
      children: [
        Container(
          width: 46.4,
          height: 46.4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11.6),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.wifi_tethering, color: Color(0xFF1E40AF)),
        ),
        SizedBox(width: 14.5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('SENSOR', style: _metaLabelStyle),
              Text(
                tank.sensor,
                style: const TextStyle(
                  color: Color(0xFF1A202C),
                  fontSize: 18.85,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('ÚLTIMA ACTUALIZACIÓN', style: _metaLabelStyle),
            Text(
              tank.updated,
              style: const TextStyle(
                color: Color(0xFF1A202C),
                fontSize: 17.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

const _metaLabelStyle = TextStyle(
  color: Color(0xFF4A5568),
  fontSize: 14.5,
  fontWeight: FontWeight.w600,
  letterSpacing: .4,
);

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status, this.compact = false});
  final _TankStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: compact ? 8 : 14.5,
      vertical: compact ? 3 : 7.25,
    ),
    decoration: BoxDecoration(
      color: _statusSoft(status),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.circle,
          size: compact ? 6 : 8.7,
          color: _statusColor(status),
        ),
        SizedBox(width: compact ? 5 : 7.25),
        Text(
          _statusLabel(status),
          style: TextStyle(
            color: _statusColor(status),
            fontSize: compact ? 11 : 15.95,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
