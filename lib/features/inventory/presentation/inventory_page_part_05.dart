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
    padding: EdgeInsets.only(right: 6 * _uiScale),
    child: Semantics(
      button: true,
      selected: selected,
      label: '$label, $count',
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: 12 * _uiScale,
            vertical: 7 * _uiScale,
          ),
          backgroundColor: selected ? FullTankColors.navy : FullTankColors.card,
          foregroundColor: selected ? Colors.white : FullTankColors.navy,
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
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 6),
            Text(
              '$count',
              style: TextStyle(
                color: selected ? Colors.white70 : FullTankColors.inkSoft,
                fontSize: 11,
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
      label: '${tank.name}, ${tank.level} percent, ${_statusLabel(status)}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.go('/inventory/tank/${tank.id}'),
        child: Container(
          key: ValueKey('tank-${tank.id}'),
          padding: EdgeInsets.all(14 * _uiScale),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: FullTankColors.line),
            borderRadius: BorderRadius.circular(8 * _uiScale),
          ),
          child: Row(
            children: [
              _TankIcon(status: status),
              SizedBox(width: 12 * _uiScale),
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
                              color: FullTankColors.navy,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          '${tank.level}%',
                          style: TextStyle(
                            color: color,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2 * _uiScale),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14 * _uiScale,
                          color: FullTankColors.inkMid,
                        ),
                        SizedBox(width: 4 * _uiScale),
                        Expanded(
                          child: Text(
                            '${tank.location} · ${tank.type}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: FullTankColors.inkMid,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8 * _uiScale),
                    Row(
                      children: [
                        Expanded(child: _LevelBar(value: tank.level / 100)),
                        SizedBox(width: 8 * _uiScale),
                        Icon(
                          Icons.wifi_tethering,
                          size: 13 * _uiScale,
                          color: status == _TankStatus.critical
                              ? color
                              : FullTankColors.inkSoft,
                        ),
                        SizedBox(width: 3 * _uiScale),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            color: status == _TankStatus.critical
                                ? color
                                : FullTankColors.inkSoft,
                            fontSize: 10,
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
    width: 44 * _uiScale,
    height: 44 * _uiScale,
    decoration: BoxDecoration(
      color: _statusSoft(status),
      borderRadius: BorderRadius.circular(12 * _uiScale),
    ),
    alignment: Alignment.center,
    child: Icon(
      Icons.local_gas_station_outlined,
      size: 20 * _uiScale,
      color: _statusColor(status),
    ),
  );
}

