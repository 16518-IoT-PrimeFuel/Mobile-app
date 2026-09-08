import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _ink = Color(0xFF172033);
const _muted = Color(0xFF64748B);
const _subtle = Color(0xFF94A3B8);
const _line = Color(0xFFE7ECF2);
const _panel = Color(0xFFF8FAFC);
const _blue = Color(0xFF2563EB);
const _blueSoft = Color(0xFFEFF4FF);
const _orange = Color(0xFFFF8A0A);
const _green = Color(0xFF10B981);
const _greenSoft = Color(0xFFE9FBF4);
const _red = Color(0xFFEF4444);

enum OrderPageState { content, loading, empty, error }

OrderPageState orderPageStateFromQuery(String? value) => switch (value) {
  'loading' => OrderPageState.loading,
  'empty' => OrderPageState.empty,
  'error' => OrderPageState.error,
  _ => OrderPageState.content,
};

enum SalesReportState { dashboard, generating, ready, empty }

enum NewOrderState { defaultState, loading, success, error }

NewOrderState newOrderStateFromQuery(String? value) => switch (value) {
  'loading' => NewOrderState.loading,
  'success' => NewOrderState.success,
  'error' => NewOrderState.error,
  _ => NewOrderState.defaultState,
};

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

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({
    this.initialState = NewOrderState.defaultState,
    super.key,
  });

  final NewOrderState initialState;

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  late NewOrderState _state = widget.initialState;
  String _fuel = 'Diesel';

  @override
  Widget build(BuildContext context) {
    final loading = _state == NewOrderState.loading;
    final success = _state == NewOrderState.success;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          child: success
              ? _successBody(context)
              : _formBody(context, loading: loading),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: _NewOrderAction(state: _state, onCreate: _create),
        ),
      ),
    );
  }

  Widget _formBody(BuildContext context, {required bool loading}) {
    final error = _state == NewOrderState.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          title: loading ? 'Creating order' : 'New Order',
          subtitle: loading
              ? 'Validating supplier availability...'
              : error
              ? 'Fix the errors below to continue'
              : 'Register a new fuel request',
          actions: [
            if (loading)
              _HeaderIcon(
                icon: Icons.close,
                label: 'Cancelar creación',
                onTap: () =>
                    setState(() => _state = NewOrderState.defaultState),
              )
            else
              _HeaderIcon(
                icon: Icons.more_horiz,
                label: 'Más opciones',
                onTap: () {},
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (loading)
          const _CreationLoading()
        else ...[
          if (error)
            _ConnectionErrorCard(
              onRetry: () =>
                  setState(() => _state = NewOrderState.defaultState),
            ),
          if (error) const SizedBox(height: 10),
          _FieldCaption(label: 'FUEL TYPE', error: error),
          const SizedBox(height: 6),
          _FuelGrid(
            selected: _fuel,
            error: error,
            onSelected: (fuel) => setState(() {
              _fuel = fuel;
              if (_state == NewOrderState.error)
                _state = NewOrderState.defaultState;
            }),
          ),
          if (error) ...[
            const SizedBox(height: 5),
            const Text(
              'ⓘ  Select a fuel type to continue.',
              style: TextStyle(
                color: _red,
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 12),
          const _FieldCaption(label: 'MONTO DEPOSITADO'),
          const SizedBox(height: 6),
          const _MoneyCard(),
          const SizedBox(height: 12),
          const _FieldCaption(label: 'ASSOCIATED TANK'),
          const SizedBox(height: 6),
          const _TankCard(),
          const SizedBox(height: 12),
          const _FieldCaption(label: 'PREFERRED SUPPLIER'),
          const SizedBox(height: 6),
          const _SupplierCard(),
          const SizedBox(height: 12),
          const _FieldCaption(label: 'DELIVERY WINDOW'),
          const SizedBox(height: 6),
          const _DeliveryField(),
        ],
      ],
    );
  }

  Widget _successBody(BuildContext context) => Column(
    children: [
      Align(
        alignment: Alignment.topRight,
        child: _HeaderIcon(
          icon: Icons.close,
          label: 'Cerrar confirmación',
          onTap: () => context.pop(),
        ),
      ),
      const SizedBox(height: 30),
      Container(
        width: 68,
        height: 68,
        decoration: const BoxDecoration(
          color: _greenSoft,
          shape: BoxShape.circle,
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: _green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 28),
        ),
      ),
      const SizedBox(height: 15),
      const Text(
        'Pedido creado\ncorrectamente',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _ink,
          fontSize: 17,
          height: 1.1,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 9),
      const Text(
        'Tu solicitud fue enviada al proveedor.\nRecibirás una notificación cuando sea\naprobada.',
        textAlign: TextAlign.center,
        style: TextStyle(color: _muted, fontSize: 9, height: 1.45),
      ),
      const SizedBox(height: 20),
      const _SuccessDetails(),
    ],
  );

  void _create() {
    setState(() => _state = NewOrderState.loading);
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _state = NewOrderState.success);
    });
  }
}

class _FieldCaption extends StatelessWidget {
  const _FieldCaption({required this.label, this.error = false});
  final String label;
  final bool error;
  @override
  Widget build(BuildContext context) => Text(
    error ? '$label · REQUIRED' : label,
    style: TextStyle(
      color: error ? _red : _subtle,
      fontSize: 7,
      fontWeight: FontWeight.w800,
      letterSpacing: .35,
    ),
  );
}

class _FuelGrid extends StatelessWidget {
  const _FuelGrid({
    required this.selected,
    required this.onSelected,
    required this.error,
  });
  final String selected;
  final ValueChanged<String> onSelected;
  final bool error;
  @override
  Widget build(BuildContext context) {
    const fuels = [
      ('Diesel', 'ULSD B5', Icons.opacity_outlined),
      ('Gasoline', '95 · 97', Icons.receipt_long_outlined),
      ('LPG', 'Propano', Icons.local_fire_department_outlined),
      ('Other', 'Custom', Icons.storage_outlined),
    ];
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: error ? Border.all(color: _red) : null,
        borderRadius: BorderRadius.circular(9),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 2.25,
        children: [
          for (final fuel in fuels)
            _FuelChoice(
              name: fuel.$1,
              detail: fuel.$2,
              icon: fuel.$3,
              selected: selected == fuel.$1 && !error,
              onTap: () => onSelected(fuel.$1),
            ),
        ],
      ),
    );
  }
}

class _FuelChoice extends StatelessWidget {
  const _FuelChoice({
    required this.name,
    required this.detail,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String name, detail;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: '$name $detail',
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? _blueSoft : _panel,
          border: Border.all(color: selected ? _blue : Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: selected ? _blue : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : _muted,
                size: 14,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: selected ? _blue : _ink,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    detail,
                    style: const TextStyle(color: _muted, fontSize: 7),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: _blue, size: 13),
          ],
        ),
      ),
    ),
  );
}

class _MoneyCard extends StatelessWidget {
  const _MoneyCard();
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(9),
      border: Border.all(color: _line),
    ),
    child: Column(
      children: [
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'S/ ',
                style: TextStyle(
                  color: _muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: '6,000',
                style: TextStyle(
                  color: _ink,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '✓ Coincide con el total del pedido',
          style: TextStyle(
            color: _green,
            fontSize: 8,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _TankCard extends StatelessWidget {
  const _TankCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: _blueSoft,
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      children: [
        Container(
          width: 27,
          height: 27,
          decoration: const BoxDecoration(
            color: _blue,
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
          child: const Icon(
            Icons.inventory_2_outlined,
            color: Colors.white,
            size: 15,
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DESTINATION',
                style: TextStyle(
                  color: _muted,
                  fontSize: 6,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Diesel Tank A-102',
                style: TextStyle(
                  color: _ink,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Sector 4 · Current 12% (1,440 L)',
                style: TextStyle(color: _muted, fontSize: 7),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Change',
            style: TextStyle(
              color: _blue,
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ),
  );
}

class _SupplierCard extends StatelessWidget {
  const _SupplierCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      children: [
        Container(
          width: 27,
          height: 27,
          decoration: const BoxDecoration(
            color: _ink,
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
          child: const Icon(
            Icons.local_shipping_outlined,
            color: Colors.white,
            size: 14,
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FAVORITE',
                style: TextStyle(
                  color: _muted,
                  fontSize: 6,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Global Fuel Corp',
                style: TextStyle(
                  color: _ink,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '98.4% reliability · ETA 2.5h',
                style: TextStyle(color: _muted, fontSize: 7),
              ),
            ],
          ),
        ),
        const Text(
          '• Available',
          style: TextStyle(
            color: _green,
            fontSize: 8,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _DeliveryField extends StatelessWidget {
  const _DeliveryField();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Icon(Icons.schedule, color: _muted, size: 14),
        SizedBox(width: 7),
        Expanded(
          child: Text(
            'Sep 5, 08:00 – 12:00',
            style: TextStyle(
              color: _ink,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Icon(Icons.keyboard_arrow_down, color: _muted, size: 15),
      ],
    ),
  );
}

class _ConnectionErrorCard extends StatelessWidget {
  const _ConnectionErrorCard({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF1F2),
      border: Border.all(color: const Color(0xFFFFC7CC)),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      children: [
        Container(
          width: 27,
          height: 27,
          decoration: const BoxDecoration(color: _red, shape: BoxShape.circle),
          child: const Icon(Icons.wifi_off, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 7),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Connection error',
                style: TextStyle(
                  color: _red,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Couldn't reach the supplier service. Check your connection and retry.",
                style: TextStyle(color: _muted, fontSize: 7, height: 1.3),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onRetry,
          child: const Text(
            '↻ Retry',
            style: TextStyle(
              color: _red,
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ),
  );
}

class _CreationLoading extends StatelessWidget {
  const _CreationLoading();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _blueSoft,
          border: Border.all(color: const Color(0xFFD6E3FF)),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          children: [
            Container(
              width: 27,
              height: 27,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: _blue,
              ),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Checking availability',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Verifying supplier fleet · route ETA · fuel stock',
                  style: TextStyle(color: _muted, fontSize: 7),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      const _FieldCaption(label: 'FUEL TYPE'),
      const SizedBox(height: 6),
      const _LoadingGrid(),
      const SizedBox(height: 12),
      const _FieldCaption(label: 'ASSOCIATED TANK'),
      const SizedBox(height: 6),
      const _LoadingBlock(height: 52),
      const SizedBox(height: 12),
      const _FieldCaption(label: 'VALIDATING SUPPLIER'),
      const SizedBox(height: 6),
      const _LoadingBlock(height: 52),
    ],
  );
}

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();
  @override
  Widget build(BuildContext context) => GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    mainAxisSpacing: 6,
    crossAxisSpacing: 6,
    childAspectRatio: 2.25,
    children: [for (var i = 0; i < 4; i++) const _LoadingBlock(height: 41)],
  );
}

class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock({required this.height});
  final double height;
  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(9),
    ),
    child: const SizedBox.shrink(),
  );
}

class _SuccessDetails extends StatelessWidget {
  const _SuccessDetails();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(9),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ORDER NUMBER',
                    style: TextStyle(
                      color: _subtle,
                      fontSize: 7,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '#FT-88421',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF7DF),
                borderRadius: BorderRadius.all(Radius.circular(99)),
              ),
              child: const Text(
                '• Pendiente',
                style: TextStyle(
                  color: _orange,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            '▧ Copy ID',
            style: TextStyle(color: _muted, fontSize: 7),
          ),
        ),
        const Divider(height: 14, color: _line),
        const _SuccessRow(label: 'Fuel type', value: 'Diesel · ULSD B5'),
        const _SuccessRow(label: 'Quantity', value: '6,000 L'),
        const _SuccessRow(label: 'Tank', value: 'A-102 · Sector 4'),
        const _SuccessRow(label: 'Supplier', value: 'Global Fuel Corp'),
        const _SuccessRow(label: 'Required', value: 'Sep 5, 08:00 – 12:00'),
        const _SuccessRow(label: 'Estimated', value: '\$9,274.80'),
      ],
    ),
  );
}

class _SuccessRow extends StatelessWidget {
  const _SuccessRow({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: _muted, fontSize: 8),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: _ink,
            fontSize: 8,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _NewOrderAction extends StatelessWidget {
  const _NewOrderAction({required this.state, required this.onCreate});
  final NewOrderState state;
  final VoidCallback onCreate;
  @override
  Widget build(BuildContext context) {
    if (state == NewOrderState.success) return const SizedBox.shrink();
    final loading = state == NewOrderState.loading;
    final error = state == NewOrderState.error;
    return _OrangeButton(
      label: loading
          ? '◷  Processing...'
          : error
          ? 'Fix errors to continue  →'
          : 'Create Order  →',
      onPressed: loading
          ? null
          : error
          ? null
          : onCreate,
    );
  }
}

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({
    this.initialState = SalesReportState.dashboard,
    super.key,
  });
  final SalesReportState initialState;
  @override
  State<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  late SalesReportState _state = widget.initialState;
  @override
  Widget build(BuildContext context) {
    final dashboard = _state == SalesReportState.dashboard;
    final generating = _state == SalesReportState.generating;
    final ready = _state == SalesReportState.ready;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ready)
                Align(
                  alignment: Alignment.topRight,
                  child: _HeaderIcon(
                    icon: Icons.close,
                    label: 'Cerrar reporte',
                    onTap: () =>
                        setState(() => _state = SalesReportState.dashboard),
                  ),
                )
              else
                _Header(
                  title: generating
                      ? 'Generando reporte'
                      : 'Reportes de ventas',
                  subtitle: generating
                      ? 'Compilando 30 días...'
                      : _state == SalesReportState.empty
                      ? 'Sin datos en el rango'
                      : 'Análisis de operaciones',
                  actions: [
                    _HeaderIcon(
                      icon: dashboard
                          ? Icons.download_outlined
                          : Icons.more_horiz,
                      label: dashboard ? 'Exportar' : 'Opciones',
                      onTap: () {},
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              if (dashboard)
                const _SalesDashboard()
              else if (generating)
                const _SalesGenerating()
              else if (ready)
                const _SalesReady()
              else
                const _SalesEmpty(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: _SalesAction(
            state: _state,
            onGenerate: _generate,
            onReset: () => setState(() => _state = SalesReportState.dashboard),
          ),
        ),
      ),
    );
  }

  void _generate() {
    setState(() => _state = SalesReportState.generating);
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _state = SalesReportState.ready);
    });
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.subtitle,
    required this.actions,
  });
  final String title, subtitle;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Semantics(
        button: true,
        label: 'Volver',
        child: IconButton(
          onPressed: () {
            final navigator = Navigator.maybeOf(context);
            if (navigator?.canPop() ?? false) {
              navigator!.pop();
            } else {
              context.go('/home');
            }
          },
          tooltip: 'Volver',
          icon: const Icon(Icons.arrow_back, size: 17),
          style: IconButton.styleFrom(
            backgroundColor: _panel,
            fixedSize: const Size(32, 32),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _ink,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: -.2,
              ),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _muted, fontSize: 9),
              ),
          ],
        ),
      ),
      const SizedBox(width: 5),
      ...actions,
    ],
  );
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4),
    child: Semantics(
      button: true,
      label: label,
      child: IconButton(
        onPressed: onTap,
        tooltip: label,
        icon: Icon(icon, size: 14, color: _muted),
        style: IconButton.styleFrom(
          backgroundColor: _panel,
          fixedSize: const Size(32, 32),
          padding: EdgeInsets.zero,
        ),
      ),
    ),
  );
}

class _HistoryMetrics extends StatelessWidget {
  const _HistoryMetrics();
  @override
  Widget build(BuildContext context) => const Row(
    children: [
      Expanded(
        child: _MetricCard(
          label: 'CONSUMO',
          value: '42.8k\nL',
          accent: _blue,
          badge: '+8%',
        ),
      ),
      SizedBox(width: 6),
      Expanded(
        child: _MetricCard(
          label: 'PEDIDOS',
          value: '24',
          accent: _orange,
          badge: '+3',
        ),
      ),
      SizedBox(width: 6),
      Expanded(
        child: _MetricCard(
          label: 'TOTAL',
          value: 'S/\n63k',
          accent: _muted,
          badge: 'mes',
        ),
      ),
    ],
  );
}

class _ActiveMetrics extends StatelessWidget {
  const _ActiveMetrics();
  @override
  Widget build(BuildContext context) => const Row(
    children: [
      Expanded(
        child: _MetricCard(label: 'PENDING', value: '01', accent: _orange),
      ),
      SizedBox(width: 6),
      Expanded(
        child: _MetricCard(label: 'APPROVED', value: '01', accent: _blue),
      ),
      SizedBox(width: 6),
      Expanded(
        child: _MetricCard(label: 'TRANSIT', value: '01', accent: _orange),
      ),
    ],
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.accent,
    this.badge,
  });
  final String label, value;
  final Color accent;
  final String? badge;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(9, 8, 7, 8),
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: accent.withAlpha(22),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.insights_outlined, size: 9, color: accent),
            ),
            if (badge != null)
              Text(
                badge!,
                style: TextStyle(
                  color: accent,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                ),
              ),
          ],
        ),
        const SizedBox(height: 7),
        Text(
          label,
          style: const TextStyle(
            color: _subtle,
            fontSize: 7,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: _ink,
            fontSize: 12,
            height: 1.05,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _WeeklyBars extends StatelessWidget {
  const _WeeklyBars({required this.label, required this.action});
  final String label, action;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(11),
      border: Border.all(color: _line),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontSize: 7,
                fontWeight: FontWeight.w800,
                letterSpacing: .3,
              ),
            ),
            Text(
              action,
              style: const TextStyle(
                color: _blue,
                fontSize: 7,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        SizedBox(
          height: 58,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < 8; i++)
                _Bar(
                  value: [0.62, .58, .84, .76, .96, .68, .79, .88][i],
                  label: ['L', 'M', 'M', 'J', 'V', 'S', 'D', ''][i],
                  highlighted: i == 4,
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.value,
    required this.label,
    required this.highlighted,
  });
  final double value;
  final String label;
  final bool highlighted;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 17,
        height: 42 * value,
        decoration: BoxDecoration(
          color: highlighted ? _orange : const Color(0xFF5D8FEF),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
        ),
      ),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(color: _subtle, fontSize: 6)),
    ],
  );
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.selected,
    required this.labels,
    required this.onSelected,
    this.leading,
  });
  final String selected;
  final List<String> labels;
  final ValueChanged<String> onSelected;
  final String? leading;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        if (leading != null)
          _Chip(
            label: leading!,
            selected: true,
            icon: Icons.filter_alt_outlined,
            onTap: () {},
          ),
        if (leading != null) const SizedBox(width: 5),
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) const SizedBox(width: 5),
          _Chip(
            label: labels[i],
            selected: selected == labels[i],
            onTap: () => onSelected(labels[i]),
          ),
        ],
      ],
    ),
  );
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: label,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? _ink : Colors.white,
          border: Border.all(color: selected ? _ink : _line),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 11, color: selected ? Colors.white : _muted),
              const SizedBox(width: 3),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : _muted,
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _HistoryOrders extends StatelessWidget {
  const _HistoryOrders({required this.filter});
  final String filter;
  @override
  Widget build(BuildContext context) {
    final items = [
      const _OrderData(
        id: '#FT-88421',
        status: 'En tránsito',
        fuel: 'Diesel · ULSD B5',
        amount: '6,000 L',
        supplier: 'Global Fuel Corp',
        total: 'S/ 9,274.80',
        color: _orange,
      ),
      const _OrderData(
        id: '#FT-88418',
        status: 'Aprobado',
        fuel: 'Gasolina · 95',
        amount: '3,200 L',
        supplier: 'Midwest PetroLink',
        total: 'S/ 5,120.00',
        color: _blue,
      ),
    ];
    final shown = filter == 'Entregado' ? const <_OrderData>[] : items;
    return Column(
      children: [
        for (final item in shown)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _HistoryOrderCard(item: item),
          ),
      ],
    );
  }
}

class _OrderData {
  const _OrderData({
    required this.id,
    required this.status,
    required this.fuel,
    required this.amount,
    required this.supplier,
    required this.total,
    required this.color,
  });
  final String id, status, fuel, amount, supplier, total;
  final Color color;
}

class _HistoryOrderCard extends StatelessWidget {
  const _HistoryOrderCard({required this.item});
  final _OrderData item;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '${item.id}, ${item.status}, ${item.fuel}',
    child: InkWell(
      onTap: () => context.push('/orders/history/${item.id.substring(1)}'),
      borderRadius: BorderRadius.circular(11),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: _line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 17,
                  height: 17,
                  decoration: BoxDecoration(
                    color: item.color.withAlpha(22),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_shipping_outlined,
                    size: 10,
                    color: item.color,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.id,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _StatusTag(item.status, color: item.color),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${item.fuel}  ·  ${item.amount}  ·  ${item.supplier}',
              style: const TextStyle(color: _muted, fontSize: 7.5),
            ),
            const Divider(height: 13, color: _line),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOTAL',
                      style: TextStyle(
                        color: _subtle,
                        fontSize: 6,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      item.total,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Ver detalle  ›',
                  style: TextStyle(
                    color: _blue,
                    fontSize: 7,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _ActiveOrders extends StatelessWidget {
  const _ActiveOrders({required this.filter});
  final String filter;
  @override
  Widget build(BuildContext context) {
    const items = [
      _ActiveOrderData(
        id: '#FT-88421',
        status: 'En tránsito',
        fuel: 'Diesel · ULSD B5',
        quantity: '6,000 L',
        supplier: 'Global Fuel Corp',
        eta: '~1h 20m',
        color: _orange,
      ),
      _ActiveOrderData(
        id: '#FT-88418',
        status: 'Aprobado',
        fuel: 'Gasoline · 95',
        quantity: '3,200 L',
        supplier: 'Midwest PetroLink',
        eta: 'Dispatch 14:00',
        color: _blue,
      ),
      _ActiveOrderData(
        id: '#FT-88415',
        status: 'Pendiente',
        fuel: 'Diesel · ULSD B5',
        quantity: '4,000 L',
        supplier: 'Global Fuel Corp',
        eta: 'Pending approval',
        color: _orange,
      ),
    ];
    final shown = switch (filter) {
      'Pendiente 1' => items.where((item) => item.status == 'Pendiente'),
      'Aprobado 1' => items.where((item) => item.status == 'Aprobado'),
      'En tránsito 1' => items.where((item) => item.status == 'En tránsito'),
      _ => items,
    };
    return Column(
      children: [
        for (final item in shown) ...[
          _ActiveOrderCard(
            data: item,
            onTap: () => context.push('/orders/${item.id.substring(1)}'),
          ),
          if (item != shown.last) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _ActiveOrderData {
  const _ActiveOrderData({
    required this.id,
    required this.status,
    required this.fuel,
    required this.quantity,
    required this.supplier,
    required this.eta,
    required this.color,
  });
  final String id, status, fuel, quantity, supplier, eta;
  final Color color;
}

class _ActiveOrderCard extends StatelessWidget {
  const _ActiveOrderCard({required this.data, required this.onTap});
  final _ActiveOrderData data;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '${data.id}, ${data.status}, ${data.fuel}',
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: _line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  data.status == 'Pendiente'
                      ? Icons.hourglass_empty
                      : Icons.local_shipping_outlined,
                  size: 13,
                  color: data.color,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    data.id,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _StatusTag(data.status, color: data.color),
              ],
            ),
            const SizedBox(height: 7),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(8, 7, 8, 6),
              decoration: BoxDecoration(
                color: _panel,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _MiniData(
                          label: 'FUEL',
                          value: data.fuel,
                          icon: Icons.opacity_outlined,
                        ),
                      ),
                      Expanded(
                        child: _MiniData(
                          label: 'QUANTITY',
                          value: data.quantity,
                          icon: Icons.local_gas_station_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text(
                        'SUPPLIER',
                        style: TextStyle(
                          color: _subtle,
                          fontSize: 6,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        data.supplier,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: data.status == 'Pendiente'
                        ? .1
                        : data.status == 'Aprobado'
                        ? .45
                        : .76,
                    minHeight: 3,
                    color: data.color,
                    backgroundColor: _line,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  data.eta,
                  style: const TextStyle(color: _muted, fontSize: 7),
                ),
                const SizedBox(width: 7),
                const Text(
                  'Track  ›',
                  style: TextStyle(
                    color: _blue,
                    fontSize: 7,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _MiniData extends StatelessWidget {
  const _MiniData({
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label, value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 10, color: _muted),
      const SizedBox(width: 4),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _subtle,
              fontSize: 6,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: _ink,
              fontSize: 7,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ],
  );
}

class _StatusTag extends StatelessWidget {
  const _StatusTag(this.label, {required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      color: color.withAlpha(22),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      label,
      style: TextStyle(color: color, fontSize: 7, fontWeight: FontWeight.w800),
    ),
  );
}

class _SkeletonMetrics extends StatelessWidget {
  const _SkeletonMetrics();
  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (var i = 0; i < 3; i++)
        Expanded(
          child: Container(
            height: 39,
            margin: EdgeInsets.only(right: i == 2 ? 0 : 6),
            decoration: BoxDecoration(
              color: _panel,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
    ],
  );
}

class _SkeletonOrders extends StatelessWidget {
  const _SkeletonOrders();
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        height: 62,
        decoration: BoxDecoration(
          color: _panel,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      const SizedBox(height: 8),
      for (var i = 0; i < 3; i++)
        Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _panel,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const _SkeletonLine(width: 18),
                  const SizedBox(width: 7),
                  const _SkeletonLine(width: 75),
                  const Spacer(),
                  const _SkeletonLine(width: 42),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const _SkeletonLine(width: 120),
                  const Spacer(),
                  const _SkeletonLine(width: 70),
                ],
              ),
              const SizedBox(height: 12),
              const _SkeletonLine(width: double.infinity),
            ],
          ),
        ),
    ],
  );
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.width});
  final double width;
  @override
  Widget build(BuildContext context) => Container(
    width: width.isFinite ? width : double.infinity,
    height: 8,
    decoration: BoxDecoration(
      color: const Color(0xFFE8EEF6),
      borderRadius: BorderRadius.circular(99),
    ),
  );
}

class _EmptyIllustration extends StatelessWidget {
  const _EmptyIllustration({required this.icon, required this.color});
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    width: 82,
    height: 82,
    decoration: const BoxDecoration(color: _blueSoft, shape: BoxShape.circle),
    child: Center(
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Colors.white54,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: _blue, size: 34),
      ),
    ),
  );
}

class _TipBox extends StatelessWidget {
  const _TipBox({required this.history});
  final bool history;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: _blueSoft,
      border: Border.all(color: const Color(0xFFD9E5FF)),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info, size: 13, color: _blue),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            history
                ? 'Tip: Podrás filtrar por fecha, tipo de combustible y estado para revisar tu consumo mensual.'
                : 'Tip: puedes crear un pedido rápido desde la lista de tanques cuando el nivel esté bajo.',
            style: const TextStyle(color: _muted, fontSize: 8, height: 1.4),
          ),
        ),
      ],
    ),
  );
}

class _ErrorIllustration extends StatelessWidget {
  const _ErrorIllustration();
  @override
  Widget build(BuildContext context) => Container(
    width: 82,
    height: 82,
    decoration: const BoxDecoration(
      color: Color(0xFFFFF0F1),
      shape: BoxShape.circle,
    ),
    child: Container(
      margin: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: _red, shape: BoxShape.circle),
      child: const Icon(Icons.wifi_off, color: Colors.white, size: 27),
    ),
  );
}

class _ErrorMeta extends StatelessWidget {
  const _ErrorMeta({required this.history});
  final bool history;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ERROR CODE',
              style: TextStyle(
                color: _subtle,
                fontSize: 6,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              history ? 'HIST_ERR_503' : 'NET_ERR_502',
              style: TextStyle(
                color: _muted,
                fontSize: 8,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'LAST SYNC',
              style: TextStyle(
                color: _subtle,
                fontSize: 6,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              history ? 'hace 3 min' : '2 min ago',
              style: TextStyle(
                color: _muted,
                fontSize: 8,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _DeliveredBanner extends StatelessWidget {
  const _DeliveredBanner();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: _greenSoft,
      border: Border.all(color: const Color(0xFFC7F3DE)),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: _green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ENTREGADO CON ÉXITO',
                style: TextStyle(
                  color: _green,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Ayer, 17:45',
                style: TextStyle(
                  color: _ink,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Recibido por M. Sánchez · Sector 4',
                style: TextStyle(color: _muted, fontSize: 7),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _FuelMetric extends StatelessWidget {
  const _FuelMetric({
    required this.label,
    required this.value,
    required this.detail,
    required this.icon,
    required this.color,
  });
  final String label, value, detail;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(9),
      border: Border.all(color: _line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 15),
        const SizedBox(height: 7),
        Text(
          label,
          style: const TextStyle(
            color: _subtle,
            fontSize: 7,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: _ink,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(detail, style: const TextStyle(color: _muted, fontSize: 7)),
      ],
    ),
  );
}

class _DetailTable extends StatelessWidget {
  const _DetailTable({required this.title, required this.rows});
  final String title;
  final List<(String, String)> rows;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(9),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _subtle,
            fontSize: 7,
            fontWeight: FontWeight.w800,
            letterSpacing: .3,
          ),
        ),
        const SizedBox(height: 7),
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const Divider(height: 12, color: _line),
          Row(
            children: [
              Expanded(
                child: Text(
                  rows[i].$1,
                  style: const TextStyle(color: _muted, fontSize: 8),
                ),
              ),
              Expanded(
                child: Text(
                  rows[i].$2,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

class _CurrentStateBanner extends StatelessWidget {
  const _CurrentStateBanner();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF5E9),
      border: Border.all(color: const Color(0xFFFFD9AB)),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      children: [
        Container(
          width: 29,
          height: 29,
          decoration: const BoxDecoration(
            color: _orange,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.local_shipping_outlined,
            color: Colors.white,
            size: 17,
          ),
        ),
        const SizedBox(width: 8),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CURRENT STATE',
              style: TextStyle(
                color: _orange,
                fontSize: 7,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'En tránsito',
              style: TextStyle(
                color: _ink,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'ETA en ~1h 20m · 12 km remaining',
              style: TextStyle(color: _muted, fontSize: 7),
            ),
          ],
        ),
      ],
    ),
  );
}

class _DeliveryTimeline extends StatelessWidget {
  const _DeliveryTimeline();
  @override
  Widget build(BuildContext context) => const Column(
    children: [
      _TimelineStep(
        label: 'Pedido creado',
        detail: 'Today, 09:12',
        color: _orange,
        icon: Icons.check,
      ),
      _TimelineStep(
        label: 'Aprobado',
        detail: 'Today, 09:34',
        color: _blue,
        icon: Icons.check,
      ),
      _TimelineStep(
        label: 'En tránsito',
        detail: 'Today, 10:05',
        color: _muted,
        icon: Icons.local_shipping_outlined,
      ),
      _TimelineStep(
        label: 'Entregado',
        detail: 'ETA ~11:30',
        color: _line,
        icon: Icons.circle,
      ),
    ],
  );
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.label,
    required this.detail,
    required this.color,
    required this.icon,
  });
  final String label, detail;
  final Color color;
  final IconData icon;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 46,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          child: Column(
            children: [
              Container(
                width: 19,
                height: 19,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Icon(
                  icon,
                  color: color == _line ? _subtle : Colors.white,
                  size: 11,
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: color == _line ? _line : color.withAlpha(100),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: _ink,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(detail, style: const TextStyle(color: _muted, fontSize: 7)),
          ],
        ),
      ],
    ),
  );
}

class _SalesDashboard extends StatelessWidget {
  const _SalesDashboard();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Row(
        children: [
          Expanded(
            child: _MetricCard(
              label: 'VENTAS TOTALES',
              value: 'S/ 148,320',
              accent: _blue,
              badge: '+8.2%',
            ),
          ),
          SizedBox(width: 6),
          Expanded(
            child: _MetricCard(
              label: 'LITROS VENDIDOS',
              value: '42.8K L',
              accent: _blue,
              badge: '+5.6%',
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      const Row(
        children: [
          Expanded(
            child: _MetricCard(
              label: 'PEDIDOS',
              value: '24',
              accent: _orange,
              badge: '+3',
            ),
          ),
          SizedBox(width: 6),
          Expanded(
            child: _MetricCard(
              label: 'CLIENTES ATENDIDOS',
              value: '18',
              accent: _muted,
              badge: '+2',
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      const _SalesBars(),
      const SizedBox(height: 12),
      const Text(
        'Filtros del reporte',
        style: TextStyle(
          color: _ink,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'RANGO DE FECHAS',
        style: TextStyle(
          color: _subtle,
          fontSize: 7,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 5),
      const _SelectField(label: '01 Ago 2026 – 03 Sep 2026'),
      const SizedBox(height: 8),
      const Row(
        children: [
          Expanded(child: _SelectField(label: 'Todos los clientes')),
          SizedBox(width: 6),
          Expanded(child: _SelectField(label: 'Todos los combustibles')),
        ],
      ),
    ],
  );
}

class _SalesBars extends StatelessWidget {
  const _SalesBars();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(10, 9, 10, 7),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(11),
      border: Border.all(color: _line),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'VENTAS POR SEMANA',
              style: TextStyle(
                color: _muted,
                fontSize: 7,
                fontWeight: FontWeight.w800,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: _panel,
                borderRadius: BorderRadius.circular(99),
              ),
              child: const Row(
                children: [
                  Text(
                    '30d',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 7,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, size: 11, color: _muted),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 67,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < 8; i++)
                _Bar(
                  value: [0.48, .67, .72, .57, .9, .75, .82, .88][i],
                  label: 'S${i + 1}',
                  highlighted: i == 4,
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SelectField extends StatelessWidget {
  const _SelectField({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.schedule, size: 10, color: _muted),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _muted,
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, size: 12, color: _muted),
        ],
      ),
    ),
  );
}

class _SalesGenerating extends StatelessWidget {
  const _SalesGenerating();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: _blueSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.analytics_outlined,
                    color: _blue,
                    size: 15,
                  ),
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Compilando datos',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '24 pedidos · 18 clientes · 42.8k L',
                      style: TextStyle(color: _muted, fontSize: 7),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: const LinearProgressIndicator(
                value: .68,
                minHeight: 4,
                color: _orange,
                backgroundColor: _line,
              ),
            ),
            const SizedBox(height: 5),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '68% completado',
                  style: TextStyle(color: _muted, fontSize: 7),
                ),
                Text(
                  '~12s restantes',
                  style: TextStyle(color: _muted, fontSize: 7),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PROGRESO',
              style: TextStyle(
                color: _subtle,
                fontSize: 7,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            const _CheckRow(label: 'Consultando ventas', done: true),
            const _CheckRow(label: 'Agrupando por cliente', done: true),
            const _CheckRow(
              label: 'Calculando totales y márgenes',
              active: true,
            ),
            const _CheckRow(label: 'Generando gráficos'),
            const _CheckRow(label: 'Compilando PDF final'),
          ],
        ),
      ),
    ],
  );
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.label,
    this.done = false,
    this.active = false,
  });
  final String label;
  final bool done, active;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: done
                ? _greenSoft
                : active
                ? _blueSoft
                : _panel,
            shape: BoxShape.circle,
          ),
          child: Icon(
            done ? Icons.check : Icons.circle,
            size: done ? 9 : 5,
            color: done
                ? _green
                : active
                ? _blue
                : _subtle,
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: TextStyle(
            color: active ? _ink : _muted,
            fontSize: 8,
            fontWeight: active ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

class _SalesReady extends StatelessWidget {
  const _SalesReady();
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 20),
      Container(
        width: 67,
        height: 67,
        decoration: const BoxDecoration(
          color: _greenSoft,
          shape: BoxShape.circle,
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: _green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 28),
        ),
      ),
      const SizedBox(height: 14),
      const Text(
        'Reporte listo',
        style: TextStyle(
          color: _ink,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 5),
      const Text(
        'Generamos el reporte completo con\nmétricas, gráficos y desglose por cliente.',
        textAlign: TextAlign.center,
        style: TextStyle(color: _muted, fontSize: 9, height: 1.4),
      ),
      const SizedBox(height: 15),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.picture_as_pdf_outlined,
                  color: _red,
                  size: 18,
                ),
                const SizedBox(width: 7),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reporte_Ventas_Ago_Sep_202...',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _ink,
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '2.4 MB · 24 páginas · Generado hoy',
                        style: TextStyle(color: _muted, fontSize: 7),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz, size: 13, color: _muted),
              ],
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const _StatusTag('Listo', color: _green),
                const SizedBox(width: 5),
                const _StatusTag('Encriptado', color: _blue),
              ],
            ),
            const Divider(height: 14, color: _line),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'VENTAS',
                      style: TextStyle(color: _subtle, fontSize: 6),
                    ),
                    Text(
                      'S/148.3k',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'PEDIDOS',
                      style: TextStyle(color: _subtle, fontSize: 6),
                    ),
                    Text(
                      '24',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'CLIENTES',
                      style: TextStyle(color: _subtle, fontSize: 6),
                    ),
                    Text(
                      '18',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

class _SalesEmpty extends StatelessWidget {
  const _SalesEmpty();
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 35),
      const _EmptyIllustration(icon: Icons.bar_chart_outlined, color: _blue),
      const SizedBox(height: 14),
      const Text(
        'No existen ventas\nen este período',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _ink,
          fontSize: 16,
          height: 1.1,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        'Ajusta el rango de fechas o los filtros para\nver datos históricos. También puedes\niniciar operaciones nuevas para poblar el\nreporte.',
        textAlign: TextAlign.center,
        style: TextStyle(color: _muted, fontSize: 9, height: 1.45),
      ),
      const SizedBox(height: 15),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: _panel,
          borderRadius: BorderRadius.circular(9),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RANGO',
                  style: TextStyle(
                    color: _subtle,
                    fontSize: 6,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Ago 01',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'HASTA',
                  style: TextStyle(
                    color: _subtle,
                    fontSize: 6,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Ago 07',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

class _SalesAction extends StatelessWidget {
  const _SalesAction({
    required this.state,
    required this.onGenerate,
    required this.onReset,
  });
  final SalesReportState state;
  final VoidCallback onGenerate;
  final VoidCallback onReset;
  @override
  Widget build(BuildContext context) {
    if (state == SalesReportState.ready)
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: _OrangeButton(
              label: '⌄  Download PDF',
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reporte listo para descargar')),
              ),
            ),
          ),
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Compartir por email estará disponible al conectar el correo',
                ),
              ),
            ),
            child: const Text(
              'Compartir por email',
              style: TextStyle(color: _muted, fontSize: 8),
            ),
          ),
        ],
      );
    if (state == SalesReportState.empty)
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: _OrangeButton(
              label: '◷  Cambiar rango de fechas',
              onPressed: onReset,
            ),
          ),
          TextButton(
            onPressed: onReset,
            child: const Text(
              'Restablecer filtros',
              style: TextStyle(color: _muted, fontSize: 8),
            ),
          ),
        ],
      );
    return SizedBox(
      width: double.infinity,
      child: _OrangeButton(
        label: state == SalesReportState.generating
            ? '◷  Generando reporte...'
            : '▥  Generate Report  →',
        onPressed: state == SalesReportState.generating ? null : onGenerate,
      ),
    );
  }
}

class _OrangeButton extends StatelessWidget {
  const _OrangeButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: _orange,
      disabledBackgroundColor: const Color(0xFFFFD0A7),
      foregroundColor: _ink,
      disabledForegroundColor: Colors.white,
      minimumSize: const Size.fromHeight(34),
      shape: const StadiumBorder(),
      elevation: 2,
      textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
    ),
    child: Text(label),
  );
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 11),
    label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    style: OutlinedButton.styleFrom(
      foregroundColor: _ink,
      side: const BorderSide(color: _line),
      padding: const EdgeInsets.symmetric(vertical: 8),
      textStyle: const TextStyle(fontSize: 7, fontWeight: FontWeight.w700),
    ),
  );
}

class _DarkButton extends StatelessWidget {
  const _DarkButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: _ink,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      textStyle: const TextStyle(fontSize: 7, fontWeight: FontWeight.w700),
    ),
    child: Text(label),
  );
}

class _LightButton extends StatelessWidget {
  const _LightButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onTap,
    child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    style: OutlinedButton.styleFrom(
      foregroundColor: _blue,
      side: const BorderSide(color: Color(0xFFBCD4FF)),
      padding: const EdgeInsets.symmetric(vertical: 11),
      textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
    ),
  );
}
