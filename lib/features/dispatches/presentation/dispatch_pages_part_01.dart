part of 'dispatch_pages.dart';

class TransportAvailabilityPage extends ConsumerStatefulWidget {
  const TransportAvailabilityPage({
    this.initialState = TransportAvailabilityState.content,
    super.key,
  });

  final TransportAvailabilityState initialState;

  @override
  ConsumerState<TransportAvailabilityPage> createState() =>
      _TransportAvailabilityPageState();
}

class _TransportAvailabilityPageState
    extends ConsumerState<TransportAvailabilityPage> {
  late TransportAvailabilityState _state = widget.initialState;
  var _capacity = 8000;
  var _availableOnly = false;
  List<Vehicle> _vehicles = const [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: _DispatchShell(
        title: 'Transporte disponible',
        subtitle: _state == TransportAvailabilityState.loading
            ? 'Cargando...'
            : _state == TransportAvailabilityState.empty
            ? 'Sin coincidencias'
            : 'Revisa recursos antes de asignar',
        onBack: () => context.go('/home'),
        action: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _DispatchMenu(),
            IconButton(
              tooltip: 'Actualizar disponibilidad',
              onPressed: _refresh,
              icon: const Icon(Icons.sync, size: 19),
              style: IconButton.styleFrom(
                backgroundColor: _panel,
                fixedSize: const Size(34, 34),
              ),
            ),
          ],
        ),
        child: _state == TransportAvailabilityState.loading
            ? const _AvailabilityLoading()
            : _state == TransportAvailabilityState.empty
            ? _AvailabilityEmpty(onAdjust: _openFilters)
            : _state == TransportAvailabilityState.conflict
            ? _AvailabilityConflict(onRefresh: _refresh)
            : _AvailabilityContent(
                capacity: _capacity,
                availableOnly: _availableOnly,
                onAdjust: _openFilters,
                vehicles: _vehicles,
              ),
      ),
    ),
    bottomNavigationBar: const FullTankBottomNav(active: 2),
  );

  Future<void> _refresh() async {
    setState(() => _state = TransportAvailabilityState.loading);
    try {
      final vehicles = await ref.read(dispatchRepositoryProvider).vehicles();
      if (!mounted) return;
      setState(() {
        _vehicles = vehicles;
        _state = vehicles.isEmpty
            ? TransportAvailabilityState.empty
            : TransportAvailabilityState.content;
      });
    } catch (_) {
      if (mounted) setState(() => _state = TransportAvailabilityState.conflict);
    }
  }

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<_DispatchFilters>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _DispatchFilterSheet(
        capacity: _capacity,
        availableOnly: _availableOnly,
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      _capacity = result.capacity;
      _availableOnly = result.availableOnly;
      final matches = _vehicles.any(
        (item) =>
            item.capacity >= result.capacity &&
            (!result.availableOnly || item.status.toUpperCase() == 'AVAILABLE'),
      );
      _state = matches
          ? TransportAvailabilityState.content
          : TransportAvailabilityState.empty;
    });
  }
}

class _AvailabilityContent extends StatelessWidget {
  const _AvailabilityContent({
    required this.capacity,
    required this.availableOnly,
    required this.onAdjust,
    required this.vehicles,
  });

  final int capacity;
  final bool availableOnly;
  final VoidCallback onAdjust;
  final List<Vehicle> vehicles;

  @override
  Widget build(BuildContext context) {
    final matching = vehicles
        .where((item) => item.capacity >= capacity)
        .toList();
    final available = matching
        .where((item) => item.status.toUpperCase() == 'AVAILABLE')
        .toList();
    final inDispatch = matching
        .where((item) => item.status.toUpperCase() == 'IN_ROUTE')
        .length;
    final visible = availableOnly ? available : matching;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FilterSummary(
          capacity: capacity,
          availableOnly: availableOnly,
          onTap: onAdjust,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 5,
          children: [
            _FilterChip(label: 'Todos ${matching.length}', selected: true),
            _FilterChip(
              label: 'Disponibles ${available.length}',
              color: _green,
            ),
            _FilterChip(label: 'En despacho $inDispatch', color: _amber),
          ],
        ),
        const SizedBox(height: 9),
        for (final vehicle in visible)
          Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: _VehicleCard(vehicle: vehicle),
          ),
      ],
    );
  }
}

class _AvailabilityLoading extends StatelessWidget {
  const _AvailabilityLoading();

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 7),
      const Row(
        children: [
          Expanded(child: _Skeleton()),
          SizedBox(width: 5),
          Expanded(child: _Skeleton()),
          SizedBox(width: 5),
          Expanded(child: _Skeleton()),
        ],
      ),
      const SizedBox(height: 9),
      for (var i = 0; i < 4; i++)
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: _SkeletonCard(),
        ),
    ],
  );
}

class _AvailabilityEmpty extends StatelessWidget {
  const _AvailabilityEmpty({required this.onAdjust});
  final VoidCallback onAdjust;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const _EmptyDispatchState(
        icon: Icons.local_shipping_outlined,
        title: 'No hay vehículos disponibles',
        message:
            'Ninguna unidad cumple los filtros aplicados. Ajusta la fecha o la capacidad para ampliar resultados.',
      ),
      const SizedBox(height: 19),
      _OrangeButton(label: 'Ajustar filtros', onPressed: onAdjust),
    ],
  );
}
