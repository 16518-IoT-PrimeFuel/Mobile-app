part of 'inventory_page.dart';

class _InventoryShell extends StatelessWidget {
  const _InventoryShell({
    required this.title,
    required this.subtitle,
    required this.children,
    this.back = false,
    this.right,
    this.hasBottomNav = true,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool back;
  final Widget? right;
  final bool hasBottomNav;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              20 * _uiScale,
              4 * _uiScale,
              20 * _uiScale,
              8 * _uiScale,
            ),
            child: Row(
              children: [
                if (back) ...[
                  Semantics(
                    button: true,
                    label: 'Go back',
                    child: IconButton(
                      onPressed: () => context.go('/inventory'),
                      tooltip: 'Go back',
                      icon: const Icon(Icons.arrow_back, size: 18),
                      style: IconButton.styleFrom(
                        backgroundColor: FullTankColors.card,
                        fixedSize: Size.square(40 * _uiScale),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  SizedBox(width: 10 * _uiScale),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: FullTankColors.navy,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -.5,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: FullTankColors.inkMid,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (right != null) right!,
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20 * _uiScale,
                10 * _uiScale,
                20 * _uiScale,
                hasBottomNav ? 24 * _uiScale : 20 * _uiScale,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: hasBottomNav
        ? const FullTankBottomNav(active: 1)
        : null,
  );
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.badge,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final int? badge;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: IconButton(
      onPressed: onPressed,
      tooltip: label,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, size: 19 * _uiScale),
          if (badge != null)
            Positioned(
              right: -7,
              top: -7,
              child: Container(
                width: 15,
                height: 15,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: _red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$badge',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
      style: IconButton.styleFrom(
        backgroundColor: FullTankColors.card,
        fixedSize: Size.square(40 * _uiScale),
        padding: EdgeInsets.zero,
      ),
    ),
  );
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.count,
    required this.status,
  });

  final String label;
  final int count;
  final _TankStatus status;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: 12 * _uiScale,
      vertical: 10 * _uiScale,
    ),
    decoration: BoxDecoration(
      color: _statusSoft(status),
      borderRadius: BorderRadius.circular(8 * _uiScale),
      border: Border.all(color: _statusColor(status).withAlpha(56)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: _statusColor(status),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: .6,
          ),
        ),
        Text(
          count.toString().padLeft(2, '0'),
          style: const TextStyle(
            color: FullTankColors.navy,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -.5,
          ),
        ),
      ],
    ),
  );
}

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
