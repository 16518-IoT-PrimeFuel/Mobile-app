part of 'dispatch_pages.dart';

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

