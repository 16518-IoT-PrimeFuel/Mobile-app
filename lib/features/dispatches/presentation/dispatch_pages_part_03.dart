part of 'dispatch_pages.dart';

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
