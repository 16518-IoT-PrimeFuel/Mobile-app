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
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(orderDetailProvider(orderId));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(
                title: '#${orderId.replaceFirst('#', '')}',
                subtitle: history ? 'Detalle del pedido' : 'Estado del pedido',
                actions: [
                  _HeaderIcon(
                    icon: Icons.refresh,
                    label: 'Actualizar pedido',
                    onTap: () => ref.invalidate(orderDetailProvider(orderId)),
                  ),
                ],
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
      _DetailTable(
        title: 'DETALLES DEL PEDIDO',
        rows: [
          ('Número', '#${order.id.replaceFirst('#', '')}'),
          ('Estado', _orderStatusLabel(order.status)),
          ('Combustible', order.fuel),
          ('Cantidad', '${order.quantity.toStringAsFixed(0)} L'),
          ('Total', 'S/ ${order.total.toStringAsFixed(2)}'),
          if (order.deliveryAddress.isNotEmpty)
            ('Dirección', order.deliveryAddress),
        ],
      ),
      if (history) ...[
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: _DarkButton(
            label: 'Repetir pedido',
            onTap: () => context.push('/orders/new'),
          ),
        ),
      ],
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
  late final _quantityController = TextEditingController(
    text: '${widget.initialQuantity ?? 100}',
  );
  final _addressController = TextEditingController();
  List<FuelProduct> _products = const [];
  List<Equipment> _equipment = const [];
  int? _productId;
  int? _equipmentId;
  DateTime _deliveryDate = DateTime.now().add(const Duration(days: 1));
  Order? _createdOrder;
  bool _loadingOptions = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadOptions() async {
    try {
      final session = ref.read(authControllerProvider).session;
      final inventory = ref.read(inventoryRepositoryProvider);
      final products = await inventory.list();
      final equipment = await inventory.equipment(
        companyId: session?.companyId,
      );
      if (!mounted) return;
      setState(() {
        _products = products
            .where((p) => p.availability != ProductAvailability.inactive)
            .toList();
        _equipment = equipment;
        _productId = _products.isEmpty ? null : _products.first.id;
        _equipmentId =
            _equipment.any((item) => item.id == widget.initialEquipmentId)
            ? widget.initialEquipmentId
            : _equipment.isEmpty
            ? null
            : _equipment.first.id;
        if (_addressController.text.isEmpty && _equipment.isNotEmpty) {
          _addressController.text = _equipment.first.location;
        }
        _loadingOptions = false;
      });
    } catch (error) {
      if (mounted)
        setState(() {
          _loadingOptions = false;
          _errorMessage = '$error';
        });
    }
  }

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
          child: _NewOrderAction(
            state: _loadingOptions ? NewOrderState.loading : _state,
            onCreate: _create,
          ),
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
          _FieldCaption(label: 'PRODUCTO', error: error),
          const SizedBox(height: 6),
          if (_loadingOptions)
            const LinearProgressIndicator()
          else if (_products.isEmpty)
            const Text(
              'No hay productos activos disponibles.',
              style: TextStyle(color: _red),
            )
          else
            DropdownButtonFormField<int>(
              initialValue: _productId,
              items: [
                for (final p in _products)
                  DropdownMenuItem(
                    value: p.id,
                    child: Text(
                      '${p.name} · ${p.price.toStringAsFixed(2)} / ${p.unit}',
                    ),
                  ),
              ],
              onChanged: (value) => setState(() => _productId = value),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
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
