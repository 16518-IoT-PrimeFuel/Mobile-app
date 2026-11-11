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
    final order =
        ref.watch(orderProvider(orderId)).valueOrNull ??
        fallbackOrder(orderId, history: history);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(29.0, 20.3, 29.0, 40.6),
          child: history
              ? _historyDetail(context, order)
              : _activeDetail(context, order),
        ),
      ),
      bottomNavigationBar: const FullTankBottomNav(active: 1),
    );
  }

  Widget _historyDetail(BuildContext context, Order order) => Column(
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
            // No invoice endpoint exists in the backend yet.
            child: const _SmallButton(
              label: 'Factura: No disponible aún',
              icon: Icons.receipt_long_outlined,
              onTap: null,
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
      Row(
        children: [
          Expanded(
            child: _FuelMetric(
              label: 'COMBUSTIBLE',
              value: order.fuel,
              detail: '',
              icon: Icons.opacity_outlined,
              color: _blue,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _FuelMetric(
              label: 'CANTIDAD',
              value: order.quantity.toStringAsFixed(0),
              detail: 'L',
              icon: Icons.local_gas_station_outlined,
              color: _orange,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      _DetailTable(
        title: 'DETALLES DEL PEDIDO',
        rows: [
          ('Número', '#${order.id}'),
          ('Fecha de creación', 'Ayer, 09:30'),
          ('Fecha de entrega', 'Ayer, 17:45'),
          (
            'Proveedor',
            order.deliveryAddress.isEmpty
                ? 'Proveedor asignado'
                : order.deliveryAddress,
          ),
          ('Tanque destino', 'A-102 · Sector 4'),
          ('Vehículo', 'ABC-921 · M. Ríos'),
        ],
      ),
      const SizedBox(height: 12),
      _DetailTable(
        title: 'PAGO',
        rows: [('Estado', 'Aprobado'), ('Payment ID', 'PAY-88402-A')],
      ),
    ],
  );

  Widget _activeDetail(BuildContext context, Order order) => Column(
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
      _ApiDeliveryTimeline(orderId: orderId),
      const SizedBox(height: 12),
      _DetailTable(
        title: 'DETALLES DEL PEDIDO',
        rows: [
          ('Combustible', order.fuel),
          ('Cantidad', orderQuantityLabel(order.quantity)),
          (
            'Proveedor',
            order.deliveryAddress.isEmpty
                ? 'Proveedor asignado'
                : order.deliveryAddress,
          ),
        ],
      ),
      const SizedBox(height: 14),
      Row(
        children: [
          // Live tracking is hidden: the backend only lets the owning provider
          // or the assigned driver read GET /api/deliveries/{id}/tracking.
          Expanded(
            child: _LightButton(
              label: 'Soporte',
              onTap: () => context.push('/account/help'),
            ),
          ),
        ],
      ),
    ],
  );
}

class NewOrderPage extends ConsumerStatefulWidget {
  const NewOrderPage({
    this.initialState = NewOrderState.defaultState,
    super.key,
  });

  final NewOrderState initialState;

  @override
  ConsumerState<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends ConsumerState<NewOrderPage> {
  // Query parameters and legacy callers cannot manufacture a successful order.
  NewOrderState _state = NewOrderState.defaultState;
  final _quantity = TextEditingController();
  final _address = TextEditingController();
  ReplenishmentOptions? _options;
  List<Tank> _tanks = const [];
  int? _siteId;
  String? _tankId;
  int? _providerId;
  int? _productId;
  DateTime? _deliveryDate;
  bool _optionsLoading = true;
  bool _tanksLoading = false;
  String? _optionsError;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadOptions);
  }

  @override
  void dispose() {
    _quantity.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _loadOptions() async {
    final session = ref.read(authControllerProvider).session;
    setState(() {
      _optionsLoading = true;
      _optionsError = null;
    });
    try {
      final options = await ref
          .read(replenishmentOptionsRepositoryProvider)
          .load(
            companyId: session?.companyId,
            memberships: session?.memberships ?? const [],
          );
      if (!mounted) return;
      setState(() {
        _options = options;
        _optionsLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _optionsError = 'No se pudieron cargar las opciones: $error';
        _optionsLoading = false;
      });
    }
  }

  Future<void> _selectSite(int? siteId) async {
    setState(() {
      _siteId = siteId;
      _tankId = null;
      _tanks = const [];
      _tanksLoading = siteId != null;
    });
    final companyId = ref.read(authControllerProvider).session?.companyId;
    if (companyId == null || siteId == null) return;
    try {
      final tanks = await ref
          .read(replenishmentOptionsRepositoryProvider)
          .tanks(companyId: companyId, siteId: siteId);
      if (mounted) setState(() => _tanks = tanks);
    } catch (error) {
      if (mounted)
        setState(
          () => _optionsError = 'No se pudieron cargar los tanques: $error',
        );
    } finally {
      if (mounted) setState(() => _tanksLoading = false);
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
              child: _NewOrderAction(
                state: _state,
                enabled: _canSubmit,
                onCreate: _create,
              ),
            ),
          ),
          const FullTankBottomNav(active: 1),
        ],
      ),
    );
  }

  Widget _formBody(BuildContext context, {required bool loading}) {
    final error = _state == NewOrderState.error;
    final options = _options;
    final products =
        options?.products
            .where((product) => product.providerId == _providerId)
            .toList() ??
        const <ReplenishmentProduct>[];
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
        if (_optionsLoading)
          const Center(
            child: CircularProgressIndicator(
              semanticsLabel: 'Cargando opciones de pedido',
            ),
          )
        else if (_optionsError != null)
          _UnavailableCard(message: _optionsError!, onRetry: _loadOptions)
        else if (options?.unavailableReason != null)
          _UnavailableCard(
            message: options!.unavailableReason!,
            onRetry: _loadOptions,
          )
        else if (options == null || options.customerAccountId == null)
          const _UnavailableCard(
            message:
                'No hay una cuenta de cliente disponible para esta empresa.',
          )
        else if (loading)
          const _CreationLoading()
        else ...[
          if (error)
            _ConnectionErrorCard(
              onRetry: () =>
                  setState(() => _state = NewOrderState.defaultState),
            ),
          if (error) const SizedBox(height: 10),
          _selectionField<int>(
            label: 'SITIO DE ENTREGA',
            value: _siteId,
            items: options.sites
                .map(
                  (site) =>
                      DropdownMenuItem(value: site.id, child: Text(site.name)),
                )
                .toList(),
            onChanged: _selectSite,
          ),
          _selectionField<String>(
            label: 'TANQUE',
            value: _tankId,
            items: _tanks
                .map(
                  (tank) => DropdownMenuItem(
                    value: tank.id,
                    child: Text('${tank.name} · ${tank.level}%'),
                  ),
                )
                .toList(),
            onChanged: _tanksLoading
                ? null
                : (value) => setState(() => _tankId = value),
            hint: _tanksLoading ? 'Cargando tanques…' : 'Selecciona un tanque',
          ),
          if (_siteId != null && !_tanksLoading && _tanks.isEmpty)
            _inlineFormMessage(
              'Este sitio no tiene tanques activos disponibles.',
            ),
          _selectionField<int>(
            label: 'PROVEEDOR',
            value: _providerId,
            items: options.providers
                .map(
                  (provider) => DropdownMenuItem(
                    value: provider.id,
                    child: Text(provider.name),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() {
              _providerId = value;
              _productId = null;
            }),
          ),
          if (_providerId != null && products.isEmpty)
            _inlineFormMessage(
              'Este proveedor no tiene productos activos disponibles.',
            ),
          _selectionField<int>(
            label: 'PRODUCTO',
            value: _productId,
            items: products
                .map(
                  (product) => DropdownMenuItem(
                    value: product.id,
                    child: Text(product.name),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _productId = value),
            hint: _providerId == null
                ? 'Selecciona un proveedor primero'
                : 'Selecciona un producto',
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _quantity,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Cantidad (L)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _address,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Dirección de entrega',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _selectDeliveryDate,
            icon: const Icon(Icons.calendar_today_outlined),
            label: Text(
              _deliveryDate == null
                  ? 'Seleccionar fecha de entrega'
                  : '${_deliveryDate!.year}-${_deliveryDate!.month.toString().padLeft(2, '0')}-${_deliveryDate!.day.toString().padLeft(2, '0')}',
            ),
          ),
          if (error)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                'Revisa los campos obligatorios e inténtalo de nuevo.',
                style: TextStyle(color: _red),
              ),
            ),
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
      Text(
        '${_quantity.text.trim()} L · ${_options?.products.where((item) => item.id == _productId).firstOrNull?.name ?? ''}',
        textAlign: TextAlign.center,
        style: const TextStyle(color: _ink, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 6),
      Text(
        '${_options?.sites.where((item) => item.id == _siteId).firstOrNull?.name ?? ''} · ${_address.text.trim()}',
        textAlign: TextAlign.center,
        style: const TextStyle(color: _muted, fontSize: 12),
      ),
    ],
  );

  Future<void> _create() async {
    if (!_canSubmit) return;
    setState(() => _state = NewOrderState.loading);
    await ref
        .read(ordersControllerProvider.notifier)
        .create(
          customerAccountId: _options!.customerAccountId!,
          fuel: _options!.products
              .firstWhere((item) => item.id == _productId)
              .name,
          quantity: double.parse(_quantity.text.trim()),
          fuelProductId: _productId,
          tankId: _tankId,
          providerId: _providerId,
          deliveryAddress: _address.text.trim(),
          deliveryDate: _deliveryDate!,
        );
    if (!mounted) return;
    setState(
      () => _state = ref.read(ordersControllerProvider).hasError
          ? NewOrderState.error
          : NewOrderState.success,
    );
  }

  bool get _canSubmit =>
      !_optionsLoading &&
      _options?.customerAccountId != null &&
      _siteId != null &&
      _tankId != null &&
      _providerId != null &&
      _productId != null &&
      (double.tryParse(_quantity.text.trim()) ?? 0) > 0 &&
      _address.text.trim().isNotEmpty &&
      _deliveryDate != null &&
      _state != NewOrderState.loading &&
      _state != NewOrderState.success;

  Future<void> _selectDeliveryDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final date = await showDatePicker(
      context: context,
      initialDate: _deliveryDate ?? today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );
    if (date != null && mounted) setState(() => _deliveryDate = date);
  }

  Widget _selectionField<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?>? onChanged,
    String? hint,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      hint: Text(hint ?? 'Selecciona una opción'),
    ),
  );

  Widget _inlineFormMessage(String message) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(message, style: const TextStyle(color: _muted)),
  );
}

class _UnavailableCard extends StatelessWidget {
  const _UnavailableCard({required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, semanticLabel: 'Información'),
          const SizedBox(height: 8),
          Text(message),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    ),
  );
}
