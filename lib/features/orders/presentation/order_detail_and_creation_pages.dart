part of 'order_pages.dart';

class OrderDetailPage extends ConsumerWidget {
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
              const SizedBox(height: 12),
              detail.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, _) => _DetailMessage(
                  message: 'No se pudo cargar el pedido: $error',
                  onRetry: () => ref.invalidate(orderDetailProvider(orderId)),
                ),
                data: (order) => order == null
                    ? const _DetailMessage(message: 'No se encontró el pedido.')
                    : _orderDetails(context, order),
              ),
            ],
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
    );
  }

  Widget _orderDetails(BuildContext context, Order order) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _StatusTag(
        _orderStatusLabel(order.status),
        color: order.status == OrderStatus.delivered
            ? _green
            : order.status == OrderStatus.rejected ||
                  order.status == OrderStatus.cancelled
            ? _red
            : _blue,
      ),
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

class _DetailMessage extends StatelessWidget {
  const _DetailMessage({required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      children: [
        Text(message, textAlign: TextAlign.center),
        if (onRetry != null)
          TextButton(onPressed: onRetry, child: const Text('Reintentar')),
      ],
    ),
  );
}

class NewOrderPage extends ConsumerStatefulWidget {
  const NewOrderPage({
    this.initialState = NewOrderState.defaultState,
    this.initialEquipmentId,
    this.initialQuantity,
    super.key,
  });

  final NewOrderState initialState;
  final int? initialEquipmentId;
  final double? initialQuantity;

  @override
  ConsumerState<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends ConsumerState<NewOrderPage> {
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
          if (_loadingOptions)
            const LinearProgressIndicator()
          else if (_products.isEmpty)
            const Text(
              'ⓘ  Selecciona un combustible para continuar.',
              style: TextStyle(
                color: _red,
                fontSize: 11.6,
                fontWeight: FontWeight.w700,
              ),
            ),
          const SizedBox(height: 12),
          const _FieldCaption(label: 'CANTIDAD'),
          const SizedBox(height: 6),
          TextField(
            controller: _quantityController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              suffixText: 'L',
            ),
          ),
          const SizedBox(height: 12),
          const _FieldCaption(label: 'EQUIPO DESTINO'),
          const SizedBox(height: 6),
          if (_equipment.isEmpty)
            const Text(
              'No hay equipos asociados a esta empresa.',
              style: TextStyle(color: _red),
            )
          else
            DropdownButtonFormField<int>(
              initialValue: _equipmentId,
              items: [
                for (final e in _equipment)
                  DropdownMenuItem(
                    value: e.id,
                    child: Text('${e.name} · ${e.location}'),
                  ),
              ],
              onChanged: (value) => setState(() => _equipmentId = value),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          const SizedBox(height: 12),
          const _FieldCaption(label: 'DIRECCIÓN DE ENTREGA'),
          const SizedBox(height: 6),
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          const _FieldCaption(label: 'FECHA DE ENTREGA'),
          const SizedBox(height: 6),
          OutlinedButton.icon(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _deliveryDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) setState(() => _deliveryDate = date);
            },
            icon: const Icon(Icons.calendar_today_outlined),
            label: Text(
              '${_deliveryDate.year}-${_deliveryDate.month.toString().padLeft(2, '0')}-${_deliveryDate.day.toString().padLeft(2, '0')}',
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 10),
            Text(
              _errorMessage!,
              style: const TextStyle(color: _red, fontSize: 10),
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
      _SuccessDetails(order: _createdOrder),
    ],
  );

  void _create() {
    final product = _products.where((p) => p.id == _productId).firstOrNull;
    final equipment = _equipment.where((e) => e.id == _equipmentId).firstOrNull;
    final quantity = double.tryParse(
      _quantityController.text.replaceAll(',', ''),
    );
    if (product == null ||
        equipment == null ||
        product.providerId == null ||
        quantity == null ||
        quantity <= 0 ||
        _addressController.text.trim().isEmpty) {
      setState(() {
        _state = NewOrderState.error;
        _errorMessage =
            'Completa producto, equipo, proveedor, cantidad y dirección.';
      });
      return;
    }
    setState(() {
      _state = NewOrderState.loading;
      _errorMessage = null;
    });
    ref
        .read(ordersControllerProvider.notifier)
        .create(
          fuelProductId: product.id,
          equipmentId: equipment.id,
          providerId: product.providerId!,
          fuel: product.name,
          quantity: quantity,
          unit: product.unit,
          deliveryAddress: _addressController.text.trim(),
          deliveryDate: _deliveryDate,
        )
        .then((order) {
          if (mounted)
            setState(() {
              _state = order == null
                  ? NewOrderState.error
                  : NewOrderState.success;
              _createdOrder = order;
              if (order == null)
                _errorMessage = 'No se pudo enviar la solicitud.';
            });
        });
  }
}
