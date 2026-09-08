import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../home/presentation/home_page.dart';

const _ink = Color(0xFF202735);
const _muted = Color(0xFF718096);
const _subtle = Color(0xFF94A3B8);
const _line = Color(0xFFE2E8F0);
const _panel = Color(0xFFF5F7FA);
const _orange = Color(0xFFFFAD0A);
const _blue = Color(0xFF3157C9);
const _blueSoft = Color(0xFFEEF3FF);
const _green = Color(0xFF10B981);
const _greenSoft = Color(0xFFEAFBF3);
const _amber = Color(0xFFF59E0B);
const _amberSoft = Color(0xFFFFF8E7);
const _red = Color(0xFFEF4444);
const _redSoft = Color(0xFFFFF0F0);

enum TransportAvailabilityState { content, loading, empty, conflict }

TransportAvailabilityState dispatchAvailabilityStateFromQuery(String? value) =>
    switch (value) {
      'loading' => TransportAvailabilityState.loading,
      'empty' => TransportAvailabilityState.empty,
      'conflict' => TransportAvailabilityState.conflict,
      _ => TransportAvailabilityState.content,
    };

enum AssignmentState { order, vehicle, driver, confirm, conflict, success }

AssignmentState dispatchAssignmentStateFromQuery(String? value) =>
    switch (value) {
      'vehicle' => AssignmentState.vehicle,
      'driver' => AssignmentState.driver,
      'confirm' => AssignmentState.confirm,
      'conflict' => AssignmentState.conflict,
      'success' => AssignmentState.success,
      _ => AssignmentState.order,
    };

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

class _AvailabilityConflict extends StatelessWidget {
  const _AvailabilityConflict({required this.onRefresh});
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 17),
      const Icon(Icons.warning_amber_rounded, color: _red, size: 42),
      const SizedBox(height: 10),
      const Text(
        'Conflicto de disponibilidad',
        style: TextStyle(
          color: _ink,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 5),
      const Text(
        'TK-4421 acaba de ser asignada a otro pedido. Actualiza para ver recursos en tiempo real.',
        textAlign: TextAlign.center,
        style: TextStyle(color: _muted, fontSize: 9, height: 1.4),
      ),
      const SizedBox(height: 18),
      _OrangeButton(label: 'Actualizar disponibilidad', onPressed: onRefresh),
    ],
  );
}

class _LiveConflictBanner extends StatelessWidget {
  const _LiveConflictBanner({required this.onRefresh});
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: _amberSoft,
      border: Border.all(color: const Color(0xFFFDE4A7)),
    ),
    child: Row(
      children: [
        const Icon(Icons.warning_amber_rounded, color: _amber, size: 20),
        const SizedBox(width: 7),
        const Expanded(
          child: Text(
            'TK-3812 acaba de ser asignada a otro pedido. Actualiza disponibilidad.',
            style: TextStyle(
              color: _ink,
              fontSize: 8,
              height: 1.25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: onRefresh,
          child: const Text(
            'Actualizar',
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    ),
  );
}

class _FilterSummary extends StatelessWidget {
  const _FilterSummary({
    required this.capacity,
    required this.availableOnly,
    required this.onTap,
  });
  final int capacity;
  final bool availableOnly;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Expanded(
            child: _Info(
              label: 'FECHA',
              value: 'Hoy · 05 sep',
              icon: Icons.calendar_today_outlined,
            ),
          ),
          const Expanded(
            child: _Info(
              label: 'HORA',
              value: '14:00–18:00',
              icon: Icons.schedule_outlined,
            ),
          ),
          Expanded(
            child: _Info(
              label: 'CAPACIDAD',
              value: '≥ ${capacity.toStringAsFixed(0)} L',
              icon: Icons.water_drop_outlined,
            ),
          ),
          if (availableOnly)
            const Icon(Icons.filter_alt, color: _blue, size: 14),
        ],
      ),
    ),
  );
}

class _Info extends StatelessWidget {
  const _Info({required this.label, required this.value, required this.icon});
  final String label, value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, size: 10, color: _muted),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              color: _muted,
              fontSize: 6.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      const SizedBox(height: 3),
      Text(
        value,
        style: const TextStyle(
          color: _ink,
          fontSize: 8,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.selected = false, this.color});
  final String label;
  final bool selected;
  final Color? color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: selected ? _ink : _panel,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!selected)
          Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: color ?? _muted,
              shape: BoxShape.circle,
            ),
          ),
        Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : _muted,
            fontSize: 7.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({required this.vehicle});
  final _Vehicle vehicle;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: vehicle.status == 'DISPONIBLE' ? _greenSoft : _amberSoft,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            Icons.local_shipping_outlined,
            color: vehicle.status == 'DISPONIBLE' ? _green : _amber,
            size: 18,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    vehicle.plate,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  _StatusTag(
                    vehicle.status,
                    color: vehicle.status == 'DISPONIBLE' ? _green : _amber,
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                '${vehicle.brand} · ${vehicle.type}',
                style: const TextStyle(color: _muted, fontSize: 7.5),
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                    child: _VehicleMeta(
                      label: 'CAPACIDAD',
                      value: '${vehicle.capacity} L',
                    ),
                  ),
                  Expanded(
                    child: _VehicleMeta(label: 'PRÓXIMO', value: vehicle.next),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _VehicleMeta extends StatelessWidget {
  const _VehicleMeta({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: _subtle,
          fontSize: 6.5,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        value,
        style: const TextStyle(
          color: _ink,
          fontSize: 7.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _DispatchFilterSheet extends StatefulWidget {
  const _DispatchFilterSheet({
    required this.capacity,
    required this.availableOnly,
  });
  final int capacity;
  final bool availableOnly;
  @override
  State<_DispatchFilterSheet> createState() => _DispatchFilterSheetState();
}

class _DispatchFilterSheetState extends State<_DispatchFilterSheet> {
  late int capacity = widget.capacity;
  late bool availableOnly = widget.availableOnly;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      18,
      12,
      18,
      18 + MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 30,
            height: 3,
            decoration: BoxDecoration(
              color: _line,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Ajustar filtros',
          style: TextStyle(
            color: _ink,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'CAPACIDAD MÍNIMA',
          style: TextStyle(
            color: _muted,
            fontSize: 8,
            fontWeight: FontWeight.w800,
          ),
        ),
        DropdownButton<int>(
          value: capacity,
          isExpanded: true,
          items: const [8000, 12000, 18000, 20000]
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text('Al menos $value L'),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => capacity = value ?? capacity),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Sólo vehículos disponibles',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
          value: availableOnly,
          onChanged: (value) => setState(() => availableOnly = value),
        ),
        const SizedBox(height: 8),
        _OrangeButton(
          label: 'Aplicar filtros',
          onPressed: () =>
              Navigator.pop(context, _DispatchFilters(capacity, availableOnly)),
        ),
      ],
    ),
  );
}

class _DispatchFilters {
  const _DispatchFilters(this.capacity, this.availableOnly);
  final int capacity;
  final bool availableOnly;
}

class FleetPage extends StatefulWidget {
  const FleetPage({super.key});
  @override
  State<FleetPage> createState() => _FleetPageState();
}

class _FleetPageState extends State<FleetPage> {
  final _items = List<_Vehicle>.from(_vehicles);
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: _DispatchShell(
        title: 'Gestión de flota',
        subtitle: '${_items.length} vehículos registrados',
        onBack: () => context.go('/dispatches'),
        action: IconButton(
          tooltip: 'Añadir vehículo',
          onPressed: _add,
          icon: const Icon(Icons.add, color: Colors.white, size: 21),
          style: IconButton.styleFrom(
            backgroundColor: _orange,
            fixedSize: const Size(34, 34),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                _StatBox(
                  label: 'DISPONIBLES',
                  value: '03',
                  color: _green,
                  soft: _greenSoft,
                ),
                SizedBox(width: 5),
                _StatBox(
                  label: 'OCUPADOS',
                  value: '01',
                  color: _amber,
                  soft: _amberSoft,
                ),
                SizedBox(width: 5),
                _StatBox(
                  label: 'FUERA',
                  value: '02',
                  color: _red,
                  soft: _redSoft,
                ),
              ],
            ),
            const SizedBox(height: 10),
            for (final item in _items)
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: _FleetCard(
                  vehicle: item,
                  onEdit: () => _edit(item),
                  onDelete: () => _delete(item),
                ),
              ),
          ],
        ),
      ),
    ),
    bottomNavigationBar: const FullTankBottomNav(active: 2),
  );

  Future<void> _add() async {
    final changed = await context.push('/dispatches/fleet/new');
    if (changed == true && mounted)
      setState(
        () => _items.add(
          const _Vehicle(
            'TK-9908',
            'Freightliner M2 106',
            'Cisterna 20k',
            '20.000',
            'Sin agenda',
            'DISPONIBLE',
          ),
        ),
      );
  }

  Future<void> _edit(_Vehicle vehicle) async {
    final changed = await context.push(
      '/dispatches/fleet/new?edit=${vehicle.plate}',
    );
    if (changed == true && mounted) setState(() {});
  }

  Future<void> _delete(_Vehicle vehicle) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => _DeleteDialog(vehicle: vehicle),
    );
    if (ok == true && mounted) setState(() => _items.remove(vehicle));
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
    required this.soft,
  });
  final String label, value;
  final Color color, soft;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: soft,
        border: Border.all(color: color.withAlpha(45)),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 6.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    ),
  );
}

class _FleetCard extends StatelessWidget {
  const _FleetCard({
    required this.vehicle,
    required this.onEdit,
    required this.onDelete,
  });
  final _Vehicle vehicle;
  final VoidCallback onEdit, onDelete;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: _greenSoft,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.local_shipping_outlined,
            color: _green,
            size: 18,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    vehicle.plate,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  _StatusTag(
                    vehicle.status,
                    color: vehicle.status == 'DISPONIBLE' ? _green : _amber,
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                '${vehicle.brand}\n${vehicle.type}',
                style: const TextStyle(
                  color: _muted,
                  fontSize: 7.5,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _VehicleMeta(
                      label: 'CAPACIDAD',
                      value: '${vehicle.capacity} L',
                    ),
                  ),
                  Expanded(
                    child: _VehicleMeta(label: 'PRÓXIMO', value: vehicle.next),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          children: [
            IconButton(
              tooltip: 'Editar ${vehicle.plate}',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 15),
              style: IconButton.styleFrom(
                backgroundColor: _panel,
                fixedSize: const Size(28, 28),
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 5),
            IconButton(
              tooltip: 'Eliminar ${vehicle.plate}',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, color: _red, size: 15),
              style: IconButton.styleFrom(
                backgroundColor: _redSoft,
                fixedSize: const Size(28, 28),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

enum VehicleFormState { normal, duplicate }

class FleetFormPage extends StatefulWidget {
  const FleetFormPage({
    this.initialState = VehicleFormState.normal,
    this.editingPlate,
    super.key,
  });
  final VehicleFormState initialState;
  final String? editingPlate;
  @override
  State<FleetFormPage> createState() => _FleetFormPageState();
}

class _FleetFormPageState extends State<FleetFormPage> {
  late final _plate = TextEditingController(
    text: widget.initialState == VehicleFormState.duplicate
        ? 'TK-3812'
        : widget.editingPlate ?? 'TK-4421',
  );
  var _type = 'Cisterna 20k';
  @override
  void dispose() {
    _plate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duplicate =
        widget.initialState == VehicleFormState.duplicate ||
        (widget.editingPlate == null &&
            _plate.text.trim().toUpperCase() == 'TK-3812');
    return Scaffold(
      body: SafeArea(
        child: _DispatchShell(
          title: widget.editingPlate == null
              ? 'Nuevo vehículo'
              : 'Editar vehículo',
          subtitle: 'Añade a tu flota',
          onBack: () => context.pop(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FormLabel('PLACA', trailing: 'Formato: XX-####'),
                TextField(
                  controller: _plate,
                  onChanged: (_) => setState(() {}),
                  decoration: _fieldDecoration(
                    Icons.credit_card_outlined,
                    'TK-4421',
                    error: duplicate
                        ? 'Esta placa ya está registrada en tu flota'
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _TextField(
                        label: 'MARCA',
                        value: 'International',
                        icon: Icons.dns_outlined,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _TextField(
                        label: 'MODELO',
                        value: 'DuraStar',
                        icon: Icons.edit_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _TextField(
                  label: 'CAPACIDAD',
                  value: '15,000',
                  suffix: 'L',
                  icon: Icons.speed_outlined,
                ),
                const SizedBox(height: 10),
                const _FormLabel('TIPO DE VEHÍCULO'),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children:
                      [
                            'Cisterna 10k',
                            'Cisterna 15k',
                            'Cisterna 20k',
                            'Cisterna 25k',
                            'Cisterna 30k+',
                          ]
                          .map(
                            (item) => ChoiceChip(
                              label: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              selected: _type == item,
                              onSelected: (_) => setState(() => _type = item),
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 14),
                if (duplicate)
                  _DuplicateNotice(
                    title: 'Placa duplicada',
                    message:
                        'TK-3812 ya existe en tu flota como International DuraStar (15,000 L).',
                    action: 'Volver a flota',
                    onPressed: () => context.pop(),
                  ),
                if (!duplicate)
                  const _InfoNotice(
                    message:
                        'El vehículo estará disponible para asignación una vez validado por el equipo de operaciones.',
                  ),
                const SizedBox(height: 14),
                _OrangeButton(
                  label: widget.editingPlate == null
                      ? 'Guardar vehículo'
                      : 'Guardar cambios',
                  onPressed: duplicate ? null : () => context.pop(true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(
    IconData icon,
    String hint, {
    String? error,
  }) => InputDecoration(
    prefixIcon: Icon(icon, size: 15, color: error == null ? _subtle : _red),
    hintText: hint,
    errorText: error,
    filled: true,
    fillColor: _panel,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: error == null ? Colors.transparent : _red),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: _blue),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  );
}

class DriverPage extends StatefulWidget {
  const DriverPage({super.key});
  @override
  State<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  final _drivers = List<_Driver>.from(_driversData);
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: _DispatchShell(
        title: 'Conductores',
        subtitle: '${_drivers.length} conductores registrados',
        onBack: () => context.go('/dispatches'),
        action: IconButton(
          tooltip: 'Añadir conductor',
          onPressed: _add,
          icon: const Icon(Icons.add, color: Colors.white, size: 21),
          style: IconButton.styleFrom(
            backgroundColor: _orange,
            fixedSize: const Size(34, 34),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                _StatBox(
                  label: 'DISPONIBLES',
                  value: '03',
                  color: _green,
                  soft: _greenSoft,
                ),
                SizedBox(width: 5),
                _StatBox(
                  label: 'ASIGNADOS',
                  value: '01',
                  color: _amber,
                  soft: _amberSoft,
                ),
                SizedBox(width: 5),
                _StatBox(
                  label: 'INACTIVOS',
                  value: '01',
                  color: _subtle,
                  soft: _panel,
                ),
              ],
            ),
            const SizedBox(height: 10),
            for (final driver in _drivers)
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: _DriverCard(
                  driver: driver,
                  onEdit: () =>
                      context.push('/dispatches/drivers/new?edit=true'),
                  onDelete: () => _delete(driver),
                ),
              ),
          ],
        ),
      ),
    ),
    bottomNavigationBar: const FullTankBottomNav(active: 2),
  );

  Future<void> _add() async {
    final changed = await context.push('/dispatches/drivers/new');
    if (changed == true && mounted)
      setState(
        () => _drivers.add(
          const _Driver(
            'AN',
            'Ana Navarro',
            '60-123-456',
            'A-2 · 2028',
            'DISPONIBLE',
          ),
        ),
      );
  }

  Future<void> _delete(_Driver driver) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar conductor?'),
        content: Text('${driver.name} será removido de la flota.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: _red),
            child: const Text('Sí, eliminar'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) setState(() => _drivers.remove(driver));
  }
}

enum DriverFormState { normal, duplicate }

class DriverFormPage extends StatefulWidget {
  const DriverFormPage({
    this.initialState = DriverFormState.normal,
    this.editing = false,
    super.key,
  });
  final DriverFormState initialState;
  final bool editing;
  @override
  State<DriverFormPage> createState() => _DriverFormPageState();
}

class _DriverFormPageState extends State<DriverFormPage> {
  late final _dni = TextEditingController(
    text: widget.initialState == DriverFormState.duplicate
        ? '48-291-772'
        : widget.editing
        ? '52-104-889'
        : '',
  );
  var _category = 'A-2';
  @override
  void dispose() {
    _dni.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duplicate =
        widget.initialState == DriverFormState.duplicate ||
        _dni.text.trim() == '48-291-772';
    return Scaffold(
      body: SafeArea(
        child: _DispatchShell(
          title: widget.editing ? 'Editar conductor' : 'Nuevo conductor',
          subtitle: widget.editing ? 'Miguel Ortega' : 'Alta en flota',
          onBack: () => context.pop(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TextField(
                  label: 'NOMBRE COMPLETO',
                  value: widget.editing
                      ? 'Miguel Ortega Ruiz'
                      : 'Juan Ramírez López',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 10),
                _FormLabel('DNI / CURP', trailing: 'Sin espacios'),
                TextField(
                  controller: _dni,
                  onChanged: (_) => setState(() {}),
                  decoration: _input(
                    Icons.badge_outlined,
                    '48-291-772',
                    error: duplicate ? 'Este DNI ya está registrado' : null,
                  ),
                ),
                const SizedBox(height: 10),
                _TextField(
                  label: 'NÚMERO DE LICENCIA',
                  value: widget.editing ? 'A-2 · 2027' : 'A-2 · Vigencia',
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 10),
                const _FormLabel('CATEGORÍA DE LICENCIA'),
                Row(
                  children: [
                    for (final item in ['A-1', 'A-2', 'A-3', 'E'])
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: ChoiceChip(
                            label: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            selected: _category == item,
                            onSelected: (_) => setState(() => _category = item),
                          ),
                        ),
                      ),
                  ],
                ),
                if (duplicate) ...[
                  const SizedBox(height: 12),
                  _DuplicateNotice(
                    title: 'DNI duplicado',
                    message:
                        'El DNI 48-291-772 pertenece a Juan Ramírez López. Verifica el documento antes de guardar.',
                    action: 'Volver a conductores',
                    onPressed: () => context.pop(),
                  ),
                ],
                const SizedBox(height: 15),
                _OrangeButton(
                  label: widget.editing
                      ? 'Guardar cambios'
                      : 'Guardar conductor',
                  onPressed: duplicate ? null : () => context.pop(true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _input(
    IconData icon,
    String hint, {
    String? error,
  }) => InputDecoration(
    prefixIcon: Icon(icon, size: 15, color: error == null ? _subtle : _red),
    hintText: hint,
    errorText: error,
    filled: true,
    fillColor: _panel,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: error == null ? Colors.transparent : _red),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  );
}

class _DriverCard extends StatelessWidget {
  const _DriverCard({
    required this.driver,
    required this.onEdit,
    required this.onDelete,
  });
  final _Driver driver;
  final VoidCallback onEdit, onDelete;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: _panel,
            borderRadius: BorderRadius.circular(9),
          ),
          alignment: Alignment.center,
          child: Text(
            driver.initials,
            style: const TextStyle(
              color: _ink,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      driver.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _StatusTag(
                    driver.status,
                    color: driver.status == 'DISPONIBLE' ? _green : _amber,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'DNI · ${driver.dni} · Lic · ${driver.license}',
                style: const TextStyle(color: _muted, fontSize: 7.5),
              ),
              if (driver.assignment != null) ...[
                const SizedBox(height: 5),
                _StatusTag(driver.assignment!, color: _amber, soft: _amberSoft),
              ],
            ],
          ),
        ),
        Column(
          children: [
            IconButton(
              tooltip: 'Editar conductor',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 15),
              style: IconButton.styleFrom(
                backgroundColor: _panel,
                fixedSize: const Size(28, 28),
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 5),
            IconButton(
              tooltip: 'Eliminar conductor',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, color: _red, size: 15),
              style: IconButton.styleFrom(
                backgroundColor: _redSoft,
                fixedSize: const Size(28, 28),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class DispatchAssignmentPage extends StatefulWidget {
  const DispatchAssignmentPage({
    this.initialState = AssignmentState.order,
    super.key,
  });
  final AssignmentState initialState;
  @override
  State<DispatchAssignmentPage> createState() => _DispatchAssignmentPageState();
}

class _DispatchAssignmentPageState extends State<DispatchAssignmentPage> {
  late AssignmentState _state = widget.initialState;
  var _vehicle = 0;
  var _driver = 0;
  @override
  Widget build(BuildContext context) {
    final success = _state == AssignmentState.success;
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
              ? const _AssignmentSuccess()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_state != AssignmentState.conflict)
                      _AssignmentStepper(state: _state),
                    const SizedBox(height: 13),
                    if (_state == AssignmentState.conflict)
                      _AssignmentConflict(
                        onChange: () =>
                            setState(() => _state = AssignmentState.vehicle),
                      )
                    else
                      _assignmentBody(),
                    const SizedBox(height: 14),
                    if (_state != AssignmentState.conflict) _assignmentAction(),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: const FullTankBottomNav(active: 2),
    );
  }

  Widget _assignmentBody() => switch (_state) {
    AssignmentState.order => _ChoiceList(
      title: 'SELECCIONA UN PEDIDO APROBADO',
      helper: '3 pedidos listos para asignación',
      children: const [
        _OrderChoice(
          selected: true,
          title: '#ORD-4820 · Cliente B · 8,500 L',
          detail: 'Gasolina Magna · Entrega hoy 15:00',
        ),
        _OrderChoice(
          title: '#ORD-4819 · Cliente C · 15,000 L',
          detail: 'Diésel Premium · Entrega hoy 17:00',
        ),
        _OrderChoice(
          title: '#ORD-4816 · Cliente F · 20,000 L',
          detail: 'Diésel · Entrega mañana 09:00',
        ),
      ],
    ),
    AssignmentState.vehicle => _ChoiceList(
      title: 'VEHÍCULOS DISPONIBLES',
      helper: '3 compatibles · 8,500 L',
      children: [
        _SelectableChoice(
          selected: _vehicle == 0,
          title: 'TK-4421',
          detail: 'Freightliner M2 106 · Cisterna 20k',
          icon: Icons.local_shipping_outlined,
          onTap: () => setState(() => _vehicle = 0),
        ),
        _SelectableChoice(
          selected: _vehicle == 1,
          title: 'TK-2214',
          detail: 'Kenworth T370 · Cisterna 12k',
          icon: Icons.local_shipping_outlined,
          onTap: () => setState(() => _vehicle = 1),
        ),
        _SelectableChoice(
          selected: _vehicle == 2,
          title: 'TK-5501',
          detail: 'Peterbilt 337 · Cisterna 18k',
          icon: Icons.local_shipping_outlined,
          onTap: () => setState(() => _vehicle = 2),
        ),
      ],
    ),
    AssignmentState.driver => _ChoiceList(
      title: 'CONDUCTORES DISPONIBLES',
      helper: '3 habilitados',
      children: [
        _SelectableChoice(
          selected: _driver == 0,
          title: 'Juan Ramírez',
          detail: 'DNI · 48-291-772 · Lic · A-2 · 2028',
          icon: Icons.person_outline,
          onTap: () => setState(() => _driver = 0),
        ),
        _SelectableChoice(
          selected: _driver == 1,
          title: 'Carlos Mendoza',
          detail: 'DNI · 39-720-114 · Lic · A-3 · 2029',
          icon: Icons.person_outline,
          onTap: () => setState(() => _driver = 1),
        ),
        _SelectableChoice(
          selected: _driver == 2,
          title: 'Roberto Salinas',
          detail: 'DNI · 81-688-402 · Lic · A-2 · 2028',
          icon: Icons.person_outline,
          onTap: () => setState(() => _driver = 2),
        ),
      ],
    ),
    AssignmentState.confirm => _AssignmentSummary(
      vehicle: _vehicle,
      driver: _driver,
    ),
    AssignmentState.conflict ||
    AssignmentState.success => const SizedBox.shrink(),
  };

  Widget _assignmentAction() => _state == AssignmentState.confirm
      ? Column(
          children: [
            const _InfoNotice(
              message:
                  'Sin conflictos detectados. Todos los recursos están disponibles para el horario solicitado.',
            ),
            const SizedBox(height: 10),
            _OrangeButton(
              label: 'Asignar recursos',
              onPressed: () => setState(
                () => _state = _vehicle == 0 && _driver == 0
                    ? AssignmentState.conflict
                    : AssignmentState.success,
              ),
            ),
          ],
        )
      : _OrangeButton(
          label: 'Continuar  →',
          onPressed: () => setState(
            () => _state = switch (_state) {
              AssignmentState.order => AssignmentState.vehicle,
              AssignmentState.vehicle => AssignmentState.driver,
              _ => AssignmentState.confirm,
            },
          ),
        );
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
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    entry.value,
                    style: TextStyle(
                      color: active ? _blue : _subtle,
                      fontSize: 6,
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

class _ChoiceList extends StatelessWidget {
  const _ChoiceList({
    required this.title,
    required this.helper,
    required this.children,
  });
  final String title, helper;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: _muted,
          fontSize: 7,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 3),
      Text(helper, style: const TextStyle(color: _subtle, fontSize: 7)),
      const SizedBox(height: 7),
      ...children.map(
        (child) =>
            Padding(padding: const EdgeInsets.only(bottom: 7), child: child),
      ),
    ],
  );
}

class _OrderChoice extends StatelessWidget {
  const _OrderChoice({
    required this.title,
    required this.detail,
    this.selected = false,
  });
  final String title, detail;
  final bool selected;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: selected ? _blue : _line),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        const Icon(Icons.inventory_2_outlined, color: _blue, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                detail,
                style: const TextStyle(color: _muted, fontSize: 7.5),
              ),
            ],
          ),
        ),
        if (selected) const Icon(Icons.check_circle, color: _blue, size: 16),
      ],
    ),
  );
}

class _SelectableChoice extends StatelessWidget {
  const _SelectableChoice({
    required this.selected,
    required this.title,
    required this.detail,
    required this.icon,
    required this.onTap,
  });
  final bool selected;
  final String title, detail;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: selected ? _blue : _line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: selected ? _green : _muted, size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: const TextStyle(color: _muted, fontSize: 7.5),
                ),
              ],
            ),
          ),
          if (selected) const Icon(Icons.check_circle, color: _blue, size: 16),
        ],
      ),
    ),
  );
}

class _AssignmentSummary extends StatelessWidget {
  const _AssignmentSummary({required this.vehicle, required this.driver});
  final int vehicle, driver;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _ink,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'RESUMEN DE ASIGNACIÓN',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 7,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            _DarkRow(
              icon: Icons.inventory_2_outlined,
              label: 'PEDIDO',
              value: '#ORD-4820 · Cliente B · 8,500 L',
            ),
            const Divider(color: Colors.white24),
            _DarkRow(
              icon: Icons.local_shipping_outlined,
              label: 'VEHÍCULO',
              value:
                  '${_vehicles[vehicle].plate} · ${_vehicles[vehicle].brand} · 20k L',
            ),
            const Divider(color: Colors.white24),
            _DarkRow(
              icon: Icons.person_outline,
              label: 'CONDUCTOR',
              value: _driversData[driver].name,
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Salida estimada',
                  style: TextStyle(color: Colors.white70, fontSize: 7),
                ),
                Text(
                  'Hoy · 14:15',
                  style: TextStyle(
                    color: Colors.white,
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

class _DarkRow extends StatelessWidget {
  const _DarkRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label, value;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: Colors.white70, size: 14),
      const SizedBox(width: 6),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 6.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 7.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _AssignmentConflict extends StatelessWidget {
  const _AssignmentConflict({required this.onChange});
  final VoidCallback onChange;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: _redSoft,
          border: Border.all(color: const Color(0xFFFFCACA)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: _red, size: 20),
            SizedBox(width: 7),
            Expanded(
              child: Text(
                'Conflicto de recursos detectado\nNo puedes continuar con la asignación actual.',
                style: TextStyle(
                  color: _red,
                  fontSize: 8,
                  height: 1.35,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 9),
      _ConflictResource(
        title: 'Vehículo TK-4421',
        detail: 'Ya asignado a #ORD-4823 · Hoy 14:00–17:00',
        onChange: onChange,
      ),
      const SizedBox(height: 7),
      _ConflictResource(
        title: 'Conductor Juan Ramírez',
        detail: 'Turno finaliza 14:00 · No disponible después',
        onChange: onChange,
      ),
      const SizedBox(height: 14),
      _OrangeButton(label: 'Volver a seleccionar', onPressed: onChange),
    ],
  );
}

class _ConflictResource extends StatelessWidget {
  const _ConflictResource({
    required this.title,
    required this.detail,
    required this.onChange,
  });
  final String title, detail;
  final VoidCallback onChange;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: Colors.white,
      border: const Border(
        left: BorderSide(color: _red, width: 2),
        top: BorderSide(color: _line),
        right: BorderSide(color: _line),
        bottom: BorderSide(color: _line),
      ),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline, color: _red, size: 17),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                detail,
                style: const TextStyle(color: _muted, fontSize: 7.5),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onChange,
          child: const Text(
            'Cambiar',
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    ),
  );
}

class _AssignmentSuccess extends StatelessWidget {
  const _AssignmentSuccess();
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 28),
      Container(
        width: 73,
        height: 73,
        decoration: BoxDecoration(
          color: _greenSoft,
          shape: BoxShape.circle,
          border: Border.all(color: _green.withAlpha(70), width: 2),
        ),
        child: const Icon(Icons.check_circle_outline, color: _green, size: 42),
      ),
      const SizedBox(height: 14),
      const Text(
        'Despacho asignado',
        style: TextStyle(
          color: _ink,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 5),
      const Text(
        '#ORD-4820 está listo para salir. Se notificó al conductor y al cliente.',
        textAlign: TextAlign.center,
        style: TextStyle(color: _muted, fontSize: 9, height: 1.4),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _panel,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          children: [
            _KeyValue(label: 'Pedido', value: '#ORD-4820'),
            _KeyValue(label: 'Vehículo', value: 'TK-4421'),
            _KeyValue(label: 'Conductor', value: 'Juan Ramírez'),
            _KeyValue(label: 'Estado', value: 'DESPACHADO'),
          ],
        ),
      ),
      const SizedBox(height: 17),
      _OrangeButton(
        label: 'Ver seguimiento',
        onPressed: () => context.go('/orders/ORD-4820'),
      ),
      TextButton(
        onPressed: () => context.go('/dispatches/assign'),
        child: const Text(
          'Asignar otro recurso',
          style: TextStyle(
            color: _blue,
            fontSize: 8,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ],
  );
}

class _KeyValue extends StatelessWidget {
  const _KeyValue({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: _muted, fontSize: 8)),
        Text(
          value,
          style: const TextStyle(
            color: _ink,
            fontSize: 8,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _DispatchShell extends StatelessWidget {
  const _DispatchShell({
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.child,
    this.action,
  });
  final String title, subtitle;
  final VoidCallback onBack;
  final Widget child;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 11, 16, 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Volver',
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back, size: 19),
              style: IconButton.styleFrom(
                backgroundColor: _panel,
                fixedSize: const Size(34, 34),
                padding: EdgeInsets.zero,
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
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.3,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: const TextStyle(color: _muted, fontSize: 8.5),
                    ),
                ],
              ),
            ),
            if (action != null) action!,
          ],
        ),
        const SizedBox(height: 12),
        Expanded(child: SingleChildScrollView(child: child)),
      ],
    ),
  );
}

class _DispatchMenu extends StatelessWidget {
  const _DispatchMenu();
  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
    tooltip: 'Más opciones de despachos',
    onSelected: (value) => context.push(value),
    icon: const Icon(Icons.more_horiz, size: 19),
    itemBuilder: (context) => const [
      PopupMenuItem(
        value: '/dispatches/fleet',
        child: Text('Gestión de flota'),
      ),
      PopupMenuItem(value: '/dispatches/drivers', child: Text('Conductores')),
      PopupMenuItem(
        value: '/dispatches/assign',
        child: Text('Asignar recursos'),
      ),
    ],
  );
}

class _OrangeButton extends StatelessWidget {
  const _OrangeButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _orange,
        disabledBackgroundColor: _panel,
        foregroundColor: Colors.white,
        disabledForegroundColor: _subtle,
        minimumSize: const Size.fromHeight(36),
        shape: const StadiumBorder(),
        elevation: 2,
        textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
      ),
      child: Text(label),
    ),
  );
}

class _FormLabel extends StatelessWidget {
  const _FormLabel(this.text, {this.trailing});
  final String text;
  final String? trailing;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _muted,
              fontSize: 7,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (trailing != null)
          Text(trailing!, style: const TextStyle(color: _subtle, fontSize: 7)),
      ],
    ),
  );
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.label,
    required this.value,
    required this.icon,
    this.suffix,
  });
  final String label, value;
  final IconData icon;
  final String? suffix;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _FormLabel(label),
      TextField(
        readOnly: true,
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 15, color: _subtle),
          suffixText: suffix,
          filled: true,
          fillColor: _panel,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
        ),
      ),
    ],
  );
}

class _InfoNotice extends StatelessWidget {
  const _InfoNotice({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: _blueSoft,
      border: Border.all(color: const Color(0xFFCAD8FF)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        const Icon(Icons.info_outline, color: _blue, size: 16),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: _muted, fontSize: 8, height: 1.35),
          ),
        ),
      ],
    ),
  );
}

class _DuplicateNotice extends StatelessWidget {
  const _DuplicateNotice({
    required this.title,
    required this.message,
    required this.action,
    this.onPressed,
  });
  final String title, message, action;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: _amberSoft,
      border: Border.all(color: const Color(0xFFFDE4A7)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.warning_amber_rounded, color: _amber, size: 18),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                message,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 7.5,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: Text(
                  action,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 7.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _StatusTag extends StatelessWidget {
  const _StatusTag(this.label, {required this.color, this.soft});
  final String label;
  final Color color;
  final Color? soft;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
    decoration: BoxDecoration(
      color: soft ?? color.withAlpha(22),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 6.5,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();
  @override
  Widget build(BuildContext context) => Container(
    height: 24,
    decoration: BoxDecoration(
      color: _line,
      borderRadius: BorderRadius.circular(99),
    ),
  );
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();
  @override
  Widget build(BuildContext context) => Container(
    height: 88,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        const _Skeleton(),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [_Skeleton(), SizedBox(height: 7), _Skeleton()],
          ),
        ),
      ],
    ),
  );
}

class _EmptyDispatchState extends StatelessWidget {
  const _EmptyDispatchState({
    required this.icon,
    required this.title,
    required this.message,
  });
  final IconData icon;
  final String title, message;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 44),
      Container(
        width: 62,
        height: 62,
        decoration: const BoxDecoration(color: _panel, shape: BoxShape.circle),
        child: Icon(icon, color: _subtle, size: 30),
      ),
      const SizedBox(height: 15),
      Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: _ink,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: _muted, fontSize: 9, height: 1.45),
      ),
    ],
  );
}

class _DeleteDialog extends StatelessWidget {
  const _DeleteDialog({required this.vehicle});
  final _Vehicle vehicle;
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('¿Eliminar vehículo?'),
    content: Text(
      '${vehicle.plate} será removido de tu flota. Los pedidos históricos con esta placa se mantienen.',
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, true),
        style: FilledButton.styleFrom(backgroundColor: _red),
        child: const Text('Sí, eliminar'),
      ),
    ],
  );
}

class _Vehicle {
  const _Vehicle(
    this.plate,
    this.brand,
    this.type,
    this.capacity,
    this.next,
    this.status,
  );
  final String plate, brand, type, capacity, next, status;
  int get capacityLiters =>
      int.parse(capacity.replaceAll('.', '').replaceAll(',', ''));
}

const _vehicles = [
  _Vehicle(
    'TK-4421',
    'Freightliner M2 106',
    'Cisterna 20k',
    '20.000',
    'Sin agenda',
    'DISPONIBLE',
  ),
  _Vehicle(
    'TK-3812',
    'International DuraStar',
    'Cisterna 15k',
    '15.000',
    'Hoy 14:30 · ORD-4818',
    'EN DESPACHO',
  ),
  _Vehicle(
    'TK-2214',
    'Kenworth T370',
    'Cisterna 12k',
    '12.000',
    'Mañana 08:00',
    'DISPONIBLE',
  ),
  _Vehicle(
    'TK-5501',
    'Peterbilt 337',
    'Cisterna 18k',
    '18.000',
    'Sin agenda',
    'DISPONIBLE',
  ),
  _Vehicle(
    'TK-4102',
    'Volvo FMX',
    'Cisterna 20k',
    '20.000',
    'Mantenimiento',
    'MANTENIMIENTO',
  ),
  _Vehicle(
    'TK-3308',
    'Scania P410',
    'Cisterna 30k',
    '30.000',
    'Fuera de servicio',
    'FUERA',
  ),
];

class _Driver {
  const _Driver(
    this.initials,
    this.name,
    this.dni,
    this.license,
    this.status, [
    this.assignment,
  ]);
  final String initials, name, dni, license, status;
  final String? assignment;
}

const _driversData = [
  _Driver('JR', 'Juan Ramírez', '48-291-772', 'A-2 · 2028', 'DISPONIBLE'),
  _Driver(
    'MO',
    'Miguel Ortega',
    '52-104-889',
    'A-2 · 2027',
    'ASIGNADO',
    'ORD-4818 · Hoy 14:30',
  ),
  _Driver('CM', 'Carlos Mendoza', '39-720-114', 'A-3 · 2029', 'DISPONIBLE'),
  _Driver('RS', 'Roberto Salinas', '81-688-402', 'A-2 · 2028', 'DISPONIBLE'),
  _Driver('LÁ', 'Luis Ávila', '44-556-201', 'A-2 · 2026', 'INACTIVO'),
];
