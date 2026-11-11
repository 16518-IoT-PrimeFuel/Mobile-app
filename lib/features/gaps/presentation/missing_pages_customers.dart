part of 'missing_pages.dart';

String _plural(int n, String one, String many) => '$n ${n == 1 ? one : many}';

class CustomersPage extends ConsumerStatefulWidget {
  const CustomersPage({super.key});

  @override
  ConsumerState<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends ConsumerState<CustomersPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(providerCustomersProvider);
    final count = customers.valueOrNull?.length;
    return MissingPageShell(
      title: 'Clientes',
      subtitle: count == null
          ? null
          : _plural(count, 'cuenta vinculada', 'cuentas vinculadas'),
      actions: [
        IconButton(
          onPressed: () => context.push('/customers/new'),
          icon: const Icon(Icons.add),
          tooltip: 'Agregar cliente',
        ),
      ],
      bottomNav: 4,
      child: customers.when(
        loading: () => const Padding(
          padding: EdgeInsets.only(top: 60),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => _CustomersError(
          onRetry: () => ref.invalidate(providerCustomersProvider),
        ),
        data: (items) => _list(context, items),
      ),
    );
  }

  Widget _list(BuildContext context, List<ProviderCustomer> items) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(child: Text('Aún no tienes clientes vinculados.')),
      );
    }
    final query = _query.trim().toLowerCase();
    final visible = items
        .where(
          (c) =>
              query.isEmpty ||
              c.name.toLowerCase().contains(query) ||
              c.ruc.contains(query),
        )
        .toList();
    return Column(
      children: [
        TextField(
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(
            hintText: 'Buscar cliente',
            prefixIcon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        ),
        const SizedBox(height: 12),
        if (visible.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 24),
            child: Text('Sin resultados.'),
          ),
        for (final customer in visible)
          _CustomerTile(
            name: customer.name,
            detail:
                '${_plural(customer.tankCount, 'tanque', 'tanques')} · '
                '${_plural(customer.criticalTankCount, 'crítico', 'críticos')} · '
                '${_plural(customer.activeOrderCount, 'pedido activo', 'pedidos activos')}',
            initials: _initialsOf(customer.name),
            onTap: () => context.push('/customers/${customer.id}'),
          ),
      ],
    );
  }
}

String _initialsOf(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  final list = parts.toList();
  if (list.isEmpty) return '?';
  return (list.length > 1 ? '${list[0][0]}${list[1][0]}' : list[0][0])
      .toUpperCase();
}

class _CustomersError extends StatelessWidget {
  const _CustomersError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 40),
    child: Column(
      children: [
        const Text('No se pudieron cargar los clientes.'),
        const SizedBox(height: 12),
        FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
      ],
    ),
  );
}

class CustomerFormPage extends ConsumerStatefulWidget {
  const CustomerFormPage({super.key});

  @override
  ConsumerState<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends ConsumerState<CustomerFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _ruc = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _ruc.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(providerCustomersRepositoryProvider)
          .create(
            name: _name.text.trim(),
            ruc: _ruc.text.trim(),
            contactEmail: _email.text.trim(),
            phone: _phone.text.trim(),
          );
      ref.invalidate(providerCustomersProvider);
      if (!mounted) return;
      _message(context, 'Cliente guardado correctamente.');
      context.pop();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = error is ApiException && error.statusCode == 409
            ? 'Ya existe un cliente con ese RUC o nombre.'
            : 'No se pudo guardar el cliente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) => MissingPageShell(
    title: 'Agregar cliente',
    subtitle: 'Registra una empresa compradora',
    child: Form(
      key: _formKey,
      child: Column(
        children: [
          _Panel(
            child: Column(
              children: [
                _FormField(label: 'Empresa', controller: _name),
                _FormField(
                  label: 'RUC',
                  controller: _ruc,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      RegExp(r'^\d{11}$').hasMatch((value ?? '').trim())
                      ? null
                      : 'El RUC debe tener 11 dígitos.',
                ),
                _FormField(
                  label: 'Correo de operaciones (opcional)',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      (value ?? '').trim().isEmpty || value!.contains('@')
                      ? null
                      : 'Ingresa un correo válido',
                ),
                _FormField(
                  label: 'Teléfono (opcional)',
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  validator: (_) => null,
                ),
              ],
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(_error!, style: const TextStyle(color: _red)),
          ],
          const SizedBox(height: 14),
          _PrimaryButton(
            label: 'Guardar cliente',
            onPressed: _saving ? null : _save,
          ),
        ],
      ),
    ),
  );
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({
    required this.name,
    required this.detail,
    required this.initials,
    required this.onTap,
  });
  final String name;
  final String detail;
  final String initials;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(vertical: 5),
    leading: CircleAvatar(
      backgroundColor: _blueSoft,
      child: Text(
        initials,
        style: const TextStyle(color: _blue, fontWeight: FontWeight.w800),
      ),
    ),
    title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
    subtitle: Text(detail, style: const TextStyle(color: _muted)),
    trailing: const Icon(Icons.chevron_right),
  );
}

class CustomerDetailPage extends ConsumerWidget {
  const CustomerDetailPage({required this.customerId, super.key});
  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(providerCustomersProvider);
    return MissingPageShell(
      title: 'Detalle de cliente',
      child: customers.when(
        loading: () => const Padding(
          padding: EdgeInsets.only(top: 60),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => _CustomersError(
          onRetry: () => ref.invalidate(providerCustomersProvider),
        ),
        data: (items) {
          final matches = items.where((c) => '${c.id}' == customerId);
          if (matches.isEmpty) {
            return const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text('No encontramos este cliente.'),
            );
          }
          return _detail(matches.first);
        },
      ),
    );
  }

  Widget _detail(ProviderCustomer c) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              c.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text('RUC', style: TextStyle(color: _muted)),
            Text(c.ruc, style: const TextStyle(fontWeight: FontWeight.w700)),
            if (c.sector.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Sector', style: TextStyle(color: _muted)),
              Text(
                c.sector,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ],
        ),
      ),
      const SizedBox(height: 12),
      _Panel(
        child: Column(
          children: [
            _CountRow('Tanques', c.tankCount),
            _CountRow('Tanques críticos', c.criticalTankCount),
            _CountRow('Pedidos activos', c.activeOrderCount),
            _CountRow('Pedidos históricos', c.historicalOrderCount),
          ],
        ),
      ),
      const SizedBox(height: 12),
      const _SectionTitle('Sedes'),
      if (c.sites.isEmpty) const Text('Sin sedes registradas.'),
      for (final site in c.sites)
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.location_on_outlined),
          title: Text(site.name),
          subtitle: site.address.isEmpty ? null : Text(site.address),
        ),
      const SizedBox(height: 8),
      const Text(
        'Editar y archivar clientes: No disponible aún.',
        style: TextStyle(color: _muted),
      ),
    ],
  );
}

class _CountRow extends StatelessWidget {
  const _CountRow(this.label, this.value);
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: _muted)),
        ),
        Text('$value', style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    ),
  );
}
