part of 'account_page.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({required this.variant, super.key});

  final AccountVariant variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showBottomBar =
        variant == AccountVariant.overview || variant == AccountVariant.help;
    return Scaffold(
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
              color: Color(0xFF1E40AF),
              softColor: Color(0xFFEFF4FF),
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
          color: Color(0xFF1A202C),
          borderRadius: BorderRadius.circular(13),
        ),
        child: const Text(
          'PE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.3,
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
                color: Color(0xFF1A202C),
                fontSize: 21.75,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Solicitante · Operaciones de flota',
              style: TextStyle(
                color: Color(0xFF4A5568),
                fontSize: 13.05,
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
