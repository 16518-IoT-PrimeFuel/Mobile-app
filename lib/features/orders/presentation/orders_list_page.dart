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
    return withFullTankUiScale(
      context,
      Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20 * _uiScale,
              14 * _uiScale,
              20 * _uiScale,
              28 * _uiScale,
            ),
            child: body,
          ),
        ),
        floatingActionButton:
            !widget.history && _state == OrderPageState.content
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
        bottomNavigationBar: const FullTankBottomNav(active: 1),
      ),
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
              onTap: () => context.push('/orders/search'),
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
              onTap: () => context.push('/orders/search'),
            ),
            _HeaderIcon(
              icon: Icons.tune,
              label: 'Filtrar pedidos',
              onTap: () => context.push('/orders/filter'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _ActiveMetrics(),
        const SizedBox(height: 12),
        _Filters(
          selected: _filter == 'Todos' ? 'Todos 5' : _filter,
          labels: const [
            'Todos 5',
            'Pendiente 1',
            'Aprobado 1',
            'En tránsito 1',
          ],
          onSelected: (value) =>
              setState(() => _filter = value == 'Todos 5' ? 'Todos' : value),
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
              _HeaderIcon(
                icon: Icons.search,
                label: 'Buscar',
                onTap: () => context.push('/orders/search'),
              ),
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
          _HeaderIcon(
            icon: Icons.search,
            label: 'Buscar',
            onTap: () => context.push('/orders/search'),
          ),
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
        'ERROR DE CONEXIÓN',
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
