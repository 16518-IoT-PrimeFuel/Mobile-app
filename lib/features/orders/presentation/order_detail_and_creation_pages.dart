part of 'order_pages.dart';

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
        padding: EdgeInsets.fromLTRB(29.0, 20.3, 29.0, 40.6),
        child: history ? _historyDetail(context) : _activeDetail(context),
      ),
    ),
    bottomNavigationBar: const FullTankBottomNav(active: 1),
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
              value: 'Diésel',
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
        subtitle: 'Seguimiento del pedido',
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
                fontSize: 11.6,
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
        'SEGUIMIENTO DE ENTREGA',
        style: TextStyle(
          color: _subtle,
          fontSize: 11.6,
          fontWeight: FontWeight.w800,
          letterSpacing: .4,
        ),
      ),
      const SizedBox(height: 8),
      const _DeliveryTimeline(),
      const SizedBox(height: 12),
      const _DetailTable(
        title: 'DETALLES DEL PEDIDO',
        rows: [
          ('Combustible', 'Diésel · ULSD B5'),
          ('Cantidad', '6,000 L'),
          ('Proveedor', 'Global Fuel Corp'),
        ],
      ),
      const SizedBox(height: 14),
      Row(
        children: [
          Expanded(
            child: _LightButton(
              label: 'Soporte',
              onTap: () => context.push('/account/help'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _OrangeButton(
              label: 'Seguimiento en vivo  →',
              onPressed: () {},
            ),
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
  String _fuel = 'Diésel';

  @override
  Widget build(BuildContext context) {
    final loading = _state == NewOrderState.loading;
    final success = _state == NewOrderState.success;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(29.0, 20.3, 29.0, 139.2),
          child: success
              ? _successBody(context)
              : _formBody(context, loading: loading),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: _NewOrderAction(state: _state, onCreate: _create),
            ),
          ),
          const FullTankBottomNav(active: 1),
        ],
      ),
    );
  }

  Widget _formBody(BuildContext context, {required bool loading}) {
    final error = _state == NewOrderState.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          title: loading ? 'Creando pedido' : 'Nuevo pedido',
          subtitle: loading
              ? 'Validando disponibilidad del proveedor...'
              : error
              ? 'Corrige los errores para continuar'
              : 'Registra una nueva solicitud de combustible',
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
          _FieldCaption(label: 'TIPO DE COMBUSTIBLE', error: error),
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
              'ⓘ  Selecciona un combustible para continuar.',
              style: TextStyle(
                color: _red,
                fontSize: 11.6,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 12),
          const _FieldCaption(label: 'MONTO DEPOSITADO'),
          const SizedBox(height: 6),
          const _MoneyCard(),
          const SizedBox(height: 12),
          const _FieldCaption(label: 'TANQUE ASOCIADO'),
          const SizedBox(height: 6),
          const _TankCard(),
          const SizedBox(height: 12),
          const _FieldCaption(label: 'PROVEEDOR PREFERIDO'),
          const SizedBox(height: 6),
          const _SupplierCard(),
          const SizedBox(height: 12),
          const _FieldCaption(label: 'HORARIO DE ENTREGA'),
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
          fontSize: 24.65,
          height: 1.1,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 9),
      const Text(
        'Tu solicitud fue enviada al proveedor.\nRecibirás una notificación cuando sea\naprobada.',
        textAlign: TextAlign.center,
        style: TextStyle(color: _muted, fontSize: 13.05, height: 1.45),
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
