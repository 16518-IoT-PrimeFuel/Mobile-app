part of 'inventory_page.dart';

class RestockPage extends ConsumerStatefulWidget {
  const RestockPage({required this.tankId, super.key});

  final String tankId;

  @override
  ConsumerState<RestockPage> createState() => _RestockPageState();
}

class _RestockPageState extends ConsumerState<RestockPage> {
  final _quantityController = TextEditingController(text: '3000');
  int _quantity = 3000;
  ReplenishmentOptions? _options;
  String? _optionsError;
  bool _optionsLoading = true;
  int? _providerId;
  int? _productId;
  DateTime _deliveryDate = DateUtils.dateOnly(DateTime.now());
  bool _submitting = false;
  String? _submitError;

  bool get _preview => ref.read(inventoryPreviewProvider);

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadOptions);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _loadOptions() async {
    if (_preview) {
      setState(() => _optionsLoading = false);
      return;
    }
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
        _optionsError = options.unavailableReason;
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

  void _setQuantity(int value, int maxQuantity) {
    final next = value.clamp(0, maxQuantity).toInt();
    setState(() {
      _quantity = next;
      _quantityController.text = next.toString();
      _quantityController.selection = TextSelection.collapsed(
        offset: _quantityController.text.length,
      );
    });
  }

  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final date = await showDatePicker(
      context: context,
      initialDate: _deliveryDate.isBefore(today) ? today : _deliveryDate,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );
    if (date != null && mounted) setState(() => _deliveryDate = date);
  }

  void _notify(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  Future<void> _submit(Tank tank) async {
    if (_submitting) return;
    if (_quantity <= 0) {
      _notify('Ingresa una cantidad primero.');
      return;
    }
    if (_preview) {
      _notify('Vista previa: no se envió ninguna solicitud.');
      return;
    }
    final options = _options;
    final product = options?.products
        .where((item) => item.id == _productId)
        .firstOrNull;
    if (options?.customerAccountId == null ||
        _providerId == null ||
        product == null) {
      _notify('Selecciona proveedor y producto.');
      return;
    }
    setState(() {
      _submitting = true;
      _submitError = null;
    });
    await ref
        .read(ordersControllerProvider.notifier)
        .create(
          customerAccountId: options!.customerAccountId!,
          fuel: product.name,
          quantity: _quantity.toDouble(),
          fuelProductId: product.id,
          tankId: tank.id,
          providerId: _providerId,
          // Empty: the backend defaults to the tank's site address.
          deliveryAddress: '',
          deliveryDate: _deliveryDate,
        );
    if (!mounted) return;
    final failed = ref.read(ordersControllerProvider).hasError;
    setState(() {
      _submitting = false;
      _submitError = failed
          ? 'No se pudo enviar la solicitud. Inténtalo de nuevo.'
          : null;
    });
    if (failed) return;
    _notify('Solicitud enviada al proveedor.');
    context.go('/orders');
  }

  @override
  Widget build(BuildContext context) {
    final preview = ref.watch(inventoryPreviewProvider);
    final tankState = ref.watch(inventoryTankProvider(widget.tankId));
    final apiTank = tankState.valueOrNull;
    if (apiTank == null && !preview) {
      return _InventoryShell(
        title: 'Solicitud de reposición',
        subtitle: 'Solicita combustible para el tanque',
        back: true,
        hasBottomNav: false,
        children: [
          Text(
            tankState.isLoading
                ? 'Cargando tanque…'
                : 'Tanque no disponible para solicitar reposición.',
          ),
        ],
      );
    }
    final tank =
        apiTank ??
        Tank(
          id: widget.tankId,
          siteId: 0,
          name: _tankForId(widget.tankId).name,
          fuelType: _tankForId(widget.tankId).type,
          capacity: _tankForId(widget.tankId).capacity.toDouble(),
          unit: 'L',
          currentLevel: _tankForId(widget.tankId).current.toDouble(),
          status: '',
          lastReadingAt: null,
        );
    final tankData = TankData.fromTank(tank);
    final maxQuantity = (tank.capacity - tank.currentLevel)
        .clamp(0, double.infinity)
        .toInt();
    final options = _options;
    final products =
        options?.products
            .where((item) => item.providerId == _providerId)
            .toList() ??
        const <ReplenishmentProduct>[];
    return _InventoryShell(
      title: 'Solicitud de reposición',
      subtitle: 'Solicita combustible para el tanque',
      back: true,
      hasBottomNav: false,
      children: [
        if (preview)
          const Padding(
            padding: EdgeInsets.only(bottom: 14),
            child: Text(
              'Vista previa con datos de ejemplo: no se enviará nada al proveedor.',
              style: TextStyle(color: FullTankColors.muted),
            ),
          ),
        _TargetTankCard(tank: tankData),
        const SizedBox(height: 26.1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const _InventorySectionLabel('Cantidad'),
            Text(
              'máx. ${_liters(maxQuantity)} L',
              style: const TextStyle(
                color: FullTankColors.muted,
                fontSize: 15.225,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 11.6),
        _QuantityPicker(
          controller: _quantityController,
          onChanged: (value) {
            final parsed = int.tryParse(value.replaceAll(',', '')) ?? 0;
            _quantity = parsed.clamp(0, maxQuantity).toInt();
          },
          onSubmitted: (value) => _setQuantity(
            int.tryParse(value.replaceAll(',', '')) ?? _quantity,
            maxQuantity,
          ),
          onQuickPick: (value) => _setQuantity(value, maxQuantity),
          maxQuantity: maxQuantity,
        ),
        const SizedBox(height: 26.1),
        if (!preview) ..._providerFields(options, products),
        const SizedBox(height: 17.4),
        InkWell(
          onTap: _pickDate,
          child: _FormInfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Fecha de entrega',
            value: _formatDate(_deliveryDate),
          ),
        ),
        if (_submitError != null)
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Text(_submitError!, style: const TextStyle(color: _red)),
          ),
        const SizedBox(height: 26.1),
        _PrimaryButton(
          label: _submitting ? 'Enviando…' : 'Enviar solicitud',
          onPressed: () => _submit(tank),
        ),
      ],
    );
  }

  List<Widget> _providerFields(
    ReplenishmentOptions? options,
    List<ReplenishmentProduct> products,
  ) {
    if (_optionsLoading) {
      return const [Center(child: CircularProgressIndicator())];
    }
    if (_optionsError != null || options == null) {
      return [
        Text(_optionsError ?? 'Opciones no disponibles.'),
        TextButton(onPressed: _loadOptions, child: const Text('Reintentar')),
      ];
    }
    return [
      DropdownButtonFormField<int>(
        initialValue: _providerId,
        items: [
          for (final provider in options.providers)
            DropdownMenuItem(value: provider.id, child: Text(provider.name)),
        ],
        onChanged: (value) => setState(() {
          _providerId = value;
          _productId = null;
        }),
        decoration: const InputDecoration(
          labelText: 'PROVEEDOR',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 17.4),
      DropdownButtonFormField<int>(
        key: ValueKey(_providerId),
        initialValue: _productId,
        items: [
          for (final product in products)
            DropdownMenuItem(value: product.id, child: Text(product.name)),
        ],
        onChanged: (value) => setState(() => _productId = value),
        hint: Text(
          _providerId == null
              ? 'Selecciona un proveedor primero'
              : 'Selecciona un producto',
        ),
        decoration: const InputDecoration(
          labelText: 'PRODUCTO',
          border: OutlineInputBorder(),
        ),
      ),
    ];
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
