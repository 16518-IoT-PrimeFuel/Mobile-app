part of 'home_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({required this.role, super.key});

  final HomeRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider).session;
    final providerMode =
        session?.roles.contains('ROLE_PROVIDER') ?? role == HomeRole.provider;
    final orders =
        ref.watch(ordersControllerProvider).valueOrNull ?? const <Order>[];
    final activeOrder = orders
        .where(
          (order) =>
              order.status != OrderStatus.delivered &&
              order.status != OrderStatus.cancelled &&
              order.status != OrderStatus.rejected,
        )
        .firstOrNull;
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
              child: providerMode
                  ? _ProviderHome(
                      onSignOut: () => _signOut(context, ref),
                      orders: orders,
                      name: session?.username ?? 'FuelMex Logistics',
                    )
                  : _RequesterHome(
                      guest: session?.token == 'guest',
                      name: session?.token == 'guest'
                          ? 'PetroAndes'
                          : session?.username ?? 'PetroAndes',
                      activeOrder: activeOrder,
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
  const _RequesterHome({
    required this.onSignOut,
    required this.guest,
    required this.name,
    required this.activeOrder,
  });

  final VoidCallback onSignOut;
  final bool guest;
  final String name;
  final Order? activeOrder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HomeHeader(
          initials: 'PE',
          eyebrow: 'BUENOS DÍAS · DOMINGO, 6 SEP',
          name: name,
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
                onTap: () => context.push('/account/help'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const _SectionLabel('ESTADO DEL PEDIDO'),
        const SizedBox(height: 8),
        _OrderStatusCard(order: activeOrder),
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
  const _ProviderHome({
    required this.onSignOut,
    required this.orders,
    required this.name,
  });

  final VoidCallback onSignOut;
  final List<Order> orders;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HomeHeader(
          initials: 'FU',
          eyebrow: 'OPERACIONES · DOMINGO, 6 SEP',
          name: name,
          subtitle: 'Proveedor · Centro regional',
          onSignOut: onSignOut,
        ),
        const SizedBox(height: 18),
        const _SectionLabel('RESUMEN DE OPERACIONES'),
        const SizedBox(height: 8),
        _SummaryGrid(orders: orders),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _SectionLabel('ACCIONES PENDIENTES'),
            _TinyPill(
              label:
                  '${orders.where((o) => o.request && o.status == OrderStatus.pending).length} PENDIENTES',
              color: _red,
              softColor: _redSoft,
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final order
            in orders
                .where((o) => o.request && o.status == OrderStatus.pending)
                .take(4)) ...[
          _ActionRequiredCard(
            color: _red,
            priority: 'NUEVA',
            reference: '#${order.id}',
            title: 'Solicitud de ${order.fuel}',
            detail:
                '${order.quantity.toStringAsFixed(0)} L · ${order.deliveryAddress}',
            button: 'Revisar',
            onTap: () => context.push('/orders'),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
