part of 'order_pages.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({
    required this.history,
    this.state = OrderPageState.content,
    super.key,
  });
  final bool history;
  final OrderPageState state;
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late OrderPageState _state = widget.state;
  String _filter = 'Todos';

  @override
  Widget build(BuildContext context) {
    final body = widget.history ? _historyBody(context) : _activeBody(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          child: body,
        ),
      ),
      floatingActionButton: !widget.history && _state == OrderPageState.content
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

  Widget _historyBody(BuildContext context) {
    if (_state == OrderPageState.loading)
      return _loadingBody(title: 'Historial', subtitle: 'Cargando pedidos...');
    if (_state == OrderPageState.empty) return _emptyBody(history: true);
    if (_state == OrderPageState.error) return _errorBody(history: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          title: 'Historial',
          subtitle: '7 pedidos · últimos 30 días',
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
        const _HistoryMetrics(),
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
        _HistoryOrders(filter: _filter),
      ],
    );
  }

  Widget _activeBody(BuildContext context) {
    if (_state == OrderPageState.loading)
      return _loadingBody(
        title: 'Mis pedidos',
        subtitle: 'Cargando pedidos...',
      );
    if (_state == OrderPageState.empty) return _emptyBody(history: false);
    if (_state == OrderPageState.error) return _errorBody(history: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          title: 'Mis pedidos',
          subtitle: '5 pedidos · sincronizado hace 2 min',
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
        const _ActiveMetrics(),
        const SizedBox(height: 12),
        _Filters(
          selected: _filter == 'Todos' ? 'All 5' : _filter,
          labels: const ['All 5', 'Pendiente 1', 'Aprobado 1', 'En tránsito 1'],
          onSelected: (value) =>
              setState(() => _filter = value == 'All 5' ? 'Todos' : value),
        ),
        const SizedBox(height: 10),
        _ActiveOrders(filter: _filter),
      ],
    );
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
            onTap: () => setState(() => _state = OrderPageState.content),
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
          onPressed: () => setState(() => _state = OrderPageState.content),
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

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({
    required this.history,
    required this.orderId,
    super.key,
  });
  final bool history;
  final String orderId;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        child: history ? _historyDetail(context) : _activeDetail(context),
      ),
    ),
  );

  Widget _historyDetail(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _Header(
        title: '#${orderId.replaceFirst('#', '')}',
        subtitle: 'Detalle del pedido',
        actions: [
          _HeaderIcon(
            icon: Icons.more_horiz,
            label: 'Más opciones',
            onTap: () {},
          ),
        ],
      ),
      const SizedBox(height: 10),
      const _DeliveredBanner(),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: _SmallButton(
              label: 'Descargar factura',
              icon: Icons.download_outlined,
              onTap: () {},
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: _DarkButton(
              label: 'Repetir pedido',
              onTap: () => context.push('/orders/new'),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      const Row(
        children: [
          Expanded(
            child: _FuelMetric(
              label: 'COMBUSTIBLE',
              value: 'Diesel',
              detail: 'ULSD B5',
              icon: Icons.opacity_outlined,
              color: _blue,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _FuelMetric(
              label: 'CANTIDAD',
              value: '10,500',
              detail: 'L',
              icon: Icons.local_gas_station_outlined,
              color: _orange,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      const _DetailTable(
        title: 'DETALLES DEL PEDIDO',
        rows: [
          ('Número', '#FT-88402'),
          ('Fecha de creación', 'Ayer, 09:30'),
          ('Fecha de entrega', 'Ayer, 17:45'),
          ('Proveedor', 'Global Fuel Corp'),
          ('Tanque destino', 'A-102 · Sector 4'),
          ('Vehículo', 'ABC-921 · M. Ríos'),
        ],
      ),
      const SizedBox(height: 12),
      const _DetailTable(
        title: 'PAGO',
        rows: [('Estado', 'Aprobado'), ('Payment ID', 'PAY-88402-A')],
      ),
    ],
  );

  Widget _activeDetail(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _Header(
        title: '#${orderId.replaceFirst('#', '')}',
        subtitle: 'Order tracking',
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            decoration: const BoxDecoration(
              color: _greenSoft,
              borderRadius: BorderRadius.all(Radius.circular(99)),
            ),
            child: const Text(
              '● LIVE',
              style: TextStyle(
                color: _green,
                fontSize: 8,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 11),
      const _CurrentStateBanner(),
      const SizedBox(height: 13),
      const Text(
        'DELIVERY TIMELINE',
        style: TextStyle(
          color: _subtle,
          fontSize: 8,
          fontWeight: FontWeight.w800,
          letterSpacing: .4,
        ),
      ),
      const SizedBox(height: 8),
      const _DeliveryTimeline(),
      const SizedBox(height: 12),
      const _DetailTable(
        title: 'ORDER DETAILS',
        rows: [
          ('Fuel type', 'Diesel · ULSD B5'),
          ('Quantity', '6,000 L'),
          ('Supplier', 'Global Fuel Corp'),
        ],
      ),
      const SizedBox(height: 14),
      Row(
        children: [
          Expanded(
            child: _LightButton(
              label: 'Support',
              onTap: () => context.push('/account/help'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _OrangeButton(label: 'Live tracking  →', onPressed: () {}),
          ),
        ],
      ),
    ],
  );
}
