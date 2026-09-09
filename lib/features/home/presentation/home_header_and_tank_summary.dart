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
            color: Color(0xFF1A202C),
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
                  color: Color(0xFF94A3B8),
                  fontSize: 12.325,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .25,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                name,
                style: const TextStyle(
                  color: Color(0xFF1A202C),
                  fontSize: 21.75,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.2,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF4A5568),
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
              color: Color(0xFFF3F4F6),
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
  const _TankSummaryCard();

  @override
  Widget build(BuildContext context) {
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TANQUE PRINCIPAL · A-102 DIÉSEL',
                          style: _labelStyle,
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 15,
                              color: Color(0xFF4A5568),
                            ),
                            SizedBox(width: 4),
                            Text('Norte · Sector 4', style: _metaStyle),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _TinyPill(
                    label: 'ACTIVO',
                    color: _green,
                    softColor: _greenSoft,
                    dot: true,
                  ),
                ],
              ),
              const SizedBox(height: 21),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NIVEL DE COMBUSTIBLE', style: _labelStyle),
                        SizedBox(height: 1),
                        Text.rich(
                          TextSpan(
                            text: '68',
                            style: TextStyle(
                              color: Color(0xFF1A202C),
                              fontSize: 60.9,
                              height: 1,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.8,
                            ),
                            children: [
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
                        SizedBox(height: 3),
                        Text('10.200 / 15.000 L', style: _metaStyle),
                      ],
                    ),
                  ),
                  const _VerticalLevelBar(value: .68),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              const SizedBox(height: 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TinyPill(
                    label: 'Normal',
                    color: _green,
                    softColor: _greenSoft,
                    dot: true,
                  ),
                  const Row(
                    children: [
                      Icon(Icons.sync, size: 15, color: Color(0xFF94A3B8)),
                      SizedBox(width: 5),
                      Text('Actualizado hace 5 min', style: _metaStyle),
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
