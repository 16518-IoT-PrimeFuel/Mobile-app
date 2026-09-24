part of 'dispatch_pages.dart';

class FleetFormPage extends ConsumerStatefulWidget {
  const FleetFormPage({
    this.initialState = VehicleFormState.normal,
    this.editingPlate,
    super.key,
  });
  final VehicleFormState initialState;
  final String? editingPlate;
  @override
  ConsumerState<FleetFormPage> createState() => _FleetFormPageState();
}

class _FleetFormPageState extends ConsumerState<FleetFormPage> {
  late final _plate = TextEditingController(
    text: widget.initialState == VehicleFormState.duplicate
        ? 'TK-3812'
        : widget.editingPlate ?? '',
  );
  final _brand = TextEditingController();
  final _model = TextEditingController();
  final _capacity = TextEditingController();
  var _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.editingPlate != null) _loadExisting();
  }

  Future<void> _loadExisting() async {
    try {
      final vehicles = await ref.read(dispatchRepositoryProvider).vehicles();
      final vehicle = vehicles
          .where((item) => item.plate == widget.editingPlate)
          .firstOrNull;
      if (!mounted || vehicle == null) return;
      _brand.text = vehicle.brand;
      _model.text = vehicle.model;
      _capacity.text = vehicle.capacity.toStringAsFixed(0);
      setState(() {});
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo cargar el vehículo: $error')),
        );
      }
    }
  }

  @override
  void dispose() {
    _plate.dispose();
    _brand.dispose();
    _model.dispose();
    _capacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final existing = ref
        .read(dispatchControllerProvider)
        .valueOrNull
        ?.where((vehicle) => vehicle.plate == widget.editingPlate)
        .firstOrNull;
    final duplicate =
        widget.initialState == VehicleFormState.duplicate ||
        (ref
                .read(dispatchControllerProvider)
                .valueOrNull
                ?.any(
                  (vehicle) =>
                      vehicle.plate.toUpperCase() ==
                          _plate.text.trim().toUpperCase() &&
                      vehicle.id != existing?.id,
                ) ??
            false);
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
                      child: _editableField(
                        'MARCA',
                        _brand,
                        Icons.dns_outlined,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _editableField(
                        'MODELO',
                        _model,
                        Icons.edit_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _editableField(
                  'CAPACIDAD',
                  _capacity,
                  Icons.speed_outlined,
                  suffix: 'L',
                ),
                const SizedBox(height: 10),
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
                  onPressed: duplicate || _saving ? null : _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _editableField(
    String label,
    TextEditingController controller,
    IconData icon, {
    String? suffix,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _FormLabel(label),
      TextField(
        controller: controller,
        keyboardType: label == 'CAPACIDAD' ? TextInputType.number : null,
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

  Future<void> _save() async {
    final capacity = double.tryParse(
      _capacity.text.replaceAll(',', '').replaceAll('.', ''),
    );
    final brand = _brand.text.trim();
    final model = _model.text.trim();
    final plate = _plate.text.trim().toUpperCase();
    if (plate.isEmpty ||
        brand.isEmpty ||
        model.isEmpty ||
        capacity == null ||
        capacity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa placa, marca, modelo y capacidad válida.'),
        ),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final repository = ref.read(dispatchRepositoryProvider);
      final existing = (await repository.vehicles())
          .where((vehicle) => vehicle.plate == widget.editingPlate)
          .firstOrNull;
      if (existing == null && widget.editingPlate != null) {
        throw StateError('No se encontró el vehículo que quieres editar');
      } else if (existing == null) {
        await repository.createVehicle(
          plate: plate,
          brand: brand,
          model: model,
          capacity: capacity,
        );
      } else {
        await repository.updateVehicle(
          existing.id,
          plate: plate,
          brand: brand,
          model: model,
          capacity: capacity,
        );
      }
      if (mounted) context.pop(true);
    } catch (error) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo guardar el vehículo: $error')),
        );
      }
    }
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
  List<Driver> _drivers = const [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final drivers = await ref.read(dispatchRepositoryProvider).drivers();
      if (mounted)
        setState(() {
          _drivers = drivers;
          _error = null;
        });
    } catch (error) {
      if (mounted) setState(() => _error = '$error');
    }
  }

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
            if (_error != null) _InfoNotice(message: _error!),
            Row(
              children: [
                _StatBox(
                  label: 'DISPONIBLES',
                  value:
                      '${_drivers.where((d) => d.status.toUpperCase() == 'AVAILABLE').length}',
                  color: _green,
                  soft: _greenSoft,
                ),
                const SizedBox(width: 5),
                _StatBox(
                  label: 'ASIGNADOS',
                  value:
                      '${_drivers.where((d) => d.status.toUpperCase() == 'ASSIGNED').length}',
                  color: _amber,
                  soft: _amberSoft,
                ),
                const SizedBox(width: 5),
                _StatBox(
                  label: 'INACTIVOS',
                  value:
                      '${_drivers.where((d) => d.status.toUpperCase() != 'AVAILABLE' && d.status.toUpperCase() != 'ASSIGNED').length}',
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
                      context.push('/dispatches/drivers/new', extra: driver),
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
    if (changed == true && mounted) await _load();
  }

  Future<void> _delete(Driver driver) async {
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
    if (ok == true && mounted) {
      await ref.read(dispatchRepositoryProvider).deleteDriver(driver.id);
      await _load();
    }
  }
}

enum DriverFormState { normal, duplicate }
