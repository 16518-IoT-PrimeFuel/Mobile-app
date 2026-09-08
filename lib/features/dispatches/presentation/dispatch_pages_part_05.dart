part of 'dispatch_pages.dart';

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

