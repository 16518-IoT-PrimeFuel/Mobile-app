part of 'account_page.dart';

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    this.last = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: last
        ? null
        : const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
    child: Row(
      children: [
        _AccountIconTile(icon: icon, color: Color(0xFF4A5568)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: _microLabel),
              Text(value, style: _contactValue),
            ],
          ),
        ),
      ],
    ),
  );
}

class _AccountStatusCard extends StatelessWidget {
  const _AccountStatusCard();

  @override
  Widget build(BuildContext context) => const _AccountPanel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('ESTADO DE CUENTA', style: _microLabel),
            _StatusPill(
              label: 'AL CORRIENTE',
              color: Color(0xFF10B981),
              softColor: Color(0xFFECFDF5),
            ),
          ],
        ),
        SizedBox(height: 11),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _StatusMetric(label: 'PLAN', value: 'Business'),
            _StatusMetric(label: 'MIEMBRO DESDE', value: 'Mar 2024'),
            _StatusMetric(label: 'SESIONES', value: '2 activas'),
          ],
        ),
      ],
    ),
  );
}

class _StatusMetric extends StatelessWidget {
  const _StatusMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: _microLabel),
      Text(value, style: _contactValue),
    ],
  );
}

class _EditProfile extends StatefulWidget {
  const _EditProfile();

  @override
  State<_EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<_EditProfile> {
  final _name = TextEditingController(text: 'Samuel Espinoza');
  final _company = TextEditingController(text: 'PetroAndes S.A. de C.V.');
  final _email = TextEditingController(text: 'samuel.espinoza@petroandes.mx');
  final _phone = TextEditingController(text: '+52 81 8340 2205');
  final _role = TextEditingController(text: 'Coordinador de flota');

  @override
  void dispose() {
    _name.dispose();
    _company.dispose();
    _email.dispose();
    _phone.dispose();
    _role.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _AccountHeader(
        title: 'Editar perfil',
        subtitle: 'Actualiza tu información de contacto',
      ),
      const SizedBox(height: 16),
      _PhotoCard(
        onChange: () => _showMessage(context, 'Selector de foto próximamente.'),
      ),
      const SizedBox(height: 14),
      _ProfileField(
        label: 'NOMBRE COMPLETO',
        icon: Icons.person_outline,
        controller: _name,
      ),
      _ProfileField(
        label: 'EMPRESA',
        icon: Icons.business_outlined,
        controller: _company,
      ),
      _ProfileField(
        label: 'CORREO CORPORATIVO',
        icon: Icons.mail_outline,
        controller: _email,
        keyboardType: TextInputType.emailAddress,
      ),
      _ProfileField(
        label: 'TELÉFONO',
        icon: Icons.phone_outlined,
        controller: _phone,
        keyboardType: TextInputType.phone,
      ),
      _ProfileField(
        label: 'CARGO',
        icon: Icons.badge_outlined,
        controller: _role,
      ),
      const SizedBox(height: 6),
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: () => _showMessage(context, 'Cambios guardados.'),
          style: FilledButton.styleFrom(
            backgroundColor: Color(0xFF1E40AF),
            minimumSize: const Size.fromHeight(52),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shape: const StadiumBorder(),
          ),
          child: const Text('Guardar cambios'),
        ),
      ),
      Center(
        child: TextButton(
          onPressed: () => context.pop(),
          child: const Text('Descartar cambios'),
        ),
      ),
    ],
  );
}

class _PhotoCard extends StatelessWidget {
  const _PhotoCard({required this.onChange});

  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) => _AccountPanel(
    child: Row(
      children: [
        const _Avatar(initials: 'PE', size: 40),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Foto de perfil', style: _bodyStrong),
              Text('PNG · JPG · máx. 2 MB', style: _smallText),
            ],
          ),
        ),
        TextButton(
          onPressed: onChange,
          style: TextButton.styleFrom(
            backgroundColor: Color(0xFFEFF4FF),
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          ),
          child: const Text('Cambiar'),
        ),
      ],
    ),
  );
}
