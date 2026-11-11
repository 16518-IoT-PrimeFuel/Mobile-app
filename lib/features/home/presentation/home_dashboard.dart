part of 'home_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({required this.role, super.key});

  final HomeRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider).session;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 56),
          child: role == HomeRole.provider
              ? _ProviderHome(onSignOut: () => _signOut(context, ref))
              : _RequesterHome(
                  guest: session?.token == 'guest',
                  onSignOut: () => _signOut(context, ref),
                ),
        ),
      ),
      bottomNavigationBar: const FullTankBottomNav(active: 0),
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).signOut();
    if (context.mounted) context.go('/login');
  }
}

class _HomeFallbackHeader extends ConsumerWidget {
  const _HomeFallbackHeader({required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) => _HomeHeader(
    initials: 'FT',
    eyebrow: homeGreeting(ref.read(homeClockProvider)()),
    name: 'FullTank',
    subtitle: '',
    onSignOut: onSignOut,
  );
}

class _HomeLoading extends StatelessWidget {
  const _HomeLoading({required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _HomeFallbackHeader(onSignOut: onSignOut),
      const SizedBox(height: 80),
      const Center(child: CircularProgressIndicator()),
    ],
  );
}

class _HomeError extends ConsumerWidget {
  const _HomeError({required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    children: [
      _HomeFallbackHeader(onSignOut: onSignOut),
      const SizedBox(height: 60),
      const Icon(
        Icons.cloud_off_outlined,
        size: 40,
        color: FullTankColors.muted,
      ),
      const SizedBox(height: 12),
      const Text(
        'No se pudo cargar el resumen.',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 12),
      FilledButton(
        onPressed: () => ref.invalidate(homeSummaryProvider),
        child: const Text('Reintentar'),
      ),
    ],
  );
}

class _PreviewBanner extends StatelessWidget {
  const _PreviewBanner();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 14),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: _amberSoft,
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Text(
      'Vista previa · datos de ejemplo, no son reales',
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
    ),
  );
}

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  final list = parts.toList();
  final letters = list.length > 1
      ? list.take(2).map((p) => p[0]).join()
      : list.isEmpty
      ? ''
      : list.first.substring(0, list.first.length.clamp(0, 2));
  return letters.isEmpty ? 'FT' : letters.toUpperCase();
}

class _RequesterHome extends ConsumerWidget {
  const _RequesterHome({required this.onSignOut, required this.guest});

  final VoidCallback onSignOut;
  final bool guest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(homeSummaryProvider);
    return summary.when(
      loading: () => _HomeLoading(onSignOut: onSignOut),
      error: (_, __) => _HomeError(onSignOut: onSignOut),
      data: (data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HomeHeader(
            initials: _initials(data.companyName),
            eyebrow: homeGreeting(data.fetchedAt),
            name: data.companyName,
            subtitle: 'Solicitante',
            onSignOut: onSignOut,
          ),
          if (data.isPreview) const _PreviewBanner(),
          const SizedBox(height: 18),
          _TankSummaryCard(
            tank: data.tank,
            unavailable: data.tankUnavailable,
            preview: data.isPreview,
          ),
          const SizedBox(height: 18),
          const _SectionLabel('ACCIONES RÁPIDAS'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _QuickAction(
                  icon: Icons.note_add_outlined,
                  label: 'Crear\npedido',
                  color: FullTankColors.primary,
                  softColor: FullTankColors.primarySoft,
                  onTap: () => context.push('/home/quick-actions'),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _QuickAction(
                  icon: Icons.receipt_long_outlined,
                  label: 'Ver\npedidos',
                  color: FullTankColors.success,
                  softColor: FullTankColors.successSoft,
                  onTap: () => context.push('/orders/history'),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _QuickAction(
                  icon: Icons.show_chart,
                  label: 'Consumo',
                  color: FullTankColors.accent,
                  softColor: FullTankColors.warningSoft,
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
          if (data.activeOrder != null) ...[
            const SizedBox(height: 18),
            const _SectionLabel('ESTADO DEL PEDIDO'),
            const SizedBox(height: 8),
            _OrderStatusCard(order: data.activeOrder!),
          ],
          if (guest) ...[
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: onSignOut,
                child: const Text(
                  'Salir de vista previa',
                  style: TextStyle(fontSize: 20.3),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProviderHome extends ConsumerWidget {
  const _ProviderHome({required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(homeSummaryProvider);
    return summary.when(
      loading: () => _HomeLoading(onSignOut: onSignOut),
      error: (_, __) => _HomeError(onSignOut: onSignOut),
      data: (data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HomeHeader(
            initials: _initials(data.companyName),
            eyebrow: homeGreeting(data.fetchedAt),
            name: data.companyName,
            subtitle: 'Proveedor',
            onSignOut: onSignOut,
          ),
          if (data.isPreview) const _PreviewBanner(),
          const SizedBox(height: 18),
          const _SectionLabel('RESUMEN DE OPERACIONES'),
          const SizedBox(height: 8),
          _SummaryGrid(
            pendingOrders: data.pendingOrders,
            totalFuelSoldLitres: data.totalFuelSoldLitres,
          ),
          if (data.isPreview) ...[
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: onSignOut,
                child: const Text(
                  'Salir de vista previa',
                  style: TextStyle(fontSize: 20.3),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
