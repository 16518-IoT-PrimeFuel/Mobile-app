part of 'dispatch_pages.dart';

class _VehicleFormResult {
  const _VehicleFormResult({
    required this.plate,
    required this.brand,
    required this.model,
    required this.type,
    required this.capacity,
  });
  final String plate, brand, model, type;
  final double capacity;
}

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
                                  fontSize: 11.6,
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
                  onPressed: duplicate
                      ? null
                      : () => context.pop(
                          _VehicleFormResult(
                            plate: _plate.text.trim(),
                            brand: 'International',
                            model: 'DuraStar',
                            type: _type,
                            capacity: 15000,
                          ),
                        ),
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

class DriverPage extends ConsumerStatefulWidget {
  const DriverPage({super.key});
  @override
  ConsumerState<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends ConsumerState<DriverPage> {
  final _fallbackDrivers = List<_Driver>.from(_driversData);
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dispatchDriversProvider);
    final drivers = state.value?.isNotEmpty == true
        ? state.value!.map(_toViewDriver).toList()
        : _fallbackDrivers;
    return Scaffold(
      body: SafeArea(
        child: _DispatchShell(
          title: 'Conductores',
          subtitle: '${drivers.length} conductores registrados',
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
              for (final driver in drivers)
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: _DriverCard(
                    driver: driver,
                    onEdit: () => _edit(driver),
                    onDelete: () => _delete(driver),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FullTankBottomNav(active: 2),
    );
  }

  Future<void> _add() async {
    final result = await context.push<_DriverFormResult>(
      '/dispatches/drivers/new',
    );
    if (result == null || !mounted) return;
    await ref
        .read(dispatchRepositoryProvider)
        .createDriver(
          Driver(
            id: 0,
            firstName: result.firstName,
            lastName: result.lastName,
            licenseNumber: result.licenseNumber,
          ),
        );
    setState(
      () => _fallbackDrivers.add(
        _Driver(
          result.initials,
          result.name,
          result.dni,
          result.license,
          'DISPONIBLE',
        ),
      ),
    );
  }

  Future<void> _edit(_Driver driver) async {
    final result = await context.push<_DriverFormResult>(
      '/dispatches/drivers/new?edit=true',
    );
    if (result == null || !mounted) return;
    await ref
        .read(dispatchRepositoryProvider)
        .updateDriver(
          Driver(
            id: driver.id,
            firstName: result.firstName,
            lastName: result.lastName,
            licenseNumber: result.licenseNumber,
          ),
        );
    setState(() {
      final index = _fallbackDrivers.indexOf(driver);
      if (index >= 0) {
        _fallbackDrivers[index] = _Driver(
          result.initials,
          result.name,
          result.dni,
          result.license,
          driver.status,
          driver.assignment,
          driver.id,
          result.firstName,
          result.lastName,
          result.licenseNumber,
        );
      }
    });
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
            style: FilledButton.styleFrom(
              backgroundColor: _red,
              minimumSize: const Size.fromHeight(52),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: const StadiumBorder(),
            ),
            child: const Text('Sí, eliminar'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    if (driver.id > 0) {
      await ref.read(dispatchRepositoryProvider).deleteDriver(driver.id);
    }
    setState(() => _fallbackDrivers.remove(driver));
  }

  _Driver _toViewDriver(Driver driver) {
    final parts = driver.name.split(' ').where((part) => part.isNotEmpty);
    final initials = parts.take(2).map((part) => part[0].toUpperCase()).join();
    return _Driver(
      initials,
      driver.name,
      driver.licenseNumber,
      driver.licenseNumber,
      driver.status == 'AVAILABLE' ? 'DISPONIBLE' : driver.status,
      null,
      driver.id,
      driver.firstName,
      driver.lastName,
      driver.licenseNumber,
    );
  }
}

class _DriverFormResult {
  const _DriverFormResult({
    required this.firstName,
    required this.lastName,
    required this.licenseNumber,
    required this.initials,
    required this.name,
    required this.dni,
    required this.license,
  });
  final String firstName, lastName, licenseNumber, initials, name, dni, license;
}

enum DriverFormState { normal, duplicate }
