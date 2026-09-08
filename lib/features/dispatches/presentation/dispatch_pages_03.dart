part of 'dispatch_pages.dart';

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
