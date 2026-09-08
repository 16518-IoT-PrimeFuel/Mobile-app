part of 'home_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({required this.role, super.key});

  final HomeRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider).session;
    return _withHomeUiScale(
      context,
      Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: Transform(
            alignment: Alignment.topCenter,
            transform: Matrix4.diagonal3Values(1, 1.02, 1),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              child: role == HomeRole.provider
                  ? _ProviderHome(onSignOut: () => _signOut(context, ref))
                  : _RequesterHome(
                      guest: session?.token == 'guest',
                      onSignOut: () => _signOut(context, ref),
                    ),
            ),
          ),
        ),
        bottomNavigationBar: const FullTankBottomNav(active: 0),
      ),
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).signOut();
    if (context.mounted) context.go('/login');
  }
}

class _RequesterHome extends StatelessWidget {
  const _RequesterHome({required this.onSignOut, required this.guest});

  final VoidCallback onSignOut;
  final bool guest;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HomeHeader(
          initials: 'PE',
          eyebrow: 'BUENOS DÍAS · DOMINGO, 6 SEP',
          name: 'PetroAndes',
          subtitle: 'Solicitante · Operaciones de flota',
          onSignOut: onSignOut,
        ),
        const SizedBox(height: 18),
        const _TankSummaryCard(),
        const SizedBox(height: 18),
        const _SectionLabel('ACCIONES RÁPIDAS'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _QuickAction(
                icon: Icons.note_add_outlined,
                label: 'Crear\npedido',
                color: FullTankColors.blue,
                softColor: FullTankColors.blueSoft,
                onTap: () => context.push('/home/quick-actions'),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: _QuickAction(
                icon: Icons.receipt_long_outlined,
                label: 'Ver\npedidos',
                color: const Color(0xFF0F9B91),
                softColor: const Color(0xFFEAFBF8),
                onTap: () => context.push('/orders/history'),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: _QuickAction(
                icon: Icons.show_chart,
                label: 'Consumo',
                color: const Color(0xFFC56B2C),
                softColor: const Color(0xFFFFF4E9),
                onTap: () => context.push('/reports/consumption'),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: _QuickAction(
                icon: Icons.headset_mic_outlined,
                label: 'Soporte',
                color: _purple,
                softColor: _purpleSoft,
                onTap: () => context.push('/support/help'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const _SectionLabel('ESTADO DEL PEDIDO'),
        const SizedBox(height: 8),
        const _OrderStatusCard(),
        if (guest) ...[
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: onSignOut,
              child: const Text('Salir de vista previa'),
            ),
          ),
        ],
      ],
    );
  }
}

class _ProviderHome extends StatelessWidget {
  const _ProviderHome({required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HomeHeader(
          initials: 'FU',
          eyebrow: 'OPERACIONES · DOMINGO, 6 SEP',
          name: 'FuelMex Logistics',
          subtitle: 'Proveedor · Centro regional',
          onSignOut: onSignOut,
        ),
        const SizedBox(height: 18),
        const _SectionLabel('RESUMEN DE OPERACIONES'),
        const SizedBox(height: 8),
        const _SummaryGrid(),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _SectionLabel('ACCIONES PENDIENTES'),
            _TinyPill(label: '2 URGENTES', color: _red, softColor: _redSoft),
          ],
        ),
        const SizedBox(height: 8),
        _ActionRequiredCard(
          color: _red,
          priority: 'ALTA',
          reference: '#FT-2098',
          title: 'Aprobar pedido — AgroNorte',
          detail: '12.000 L Diésel B5 · hace 8 min',
          button: 'Aprobar',
          onTap: () => context.push('/provider/orders/FT-2098'),
        ),
        const SizedBox(height: 8),
        _ActionRequiredCard(
          color: _amber,
          priority: 'HIGH',
          reference: '#FT-2091',
          title: 'Asignar vehículo — Transportes Delta',
          detail: 'Bahía 2 · programado hoy 3:00 PM',
          button: 'Asignar',
          onTap: () => context.push('/dispatches/assign'),
        ),
        const SizedBox(height: 8),
        _ActionRequiredCard(
          color: _amber,
          priority: 'MEDIA',
          reference: 'INV-8112',
          title: 'Revisar pago — Cementos B',
          detail: '\$248.500 MXN · pendiente de confirmación',
          button: 'Revisar',
          onTap: () => context.push('/orders/FT-2098/payment'),
        ),
      ],
    );
  }
}
