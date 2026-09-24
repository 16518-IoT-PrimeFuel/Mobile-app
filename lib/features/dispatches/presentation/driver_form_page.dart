part of 'dispatch_pages.dart';

class DriverFormPage extends ConsumerStatefulWidget {
  const DriverFormPage({
    this.initialState = DriverFormState.normal,
    this.driver,
    super.key,
  });
  final DriverFormState initialState;
  final Driver? driver;
  @override
  ConsumerState<DriverFormPage> createState() => _DriverFormPageState();
}

class _DriverFormPageState extends ConsumerState<DriverFormPage> {
  late final _firstName = TextEditingController(text: widget.driver?.firstName);
  late final _lastName = TextEditingController(text: widget.driver?.lastName);
  late final _license = TextEditingController(
    text: widget.initialState == DriverFormState.duplicate
        ? '48-291-772'
        : widget.driver?.licenseNumber,
  );
  late final _phone = TextEditingController(text: widget.driver?.phoneNumber);
  late final _email = TextEditingController(text: widget.driver?.email);
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _license.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duplicate = widget.initialState == DriverFormState.duplicate;
    final editing = widget.driver != null;
    return Scaffold(
      body: SafeArea(
        child: _DispatchShell(
          title: editing ? 'Editar conductor' : 'Nuevo conductor',
          subtitle: 'Alta en flota',
          onBack: () => context.pop(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _driverInput('NOMBRE', _firstName, Icons.person_outline),
                const SizedBox(height: 10),
                _driverInput('APELLIDO', _lastName, Icons.person_outline),
                const SizedBox(height: 10),
                _driverInput(
                  'NÚMERO DE LICENCIA',
                  _license,
                  Icons.badge_outlined,
                ),
                const SizedBox(height: 10),
                _driverInput('TELÉFONO', _phone, Icons.phone_outlined),
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
                                fontSize: 11.6,
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
                if (_error != null) ...[
                  Text(
                    _error!,
                    style: const TextStyle(color: _red, fontSize: 9),
                  ),
                  const SizedBox(height: 8),
                ],
                _OrangeButton(
                  label: _saving
                      ? 'Guardando…'
                      : editing
                      ? 'Guardar cambios'
                      : 'Guardar conductor',
                  onPressed: duplicate || _saving ? null : _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _driverInput(
    String label,
    TextEditingController controller,
    IconData icon,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _FormLabel(label),
      TextField(controller: controller, decoration: _input(icon, label)),
    ],
  );

  Future<void> _save() async {
    final first = _firstName.text.trim();
    final last = _lastName.text.trim();
    final license = _license.text.trim();
    if (first.isEmpty || last.isEmpty || license.isEmpty) {
      setState(() => _error = 'Nombre, apellido y licencia son obligatorios.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final draft = Driver(
        id: widget.driver?.id ?? 0,
        firstName: first,
        lastName: last,
        licenseNumber: license,
        phoneNumber: _phone.text.trim(),
        email: _email.text.trim(),
        status: widget.driver?.status ?? 'AVAILABLE',
      );
      if (widget.driver == null) {
        await ref.read(dispatchRepositoryProvider).createDriver(draft);
      } else {
        await ref.read(dispatchRepositoryProvider).updateDriver(draft);
      }
      if (mounted) context.pop(true);
    } catch (error) {
      if (mounted)
        setState(() {
          _saving = false;
          _error = '$error';
        });
    }
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
  final Driver driver;
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
            driver.name
                .split(' ')
                .map((part) => part.isEmpty ? '' : part[0])
                .take(2)
                .join()
                .toUpperCase(),
            style: const TextStyle(
              color: _ink,
              fontSize: 13.05,
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
                        fontSize: 13.05,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _StatusTag(
                    _driverStatusLabel(driver.status),
                    color: driver.status.toUpperCase() == 'AVAILABLE'
                        ? _green
                        : _amber,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'DNI · ${driver.dni} · Lic · ${driver.license}',
                style: const TextStyle(color: _muted, fontSize: 10.875),
              ),
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
