part of 'order_pages.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({required this.history, this.state, super.key});
  final bool history;
  final OrderPageState? state;
  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  String _filter = 'Todos';

  @override
  void initState() {
    super.initState();
    if (widget.history) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(ordersControllerProvider.notifier).load(history: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersControllerProvider);
    final orders = ordersState.valueOrNull ?? const <Order>[];
    final OrderPageState state =
        widget.state ??
        ordersState.when(
          loading: () => OrderPageState.loading,
          error: (_, __) => OrderPageState.error,
          data: (orders) =>
              orders.isEmpty ? OrderPageState.empty : OrderPageState.content,
        );
    final body = widget.history
        ? _historyBody(context, orders, state)
        : _activeBody(context, orders, state);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          child: body,
        ),
      ),
      floatingActionButton: !widget.history && state == OrderPageState.content
          ? Semantics(
              button: true,
              label: 'Crear nuevo pedido',
              child: FloatingActionButton(
                onPressed: () => context.push('/orders/new'),
                tooltip: 'Crear nuevo pedido',
                backgroundColor: _orange,
                foregroundColor: _ink,
                child: const Icon(Icons.add),
              ),
            )
          : null,
    );
  }

  Widget _historyBody(
    BuildContext context,
    List<Order> orders,
    OrderPageState state,
  ) {
    if (state == OrderPageState.loading)
      return _loadingBody(title: 'Historial', subtitle: 'Cargando pedidos...');
    if (state == OrderPageState.empty) return _emptyBody(history: true);
    if (state == OrderPageState.error) return _errorBody(history: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          title: 'Historial',
          subtitle: '${orders.length} pedidos',
          actions: [
            _HeaderIcon(
              icon: Icons.search,
              label: 'Buscar en historial',
              onTap: () {},
            ),
            _HeaderIcon(
              icon: Icons.download_outlined,
              label: 'Descargar historial',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 12),
        _HistoryMetrics(orders: orders),
        const SizedBox(height: 12),
        const _WeeklyBars(label: 'CONSUMO SEMANAL (L)', action: 'Ver detalle'),
        const SizedBox(height: 11),
        _Filters(
          selected: _filter,
          labels: const ['Todos', 'Entregado', 'En tránsito'],
          onSelected: (value) => setState(() => _filter = value),
          leading: 'Filtros 3',
        ),
        const SizedBox(height: 10),
        _HistoryOrders(filter: _filter, orders: orders),
      ],
    );
  }

  Widget _activeBody(
    BuildContext context,
    List<Order> orders,
    OrderPageState state,
  ) {
    if (state == OrderPageState.loading)
      return _loadingBody(
        title: 'Mis pedidos',
        subtitle: 'Cargando pedidos...',
      );
    if (state == OrderPageState.empty) return _emptyBody(history: false);
    if (state == OrderPageState.error) return _errorBody(history: false);
    final providerMode =
        ref
            .watch(authControllerProvider)
            .session
            ?.roles
            .contains('ROLE_PROVIDER') ??
        false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          title: 'Mis pedidos',
          subtitle: '${orders.length} pedidos · sincronizados',
          actions: [
            _HeaderIcon(
              icon: Icons.search,
              label: 'Buscar pedidos',
              onTap: () {},
            ),
            _HeaderIcon(
              icon: Icons.tune,
              label: 'Filtrar pedidos',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 12),
        _ActiveMetrics(orders: orders),
        const SizedBox(height: 12),
        _Filters(
          selected: _filter == 'Todos' ? 'All ${orders.length}' : _filter,
          labels: [
            'All ${orders.length}',
            'Pendiente ${orders.where((o) => o.status == OrderStatus.pending).length}',
            'Aprobado ${orders.where((o) => o.status == OrderStatus.approved).length}',
            'En tránsito ${orders.where((o) => o.status == OrderStatus.inTransit).length}',
          ],
          onSelected: (value) => setState(
            () => _filter = value.startsWith('All ') ? 'Todos' : value,
          ),
        ),
        const SizedBox(height: 10),
        _ActiveOrders(
          filter: _filter,
          orders: orders,
          providerMode: providerMode,
          onAccept: (id) =>
              ref.read(ordersControllerProvider.notifier).accept(id),
          onReject: (id) => _rejectRequest(id),
        ),
      ],
    );
  }

  Future<void> _rejectRequest(int requestId) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rechazar solicitud'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Motivo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (reason == null || reason.isEmpty) return;
    await ref.read(ordersControllerProvider.notifier).reject(requestId, reason);
  }

  Widget _loadingBody({required String title, required String subtitle}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(
            title: title,
            subtitle: subtitle,
            actions: [
              _HeaderIcon(icon: Icons.search, label: 'Buscar', onTap: () {}),
            ],
          ),
          const SizedBox(height: 12),
          const _SkeletonMetrics(),
          const SizedBox(height: 10),
          const _SkeletonOrders(),
        ],
      );

  Widget _emptyBody({required bool history}) => Column(
    children: [
      _Header(
        title: history ? 'Historial' : 'Mis pedidos',
        subtitle: history ? 'Sin registros' : 'Sin pedidos activos',
        actions: [
          _HeaderIcon(icon: Icons.search, label: 'Buscar', onTap: () {}),
        ],
      ),
      const SizedBox(height: 88),
      _EmptyIllustration(
        icon: history ? Icons.history : Icons.inventory_2_outlined,
        color: _blue,
      ),
      const SizedBox(height: 16),
      Text(
        history
            ? 'Aún no tienes pedidos\nregistrados'
            : 'No tienes pedidos activos',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: _ink,
          fontSize: 16,
          height: 1.15,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        history
            ? 'Cuando registres tu primer pedido de\ncombustible, aparecerá aquí con todo el\nhistórico de consumo empresarial.'
            : 'Cuando registres una solicitud de\ncombustible, aparecerá aquí con su\nestado actualizado en tiempo real.',
        textAlign: TextAlign.center,
        style: const TextStyle(color: _muted, fontSize: 10, height: 1.5),
      ),
      const SizedBox(height: 14),
      _TipBox(history: history),
      const SizedBox(height: 22),
      SizedBox(
        width: double.infinity,
        child: _OrangeButton(
          label: history ? 'Crear primer pedido  →' : 'Crear nuevo pedido  →',
          onPressed: () => context.push('/orders/new'),
        ),
      ),
    ],
  );

  Widget _errorBody({required bool history}) => Column(
    children: [
      _Header(
        title: history ? 'Historial' : 'Mis pedidos',
        subtitle: 'Error de conexión',
        actions: [
          _HeaderIcon(
            icon: Icons.refresh,
            label: 'Actualizar',
            onTap: () => ref
                .read(ordersControllerProvider.notifier)
                .load(history: widget.history),
          ),
        ],
      ),
      const SizedBox(height: 83),
      const _ErrorIllustration(),
      const SizedBox(height: 16),
      const Text(
        'CONNECTION ERROR',
        style: TextStyle(color: _red, fontSize: 8, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 8),
      Text(
        history
            ? 'No se pudo cargar\nel historial'
            : 'No fue posible cargar\ntus pedidos',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: _ink,
          fontSize: 16,
          height: 1.1,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        'Verifica tu conexión a internet y vuelve a intentarlo.\nTus pedidos se sincronizarán en cuanto\nrestablezcamos la conexión.',
        textAlign: TextAlign.center,
        style: TextStyle(color: _muted, fontSize: 10, height: 1.45),
      ),
      const SizedBox(height: 18),
      _ErrorMeta(history: history),
      const SizedBox(height: 28),
      SizedBox(
        width: double.infinity,
        child: _OrangeButton(
          label: 'Reintentar  ↻',
          onPressed: () => ref
              .read(ordersControllerProvider.notifier)
              .load(history: widget.history),
        ),
      ),
      const SizedBox(height: 12),
      TextButton(
        onPressed: () => context.push('/account/help'),
        child: const Text(
          'Contactar soporte',
          style: TextStyle(color: _muted, fontSize: 9),
        ),
      ),
    ],
  );
}
