part of 'dispatch_pages.dart';

class DispatchAssignmentPage extends ConsumerStatefulWidget {
  const DispatchAssignmentPage({
    this.initialState = AssignmentState.order,
    super.key,
  });
  final AssignmentState initialState;

  @override
  ConsumerState<DispatchAssignmentPage> createState() =>
      _DispatchAssignmentPageState();
}

class _DispatchAssignmentPageState
    extends ConsumerState<DispatchAssignmentPage> {
  final _notes = TextEditingController();
  List<Map> _orders = const [];
  List<Map> _tankers = const [];
  List<Map> _drivers = const [];
  int? _orderId;
  int? _tankerId;
  int? _driverId;
  DateTime? _deliveryDate;
  DateTime? _windowStart;
  DateTime? _windowEnd;
  bool _loading = true;
  bool _submitting = false;
  String? _error;
  String? _unavailable;
  String? _createdId;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadOptions);
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _loadOptions() async {
    final providerId = ref.read(authControllerProvider).session?.providerId;
    if (providerId == null) {
      setState(() {
        _loading = false;
        _unavailable =
            'Inicia sesión con una cuenta de proveedor activa para asignar entregas.';
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _unavailable = null;
    });
    try {
      final api = ref.read(fullTankApiProvider);
      final results = await Future.wait<dynamic>([
        api.providerOrders(providerId),
        api.eligibleFleet(),
        api.eligibleDrivers(),
      ]);
      final orders = _asMaps(results[0]).where(_isAssignable).toList();
      final tankers = _asMaps(results[1]).where(_isAvailable).toList();
      final drivers = _asMaps(results[2]).where(_isAvailable).toList();
      if (!mounted) return;
      setState(() {
        _orders = orders;
        _tankers = tankers;
        _drivers = drivers;
        _orderId = _int(orders.firstOrNull?['id']);
        _tankerId = _int(tankers.firstOrNull?['id']);
        _driverId = _int(drivers.firstOrNull?['id']);
        _loading = false;
        _unavailable = orders.isEmpty
            ? 'No hay pedidos aceptados listos para asignación.'
            : tankers.isEmpty
            ? 'No hay cisternas disponibles para asignar.'
            : drivers.isEmpty
            ? 'No hay conductores disponibles para asignar.'
            : null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'No se pudieron cargar las opciones de asignación: $error';
      });
    }
  }

  List<Map> _asMaps(Object? value) =>
      value is List ? value.whereType<Map>().toList() : const [];

  bool _isAssignable(Map order) =>
      _int(order['id']) != null &&
      const {
        'APPROVED',
        'CONFIRMED',
        'PAID',
        'ACCEPTED',
      }.contains('${order['status']}'.toUpperCase());

  bool _isAvailable(Map item) =>
      _int(item['id']) != null &&
      !const {
        'INACTIVE',
        'UNAVAILABLE',
        'DEACTIVATED',
      }.contains('${item['status']}'.toUpperCase());

  int? _int(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value');

  @override
  Widget build(BuildContext context) {
    final done = _createdId != null;
    return Scaffold(
      body: SafeArea(
        child: _DispatchShell(
          title: done ? 'Entrega asignada' : 'Asignar entrega',
          subtitle: done
              ? 'La asignación se registró correctamente.'
              : 'Selecciona los recursos y la ventana de entrega',
          onBack: () => context.pop(),
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: 'Cargando opciones',
                  ),
                )
              : done
              ? _success()
              : _form(),
        ),
      ),
      bottomNavigationBar: const FullTankBottomNav(active: 2),
    );
  }

  Widget _form() {
    if (_error != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_error!, style: const TextStyle(color: _red)),
          const SizedBox(height: 12),
          _OrangeButton(label: 'Reintentar', onPressed: _loadOptions),
        ],
      );
    }
    if (_unavailable != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_unavailable!, style: const TextStyle(color: _muted)),
          const SizedBox(height: 12),
          _OrangeButton(label: 'Actualizar opciones', onPressed: _loadOptions),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _assignmentDropdown<int>(
          label: 'PEDIDO ACEPTADO',
          value: _orderId,
          items: _orders
              .map(
                (order) => DropdownMenuItem(
                  value: _int(order['id']),
                  child: Text(
                    '#${order['id']} · ${order['customerName'] ?? order['buyerCompanyName'] ?? 'Cliente'}',
                  ),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _orderId = value),
        ),
        _assignmentDropdown<int>(
          label: 'CISTERNA DISPONIBLE',
          value: _tankerId,
          items: _tankers
              .map(
                (tanker) => DropdownMenuItem(
                  value: _int(tanker['id']),
                  child: Text(
                    '${tanker['licensePlate'] ?? tanker['name'] ?? 'Tanker'} · ${tanker['brand'] ?? ''} ${tanker['model'] ?? ''}'
                        .trim(),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _tankerId = value),
        ),
        _assignmentDropdown<int>(
          label: 'CONDUCTOR DISPONIBLE',
          value: _driverId,
          items: _drivers
              .map(
                (driver) => DropdownMenuItem(
                  value: _int(driver['id']),
                  child: Text(
                    '${driver['firstName'] ?? ''} ${driver['lastName'] ?? ''}'
                        .trim(),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _driverId = value),
        ),
        OutlinedButton.icon(
          onPressed: _chooseDate,
          icon: const Icon(Icons.calendar_today_outlined),
          label: Text(
            _deliveryDate == null
                ? 'Seleccionar fecha'
                : _format(_deliveryDate!),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _chooseTime(start: true),
                child: Text(
                  _windowStart == null
                      ? 'Inicio de ventana'
                      : 'Desde ${_time(_windowStart!)}',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _chooseTime(start: false),
                child: Text(
                  _windowEnd == null
                      ? 'Fin de ventana'
                      : 'Hasta ${_time(_windowEnd!)}',
                ),
              ),
            ),
          ],
        ),
        TextField(
          controller: _notes,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Notas para la entrega',
            border: OutlineInputBorder(),
          ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_error!, style: const TextStyle(color: _red)),
          ),
        const SizedBox(height: 14),
        _OrangeButton(
          label: _submitting ? 'Asignando…' : 'Confirmar asignación',
          onPressed: _canSubmit && !_submitting ? _submit : null,
        ),
      ],
    );
  }

  Widget _assignmentDropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    ),
  );

  bool get _canSubmit =>
      _orderId != null &&
      _tankerId != null &&
      _driverId != null &&
      _deliveryDate != null &&
      _windowStart != null &&
      _windowEnd != null &&
      _windowEnd!.isAfter(_windowStart!);

  Future<void> _chooseDate() async {
    final now = DateUtils.dateOnly(DateTime.now());
    final date = await showDatePicker(
      context: context,
      initialDate: _deliveryDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    setState(() {
      _deliveryDate = date;
      _windowStart = null;
      _windowEnd = null;
    });
  }

  Future<void> _chooseTime({required bool start}) async {
    if (_deliveryDate == null) {
      setState(() => _error = 'Selecciona primero la fecha de entrega.');
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        (start ? _windowStart : _windowEnd) ??
            DateTime(
              _deliveryDate!.year,
              _deliveryDate!.month,
              _deliveryDate!.day,
              start ? 9 : 12,
            ),
      ),
    );
    if (time == null || !mounted) return;
    final selected = DateTime(
      _deliveryDate!.year,
      _deliveryDate!.month,
      _deliveryDate!.day,
      time.hour,
      time.minute,
    );
    setState(() {
      if (start) {
        _windowStart = selected;
        if (_windowEnd != null && !_windowEnd!.isAfter(selected))
          _windowEnd = null;
      } else {
        _windowEnd = selected;
      }
      _error = null;
    });
  }

  String _format(DateTime value) =>
      '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
  String _time(DateTime value) =>
      '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';

  Future<void> _submit() async {
    if (!_canSubmit || _submitting) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final id = await ref
          .read(dispatchRepositoryProvider)
          .createDelivery(
            orderId: _orderId!,
            driverId: _driverId!,
            tankerId: _tankerId!,
            scheduledDate: _deliveryDate!,
            commandId:
                'mobile-$_orderId-${DateTime.now().microsecondsSinceEpoch}',
            windowStart: _windowStart!,
            windowEnd: _windowEnd!,
            notes: _notes.text.trim(),
          );
      if (!mounted) return;
      if (id.isEmpty)
        throw const FormatException(
          'The assignment response has no delivery ID.',
        );
      setState(() {
        _createdId = id;
        _submitting = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudo asignar la entrega: $error';
        _submitting = false;
      });
    }
  }

  Widget _success() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Icon(Icons.check_circle_outline, color: _green, size: 44),
      const SizedBox(height: 10),
      Text(
        'La entrega #$_createdId quedó asignada.',
        style: const TextStyle(color: _ink, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 10),
      Text(
        'Pedido #$_orderId · ${_format(_deliveryDate!)} · ${_time(_windowStart!)}–${_time(_windowEnd!)}',
      ),
    ],
  );
}
