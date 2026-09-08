part of 'dispatch_pages.dart';

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
