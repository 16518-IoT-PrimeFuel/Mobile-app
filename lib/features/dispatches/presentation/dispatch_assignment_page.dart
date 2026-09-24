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
  late AssignmentState _state = widget.initialState;
  List<Order> _orders = const [];
  List<Vehicle> _vehicles = const [];
  List<Driver> _drivers = const [];
  int? _orderId, _vehicleId, _driverId;
  bool _loading = true, _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        ref.read(ordersRepositoryProvider).list(),
        ref.read(dispatchRepositoryProvider).vehicles(),
        ref.read(dispatchRepositoryProvider).drivers(),
      ]);
      if (!mounted) return;
      setState(() {
        _orders = (results[0] as List<Order>)
            .where(
              (order) =>
                  !order.request &&
                  order.status == OrderStatus.pending &&
                  int.tryParse(order.id) != null,
            )
            .toList();
        _vehicles = results[1] as List<Vehicle>;
        _drivers = results[2] as List<Driver>;
        _orderId ??= _orders.isEmpty ? null : int.tryParse(_orders.first.id);
        _loading = false;
      });
    } catch (error) {
      if (mounted)
        setState(() {
          _loading = false;
          _error = '$error';
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final success = _state == AssignmentState.success;
    final order = _firstOrNull(
      _orders.where((item) => int.tryParse(item.id) == _orderId),
    );
    final vehicle = _firstOrNull(
      _vehicles.where((item) => item.id == _vehicleId),
    );
    final driver = _firstOrNull(_drivers.where((item) => item.id == _driverId));
    return Scaffold(
      body: SafeArea(
        child: _DispatchShell(
          title: success
              ? 'Despacho asignado'
              : _state == AssignmentState.confirm ||
                    _state == AssignmentState.conflict
              ? 'Confirmar asignación'
              : 'Asignar recursos',
          subtitle: success
              ? ''
              : _state == AssignmentState.order
              ? 'Vehículo y conductor'
              : 'Revisa y asigna',
          onBack: () => context.pop(),
          child: success
              ? _AssignmentSuccess(
                  order: order,
                  vehicle: vehicle,
                  driver: driver,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_state != AssignmentState.conflict)
                      _AssignmentStepper(state: _state),
                    const SizedBox(height: 13),
                    if (_loading)
                      const Center(child: CircularProgressIndicator())
                    else if (_state == AssignmentState.conflict)
                      _AssignmentConflict(
                        onChange: () => setState(() {
                          _error = null;
                          _state = AssignmentState.vehicle;
                        }),
                      )
                    else ...[
                      if (_error != null) _InfoNotice(message: _error!),
                      _assignmentBody(order),
                    ],
                    const SizedBox(height: 14),
                    if (_state != AssignmentState.conflict && !_loading)
                      _assignmentAction(order, vehicle, driver),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: const FullTankBottomNav(active: 2),
    );
  }

  Widget _assignmentBody(Order? order) => switch (_state) {
    AssignmentState.order => _ChoiceList(
      title: 'SELECCIONA UN PEDIDO APROBADO',
      helper: '${_orders.length} pedidos listos para asignación',
      children: _orders.isEmpty
          ? [const Text('No hay pedidos pendientes para asignar.')]
          : [
              for (final item in _orders)
                _SelectableChoice(
                  selected: int.tryParse(item.id) == _orderId,
                  title: '#${item.id} · ${item.quantity.toStringAsFixed(0)} L',
                  detail: '${item.fuel} · ${item.deliveryAddress}',
                  icon: Icons.inventory_2_outlined,
                  onTap: () => setState(() => _orderId = int.tryParse(item.id)),
                ),
            ],
    ),
    AssignmentState.vehicle => _ChoiceList(
      title: 'VEHÍCULOS DISPONIBLES',
      helper: order == null
          ? 'Elige un pedido primero'
          : 'Capacidad compatible · ${order.quantity.toStringAsFixed(0)} L',
      children: [
        for (final item in _vehicles.where(
          (v) =>
              v.status.toUpperCase() == 'AVAILABLE' &&
              (order == null || v.capacity >= order.quantity),
        ))
          _SelectableChoice(
            selected: item.id == _vehicleId,
            title: item.plate,
            detail:
                '${item.brand} ${item.model} · ${item.capacity.toStringAsFixed(0)} L',
            icon: Icons.local_shipping_outlined,
            onTap: () => setState(() => _vehicleId = item.id),
          ),
      ],
    ),
    AssignmentState.driver => _ChoiceList(
      title: 'CONDUCTORES DISPONIBLES',
      helper:
          '${_drivers.where((d) => d.status.toUpperCase() == 'AVAILABLE').length} disponibles',
      children: [
        for (final item in _drivers.where(
          (d) => d.status.toUpperCase() == 'AVAILABLE',
        ))
          _SelectableChoice(
            selected: item.id == _driverId,
            title: item.name,
            detail: 'Licencia · ${item.licenseNumber}',
            icon: Icons.person_outline,
            onTap: () => setState(() => _driverId = item.id),
          ),
      ],
    ),
    AssignmentState.confirm => _AssignmentSummary(
      order: order,
      vehicle: _firstOrNull(_vehicles.where((item) => item.id == _vehicleId)),
      driver: _firstOrNull(_drivers.where((item) => item.id == _driverId)),
    ),
    AssignmentState.conflict ||
    AssignmentState.success => const SizedBox.shrink(),
  };

  Widget _assignmentAction(Order? order, Vehicle? vehicle, Driver? driver) =>
      _state == AssignmentState.confirm
      ? Column(
          children: [
            _InfoNotice(
              message:
                  'Se validará la disponibilidad de los recursos al crear el despacho.',
            ),
            const SizedBox(height: 10),
            _OrangeButton(
              label: _saving ? 'Asignando…' : 'Asignar recursos',
              onPressed:
                  _saving || order == null || vehicle == null || driver == null
                  ? null
                  : () => _assign(order, vehicle, driver),
            ),
          ],
        )
      : _OrangeButton(
          label: 'Continuar  →',
          onPressed: _canContinue(order)
              ? () => setState(
                  () => _state = switch (_state) {
                    AssignmentState.order => AssignmentState.vehicle,
                    AssignmentState.vehicle => AssignmentState.driver,
                    _ => AssignmentState.confirm,
                  },
                )
              : null,
        );

  bool _canContinue(Order? order) => switch (_state) {
    AssignmentState.order => _orderId != null,
    AssignmentState.vehicle => _vehicleId != null,
    AssignmentState.driver => _driverId != null,
    _ => order != null,
  };

  Future<void> _assign(Order order, Vehicle vehicle, Driver driver) async {
    setState(() => _saving = true);
    try {
      await ref
          .read(dispatchRepositoryProvider)
          .createDelivery(
            orderId: int.parse(order.id),
            driverId: driver.id,
            vehicleId: vehicle.id,
            scheduledDate: DateTime.now(),
          );
      if (mounted)
        setState(() {
          _saving = false;
          _state = AssignmentState.success;
        });
    } catch (error) {
      if (mounted)
        setState(() {
          _saving = false;
          _error = '$error';
          _state = AssignmentState.conflict;
        });
    }
  }
}

T? _firstOrNull<T>(Iterable<T> values) {
  for (final value in values) return value;
  return null;
}

class _AssignmentStepper extends StatelessWidget {
  const _AssignmentStepper({required this.state});
  final AssignmentState state;
  @override
  Widget build(BuildContext context) {
    final current = [
      AssignmentState.order,
      AssignmentState.vehicle,
      AssignmentState.driver,
      AssignmentState.confirm,
    ].indexOf(state);
    return Row(
      children: ['PEDIDO', 'VEHÍCULO', 'CONDUCTOR', 'CONFIRMAR']
          .asMap()
          .entries
          .map((entry) {
            final done = entry.key < current;
            final active = entry.key == current;
            return Expanded(
              child: Column(
                children: [
                  Container(
                    width: 19,
                    height: 19,
                    decoration: BoxDecoration(
                      color: done || active
                          ? (active ? _blue : _green)
                          : _panel,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: done
                        ? const Icon(Icons.check, color: Colors.white, size: 12)
                        : Text(
                            '${entry.key + 1}',
                            style: TextStyle(
                              color: active ? Colors.white : _subtle,
                              fontSize: 11.6,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    entry.value,
                    style: TextStyle(
                      color: active ? _blue : _subtle,
                      fontSize: 8.7,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            );
          })
          .toList(),
    );
  }
}
