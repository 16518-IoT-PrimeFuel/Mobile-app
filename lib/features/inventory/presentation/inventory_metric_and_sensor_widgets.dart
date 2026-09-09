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
    padding: EdgeInsets.all(12 * _uiScale),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: FullTankColors.line),
      borderRadius: BorderRadius.circular(8 * _uiScale),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 30 * _uiScale,
              height: 30 * _uiScale,
              decoration: BoxDecoration(
                color: _statusSoft(status),
                borderRadius: BorderRadius.circular(8 * _uiScale),
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 18 * _uiScale,
                color: _statusColor(status),
              ),
            ),
            if (trend != null)
              Text(
                trend!,
                style: TextStyle(
                  color: _statusColor(status),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        const Spacer(),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: FullTankColors.inkMid,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            letterSpacing: .5,
          ),
        ),
        Text.rich(
          TextSpan(
            text: value,
            style: const TextStyle(
              color: FullTankColors.navy,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -.4,
            ),
            children: [
              if (unit != null)
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(
                    color: FullTankColors.inkSoft,
                    fontSize: 11,
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
    padding: EdgeInsets.all(12 * _uiScale),
    decoration: BoxDecoration(
      color: FullTankColors.card,
      borderRadius: BorderRadius.circular(8 * _uiScale),
    ),
    child: Row(
      children: [
        Container(
          width: 32 * _uiScale,
          height: 32 * _uiScale,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8 * _uiScale),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.wifi_tethering, color: FullTankColors.blue),
        ),
        SizedBox(width: 10 * _uiScale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('SENSOR', style: _metaLabelStyle),
              Text(
                tank.sensor,
                style: const TextStyle(
                  color: FullTankColors.navy,
                  fontSize: 13,
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
                color: FullTankColors.navy,
                fontSize: 12,
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
  color: FullTankColors.inkMid,
  fontSize: 10,
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
      horizontal: (compact ? 8 : 10) * (compact ? 1 : _uiScale),
      vertical: (compact ? 3 : 5) * (compact ? 1 : _uiScale),
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
          size: 6 * (compact ? 1 : _uiScale),
          color: _statusColor(status),
        ),
        SizedBox(width: 5 * (compact ? 1 : _uiScale)),
        Text(
          _statusLabel(status),
          style: TextStyle(
            color: _statusColor(status),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
