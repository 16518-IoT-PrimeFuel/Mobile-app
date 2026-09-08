part of 'home_page.dart';

class ActivityCenterPage extends StatelessWidget {
  const ActivityCenterPage({super.key});

  @override
  Widget build(BuildContext context) => _withHomeUiScale(
    context,
    Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SubpageHeader(
                title: 'Actividad',
                subtitle: 'Cambios, alertas y eventos',
                trailing: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.tune, size: 17),
                ),
              ),
              const SizedBox(height: 12),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(label: 'Todos 7', selected: true),
                    SizedBox(width: 6),
                    _FilterChip(label: 'Pedidos 2'),
                    SizedBox(width: 6),
                    _FilterChip(label: 'IoT 2'),
                    SizedBox(width: 6),
                    _FilterChip(label: 'Alertas 1'),
                    SizedBox(width: 6),
                    _FilterChip(label: 'Otros'),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const _ActivityGroup(
                label: 'HOY · 6 SEP',
                items: [
                  _ActivityItem(
                    icon: Icons.warning_amber_rounded,
                    title: 'Nivel crítico · A-102',
                    detail:
                        'El combustible bajó a 12% · se recomienda reordenar',
                    time: 'hace 3 min',
                    color: _red,
                    softColor: _redSoft,
                  ),
                  _ActivityItem(
                    icon: Icons.local_shipping_outlined,
                    title: 'Combustible despachado · #FT-2041',
                    detail: '8.000 L Diésel B5 · camión TX-4402',
                    time: 'hace 32 min',
                    color: _amber,
                    softColor: _amberSoft,
                  ),
                  _ActivityItem(
                    icon: Icons.receipt_long_outlined,
                    title: 'Pedido aprobado · #FT-2041',
                    detail: 'Aprobado por FuelMex Logistics',
                    time: 'hace 2 h',
                    color: FullTankColors.blue,
                    softColor: FullTankColors.blueSoft,
                  ),
                  _ActivityItem(
                    icon: Icons.sensors_outlined,
                    title: 'Sensor SN-4492 conectado',
                    detail: 'Lectura reanudada tras 4 min sin conexión',
                    time: 'hace 3 h',
                    color: _purple,
                    softColor: _purpleSoft,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const _ActivityGroup(
                label: 'A PRINCIPIOS DE SEMANA',
                items: [
                  _ActivityItem(
                    icon: Icons.flag_outlined,
                    title: 'Entrega completada · #FT-2038',
                    detail: '12.000 L · confirmada a las 09:14',
                    time: 'Ayer',
                    color: _green,
                    softColor: _greenSoft,
                  ),
                  _ActivityItem(
                    icon: Icons.attach_money,
                    title: 'Factura #INV-8102 pagada',
                    detail: '\$192.400 MXN · FuelMex Logistics',
                    time: 'Hace 2 días',
                    color: Color(0xFF0F9B91),
                    softColor: Color(0xFFEAFBF8),
                  ),
                  _ActivityItem(
                    icon: Icons.show_chart,
                    title: 'Pico de temperatura · A-102',
                    detail: 'Alcanzó 41°C durante 12 min · normalizado',
                    time: 'Hace 3 días',
                    color: _purple,
                    softColor: _purpleSoft,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _BottomNav(active: 0),
    ),
  );
}

class EmptyHomePage extends StatelessWidget {
  const EmptyHomePage({required this.role, super.key});

  final HomeRole role;

  @override
  Widget build(BuildContext context) {
    final provider = role == HomeRole.provider;
    return _withHomeUiScale(
      context,
      Scaffold(
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
                        color: FullTankColors.inkSoft,
                        softColor: const Color(0xFFF5F7FA),
                        size: 42,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        provider
                            ? 'No hay operaciones hoy'
                            : 'No hay pedidos activos',
                        style: const TextStyle(
                          color: FullTankColors.navy,
                          fontSize: 14,
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
                          color: FullTankColors.inkMid,
                          fontSize: 10.5,
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
        bottomNavigationBar: const _BottomNav(active: 0),
      ),
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
          backgroundColor: FullTankColors.card,
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
                color: FullTankColors.navy,
                fontSize: 21,
                fontWeight: FontWeight.w800,
                letterSpacing: -.5,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: FullTankColors.inkMid,
                fontSize: 10.5,
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
      color: selected ? FullTankColors.navy : FullTankColors.card,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: selected ? Colors.white : FullTankColors.navyMid,
        fontSize: 9.5,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
