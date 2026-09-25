part of 'missing_pages.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});
  @override
  Widget build(BuildContext context) => MissingPageShell(
    title: 'Clientes',
    subtitle: '24 cuentas activas',
    actions: [
      IconButton(
        onPressed: () => context.push('/customers/new'),
        icon: const Icon(Icons.add),
        tooltip: 'Agregar cliente',
      ),
    ],
    bottomNav: 4,
    child: Column(
      children: [
        TextField(
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
        _CustomerTile(
          name: 'AgroNorte S.A.',
          detail: 'Monterrey · 8 pedidos este mes',
          initials: 'AN',
          onTap: () => context.push('/customers/agronorte'),
        ),
        _CustomerTile(
          name: 'Transportes Delta',
          detail: 'CDMX · 5 pedidos este mes',
          initials: 'TD',
          onTap: () => context.push('/customers/delta'),
        ),
        _CustomerTile(
          name: 'Cementos B',
          detail: 'Puebla · 3 pedidos este mes',
          initials: 'CB',
          onTap: () => context.push('/customers/cementos'),
        ),
      ],
    ),
  );
}

class CustomerFormPage extends StatefulWidget {
  const CustomerFormPage({this.customerId, super.key});
  final String? customerId;

  @override
  State<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(
    text: widget.customerId == null ? '' : 'AgroNorte S.A.',
  );
  late final _email = TextEditingController(
    text: widget.customerId == null ? '' : 'operaciones@cliente.com',
  );
  late final _phone = TextEditingController(
    text: widget.customerId == null ? '' : '+51 999 888 777',
  );

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MissingPageShell(
    title: widget.customerId == null ? 'Agregar cliente' : 'Editar cliente',
    subtitle: 'Información de contacto y operación',
    child: Form(
      key: _formKey,
      child: Column(
        children: [
          _Panel(
            child: Column(
              children: [
                _FormField(label: 'Empresa', controller: _name),
                _FormField(
                  label: 'Correo de operaciones',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value != null && value.contains('@')
                      ? null
                      : 'Ingresa un correo válido',
                ),
                _FormField(
                  label: 'Teléfono',
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _PrimaryButton(
            label: widget.customerId == null
                ? 'Guardar cliente'
                : 'Guardar cambios',
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _message(context, 'Cliente guardado correctamente.');
              }
            },
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

class CustomerDetailPage extends StatelessWidget {
  const CustomerDetailPage({required this.customerId, super.key});
  final String customerId;
  @override
  Widget build(BuildContext context) => MissingPageShell(
    title: 'Detalle de cliente',
    subtitle: customerId == 'delta'
        ? 'Transportes Delta'
        : customerId == 'cementos'
        ? 'Cementos B'
        : 'AgroNorte S.A.',
    actions: [
      IconButton(
        onPressed: () => context.push('/customers/$customerId/edit'),
        icon: const Icon(Icons.edit_outlined),
        tooltip: 'Editar',
      ),
    ],
    child: Column(
      children: [
        const _Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contacto principal', style: TextStyle(color: _muted)),
              SizedBox(height: 5),
              Text(
                'operaciones@cliente.com',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 12),
              Text('Pedidos últimos 30 días', style: TextStyle(color: _muted)),
              SizedBox(height: 5),
              Text(
                '8 pedidos · 32,000 L',
                style: TextStyle(fontSize: 26.1, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _PrimaryButton(
          label: 'Crear pedido para este cliente',
          onPressed: () => context.push('/orders/new'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => _message(context, 'Cliente archivado.'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shape: const StadiumBorder(),
            foregroundColor: _red,
          ),
          child: const Text('Archivar cliente'),
        ),
      ],
    ),
  );
}
