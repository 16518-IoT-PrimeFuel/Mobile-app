part of 'home_page.dart';

class QuickActionsPage extends StatelessWidget {
  const QuickActionsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        const HomePage(role: HomeRole.requester),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: const ColoredBox(color: Color(0x660B1220)),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _QuickActionsSheet(onClose: () => context.pop()),
        ),
      ],
    ),
  );
}

class _QuickActionsSheet extends StatelessWidget {
  const _QuickActionsSheet({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 3,
          decoration: BoxDecoration(
            color: Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Acciones rápidas',
                    style: TextStyle(
                      color: Color(0xFF1A202C),
                      fontSize: 20.3,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text('Inicia operaciones desde aquí', style: _metaStyle),
                ],
              ),
            ),
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close, size: 17),
              style: IconButton.styleFrom(
                backgroundColor: Color(0xFFF3F4F6),
                fixedSize: const Size(28, 28),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _GradientAction(
          label: 'Crear pedido',
          icon: Icons.note_add_outlined,
          onTap: () => context.push('/orders/new'),
        ),
        const SizedBox(height: 7),
        const _SheetAction(
          icon: Icons.receipt_long_outlined,
          title: 'Ver pedidos',
          detail: '12 activos · 3 pendientes',
          color: Color(0xFF0F9B91),
          softColor: Color(0xFFEAFBF8),
        ),
        const SizedBox(height: 7),
        const _SheetAction(
          icon: Icons.description_outlined,
          title: 'Reportes',
          detail: 'Ventas · consumo · exportar',
          color: Color(0xFF1E40AF),
          softColor: Color(0xFFEFF4FF),
        ),
        const SizedBox(height: 7),
        const _SheetAction(
          icon: Icons.headset_mic_outlined,
          title: 'Soporte',
          detail: '24/7 · respuesta en 4 min',
          color: _purple,
          softColor: _purpleSoft,
        ),
      ],
    ),
  );
}

class ActivityCenterPage extends StatelessWidget {
  const ActivityCenterPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
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
                  detail: 'El combustible bajó a 12% · se recomienda reordenar',
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
                  color: Color(0xFF1E40AF),
                  softColor: Color(0xFFEFF4FF),
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
    bottomNavigationBar: const FullTankBottomNav(active: 0),
  );
}
