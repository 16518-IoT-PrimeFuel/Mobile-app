part of 'dispatch_pages.dart';

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
