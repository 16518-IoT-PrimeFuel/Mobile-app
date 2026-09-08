part of 'dispatch_pages.dart';

class TransportAvailabilityPage extends StatefulWidget {
  const TransportAvailabilityPage({
    this.initialState = TransportAvailabilityState.content,
    super.key,
  });

  final TransportAvailabilityState initialState;

  @override
  State<TransportAvailabilityPage> createState() =>
      _TransportAvailabilityPageState();
}

class _TransportAvailabilityPageState extends State<TransportAvailabilityPage> {
  late TransportAvailabilityState _state = widget.initialState;
  var _capacity = 8000;
  var _availableOnly = false;

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
                onClearConflict: _refresh,
              ),
      ),
    ),
    bottomNavigationBar: const FullTankBottomNav(active: 2),
  );

  Future<void> _refresh() async {
    setState(() => _state = TransportAvailabilityState.loading);
    await Future<void>.delayed(const Duration(milliseconds: 550));
    if (mounted) setState(() => _state = TransportAvailabilityState.content);
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
            item.capacityLiters >= result.capacity &&
            (!result.availableOnly || item.status == 'DISPONIBLE'),
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
    required this.onClearConflict,
  });

  final int capacity;
  final bool availableOnly;
  final VoidCallback onAdjust;
  final VoidCallback onClearConflict;

  @override
  Widget build(BuildContext context) {
    final matching = _vehicles
        .where((item) => item.capacityLiters >= capacity)
        .toList();
    final available = matching
        .where((item) => item.status == 'DISPONIBLE')
        .toList();
    final inDispatch = matching
        .where((item) => item.status == 'EN DESPACHO')
        .length;
    final visible = availableOnly ? available : matching;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LiveConflictBanner(onRefresh: onClearConflict),
        const SizedBox(height: 9),
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

