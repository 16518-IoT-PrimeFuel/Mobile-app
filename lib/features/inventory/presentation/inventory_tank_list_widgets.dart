part of 'inventory_page.dart';

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onPressed,
    this.status,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onPressed;
  final _TankStatus? status;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(right: 8.7),
    child: Semantics(
      button: true,
      selected: selected,
      label: '$label, $count',
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 17.4, vertical: 10.15),
          backgroundColor: selected ? Color(0xFF1A202C) : Color(0xFFF3F4F6),
          foregroundColor: selected ? Colors.white : Color(0xFF1A202C),
          shape: const StadiumBorder(),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (status != null) ...[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _statusColor(status!),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 17.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '$count',
              style: TextStyle(
                color: selected ? Colors.white70 : Color(0xFF94A3B8),
                fontSize: 15.95,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _TankRow extends StatelessWidget {
  const _TankRow({required this.tank});

  final TankData tank;

  @override
  Widget build(BuildContext context) {
    final status = _statusFor(tank.level);
    final color = _statusColor(status);
    return Semantics(
      button: true,
      label: '${tank.name}, ${tank.level} por ciento, ${_statusLabel(status)}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.go('/inventory/tank/${tank.id}'),
        child: Container(
          key: ValueKey('tank-${tank.id}'),
          padding: EdgeInsets.all(20.3),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(11.6),
          ),
          child: Row(
            children: [
              _TankIcon(status: status),
              SizedBox(width: 17.4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tank.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF1A202C),
                              fontSize: 20.3,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          '${tank.level}%',
                          style: TextStyle(
                            color: color,
                            fontSize: 20.3,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.9),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 20.3,
                          color: Color(0xFF4A5568),
                        ),
                        SizedBox(width: 5.8),
                        Expanded(
                          child: Text(
                            '${tank.location} · ${tank.type}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF4A5568),
                              fontSize: 15.95,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 11.6),
                    Row(
                      children: [
                        Expanded(child: _LevelBar(value: tank.level / 100)),
                        SizedBox(width: 11.6),
                        Icon(
                          Icons.wifi_tethering,
                          size: 18.85,
                          color: status == _TankStatus.critical
                              ? color
                              : Color(0xFF94A3B8),
                        ),
                        SizedBox(width: 4.35),
                        Text(
                          'EN VIVO',
                          style: TextStyle(
                            color: status == _TankStatus.critical
                                ? color
                                : Color(0xFF94A3B8),
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TankIcon extends StatelessWidget {
  const _TankIcon({required this.status});
  final _TankStatus status;

  @override
  Widget build(BuildContext context) => Container(
    width: 63.8,
    height: 63.8,
    decoration: BoxDecoration(
      color: _statusSoft(status),
      borderRadius: BorderRadius.circular(17.4),
    ),
    alignment: Alignment.center,
    child: Icon(
      Icons.local_gas_station_outlined,
      size: 29.0,
      color: _statusColor(status),
    ),
  );
}
