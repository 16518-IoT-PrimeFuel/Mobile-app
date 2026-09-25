part of 'home_page.dart';

class EmptyHomePage extends StatelessWidget {
  const EmptyHomePage({required this.role, super.key});

  final HomeRole role;

  @override
  Widget build(BuildContext context) {
    final provider = role == HomeRole.provider;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HomeHeader(
                initials: provider ? 'FU' : 'PE',
                eyebrow: provider
                    ? 'OPERACIONES · DOMINGO, 6 SEP'
                    : 'BUENOS DÍAS · DOMINGO, 6 SEP',
                name: provider ? 'FuelMex Logistics' : 'PetroAndes',
                subtitle: provider
                    ? 'Proveedor · Centro regional'
                    : 'Solicitante · Operaciones de flota',
                onSignOut: () => context.go('/login'),
              ),
              const SizedBox(height: 20),
              _Card(
                child: Column(
                  children: [
                    _IconTile(
                      icon: provider
                          ? Icons.link_outlined
                          : Icons.inbox_outlined,
                      color: Color(0xFF94A3B8),
                      softColor: const Color(0xFFF5F7FA),
                      size: 42,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      provider
                          ? 'No hay operaciones hoy'
                          : 'No hay pedidos activos',
                      style: const TextStyle(
                        color: Color(0xFF1A202C),
                        fontSize: 20.3,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      provider
                          ? 'Cuando tus clientes hagan pedidos, las tareas y entregas aparecerán aquí.'
                          : 'Cuando crees tu primer pedido o el sensor active una alerta, aparecerá aquí.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF4A5568),
                        fontSize: 15.225,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _GradientAction(
                      label: provider ? 'Invitar cliente' : 'Crear pedido',
                      icon: provider
                          ? Icons.person_add_alt_1_outlined
                          : Icons.note_add_outlined,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              if (!provider) ...[
                const SizedBox(height: 18),
                const _SectionLabel('LISTA DE CONFIGURACIÓN'),
                const SizedBox(height: 8),
                const _SetupRow(
                  icon: Icons.business_outlined,
                  title: 'Agrega tu primer tanque',
                  detail: 'Conecta un sensor IoT',
                  done: false,
                ),
                const _SetupRow(
                  icon: Icons.person_add_alt_1_outlined,
                  title: 'Invita a tu equipo',
                  detail: 'Colabora en las operaciones',
                  done: false,
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FullTankBottomNav(active: 0),
    );
  }
}

class _SubpageHeader extends StatelessWidget {
  const _SubpageHeader({
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back, size: 18),
        style: IconButton.styleFrom(
          backgroundColor: Color(0xFFF3F4F6),
          fixedSize: const Size(36, 36),
          padding: EdgeInsets.zero,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1A202C),
                fontSize: 30.45,
                fontWeight: FontWeight.w800,
                letterSpacing: -.5,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF4A5568),
                fontSize: 15.225,
              ),
            ),
          ],
        ),
      ),
      if (trailing != null) trailing!,
    ],
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: selected ? Color(0xFF1A202C) : Color(0xFFF3F4F6),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: selected ? Colors.white : Color(0xFF2D3748),
        fontSize: 13.775,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _SearchResult extends StatelessWidget {
  const _SearchResult({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.detail,
    required this.color,
    required this.softColor,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final String detail;
  final Color color;
  final Color softColor;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 7),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Color(0xFFE2E8F0)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        _IconTile(icon: icon, color: color, softColor: softColor, size: 28),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: TextStyle(
                  color: color,
                  fontSize: 10.875,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1A202C),
                  fontSize: 15.225,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                detail,
                style: const TextStyle(
                  color: Color(0xFF4A5568),
                  fontSize: 12.325,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, size: 16, color: Color(0xFF94A3B8)),
      ],
    ),
  );
}
