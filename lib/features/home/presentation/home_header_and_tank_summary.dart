part of 'home_page.dart';

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.initials,
    required this.eyebrow,
    required this.name,
    required this.subtitle,
    required this.onSignOut,
  });

  final String initials;
  final String eyebrow;
  final String name;
  final String subtitle;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 47,
          height: 47,
          decoration: BoxDecoration(
            color: FullTankColors.text,
            borderRadius: BorderRadius.circular(13),
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17.4,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: const TextStyle(
                  color: FullTankColors.muted,
                  fontSize: 12.325,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .25,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                name,
                style: const TextStyle(
                  color: FullTankColors.text,
                  fontSize: 21.75,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.2,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: FullTankColors.textSecondary,
                  fontSize: 13.775,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          tooltip: 'Notificaciones',
          onSelected: (value) {
            if (value == 'activity') {
              context.push('/home/activity');
            } else if (value == 'notifications') {
              context.push('/notifications');
            } else {
              onSignOut();
            }
          },
          padding: EdgeInsets.zero,
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'notifications',
              child: Text('Notificaciones', style: TextStyle(fontSize: 20.3)),
            ),
            PopupMenuItem(
              value: 'activity',
              child: Text('Actividad', style: TextStyle(fontSize: 20.3)),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Text('Cerrar sesión', style: TextStyle(fontSize: 20.3)),
            ),
          ],
          icon: Container(
            width: 47,
            height: 47,
            decoration: BoxDecoration(
              color: FullTankColors.background,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications_none_outlined, size: 23),
                Positioned(
                  right: 9,
                  top: 9,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: _red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TankSummaryCard extends StatelessWidget {
  const _TankSummaryCard({
    required this.tank,
    required this.unavailable,
    required this.preview,
  });

  final Tank? tank;
  final bool unavailable;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    final tank = this.tank;
    if (tank == null) {
      return _Card(
        child: Text(
          unavailable
              ? 'No se pudo consultar el inventario de tanques.'
              : 'Aún no hay tanques registrados.',
          style: _metaStyle,
        ),
      );
    }
    final (statusLabel, statusColor, statusSoft) = switch (tank.status
        .toUpperCase()) {
      'CRITICAL' => ('Crítico', _red, _redSoft),
      'WARNING' || 'LOW' => ('Bajo', _amber, _amberSoft),
      _ => ('Normal', _green, _greenSoft),
    };
    final reading = tank.lastReadingAt?.toLocal();
    return Semantics(
      button: true,
      label: 'Abrir inventario del tanque principal',
      child: InkWell(
        onTap: () => context.push('/inventory'),
        borderRadius: BorderRadius.circular(20.3),
        child: _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TANQUE MÁS BAJO · ${tank.name.toUpperCase()}',
                style: _labelStyle,
              ),
              const SizedBox(height: 21),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('NIVEL DE COMBUSTIBLE', style: _labelStyle),
                        const SizedBox(height: 1),
                        Text.rich(
                          TextSpan(
                            text: '${tank.level}',
                            style: const TextStyle(
                              color: FullTankColors.text,
                              fontSize: 60.9,
                              height: 1,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.8,
                            ),
                            children: const [
                              TextSpan(
                                text: '%',
                                style: TextStyle(
                                  fontSize: 27.55,
                                  letterSpacing: -.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${_litres(tank.currentLevel)} / '
                          '${_litres(tank.capacity)} ${tank.unit}',
                          style: _metaStyle,
                        ),
                      ],
                    ),
                  ),
                  _VerticalLevelBar(value: tank.level / 100),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: FullTankColors.border),
              const SizedBox(height: 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TinyPill(
                    label: statusLabel,
                    color: statusColor,
                    softColor: statusSoft,
                    dot: true,
                  ),
                  if (reading != null && !preview)
                    Row(
                      children: [
                        const Icon(
                          Icons.sync,
                          size: 15,
                          color: FullTankColors.muted,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Actualizado ${reading.day.toString().padLeft(2, '0')}/'
                          '${reading.month.toString().padLeft(2, '0')} '
                          '${reading.hour.toString().padLeft(2, '0')}:'
                          '${reading.minute.toString().padLeft(2, '0')}',
                          style: _metaStyle,
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
