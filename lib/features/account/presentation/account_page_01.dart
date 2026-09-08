part of 'account_page.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({required this.variant, super.key});

  final AccountVariant variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showBottomBar =
        variant == AccountVariant.overview || variant == AccountVariant.help;
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(_uiTextScale)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
            child: switch (variant) {
              AccountVariant.overview => const _AccountOverview(),
              AccountVariant.profile => const _EditProfile(),
              AccountVariant.security => const _SecuritySettings(),
              AccountVariant.notifications => const _NotificationSettings(),
              AccountVariant.help => _HelpSettings(
                onSignOut: () async {
                  await ref.read(authControllerProvider.notifier).signOut();
                  if (context.mounted) context.go('/login');
                },
              ),
            },
          ),
        ),
        bottomNavigationBar: showBottomBar
            ? const FullTankBottomNav(active: 4)
            : null,
      ),
    );
  }
}

class _AccountOverview extends StatelessWidget {
  const _AccountOverview();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _ProfileSummary(),
      const SizedBox(height: 18),
      const _AccountSectionLabel('DATOS DE CONTACTO'),
      const SizedBox(height: 8),
      const _ContactCard(),
      const SizedBox(height: 16),
      const _AccountStatusCard(),
      const SizedBox(height: 18),
      const _AccountSectionLabel('ACCESOS RÁPIDOS'),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: _QuickAccess(
              icon: Icons.edit_outlined,
              label: 'Editar\nperfil',
              color: FullTankColors.blue,
              softColor: FullTankColors.blueSoft,
              onTap: () => context.push('/account/profile'),
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: _QuickAccess(
              icon: Icons.shield_outlined,
              label: 'Seguridad',
              color: _teal,
              softColor: _tealSoft,
              onTap: () => context.push('/account/security'),
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: _QuickAccess(
              icon: Icons.tune_outlined,
              label: 'Preferencias',
              color: const Color(0xFFC56B2C),
              softColor: const Color(0xFFFFF4E9),
              onTap: () => context.push('/account/notifications'),
            ),
          ),
        ],
      ),
    ],
  );
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 47,
        height: 47,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: FullTankColors.navy,
          borderRadius: BorderRadius.circular(13),
        ),
        child: const Text(
          'PE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      const SizedBox(width: 13),
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PetroAndes',
              style: TextStyle(
                color: FullTankColors.navy,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Solicitante · Operaciones de flota',
              style: TextStyle(
                color: FullTankColors.inkMid,
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      const _StatusPill(
        label: 'VERIFICADA',
        color: _teal,
        softColor: _tealSoft,
      ),
    ],
  );
}

class _ContactCard extends StatelessWidget {
  const _ContactCard();

  @override
  Widget build(BuildContext context) => const _AccountPanel(
    child: Column(
      children: [
        _ContactRow(
          icon: Icons.business_outlined,
          label: 'EMPRESA',
          value: 'PetroAndes S.A. de C.V.',
        ),
        _ContactRow(
          icon: Icons.mail_outline,
          label: 'CORREO',
          value: 'samuel.espinoza@petroandes.mx',
        ),
        _ContactRow(
          icon: Icons.phone_outlined,
          label: 'TELÉFONO',
          value: '+52 81 8340 2205',
        ),
        _ContactRow(
          icon: Icons.location_on_outlined,
          label: 'UBICACIÓN',
          value: 'Monterrey · Nuevo León',
          last: true,
        ),
      ],
    ),
  );
}

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
            border: Border(bottom: BorderSide(color: FullTankColors.line)),
          ),
    child: Row(
      children: [
        _AccountIconTile(icon: icon, color: FullTankColors.inkMid),
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
            backgroundColor: FullTankColors.blue,
            minimumSize: const Size.fromHeight(52),
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
