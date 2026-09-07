import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/fulltank_theme.dart';
import '../../auth/application/auth_providers.dart';
import '../../home/presentation/home_page.dart';

enum AccountVariant { overview, profile, security, notifications, help }

const _uiTextScale = 1.45;
const _teal = Color(0xFF0F9B91);
const _tealSoft = Color(0xFFEAFBF8);

class AccountPage extends ConsumerWidget {
  const AccountPage({required this.variant, super.key});

  final AccountVariant variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showBottomBar =
        variant == AccountVariant.overview || variant == AccountVariant.help;
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: const TextScaler.linear(_uiTextScale)),
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
            backgroundColor: FullTankColors.blueSoft,
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          ),
          child: const Text('Cambiar'),
        ),
      ],
    ),
  );
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.icon,
    required this.controller,
    this.keyboardType,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 11),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _microLabel),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: _fieldText,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 15, color: FullTankColors.inkSoft),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 14,
            ),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: FullTankColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: FullTankColors.line),
            ),
          ),
        ),
      ],
    ),
  );
}

class _SecuritySettings extends StatefulWidget {
  const _SecuritySettings();

  @override
  State<_SecuritySettings> createState() => _SecuritySettingsState();
}

class _SecuritySettingsState extends State<_SecuritySettings> {
  bool twoFactor = true;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _AccountHeader(
        title: 'Seguridad',
        subtitle: 'Protege tu cuenta y sesiones',
      ),
      const SizedBox(height: 16),
      const _ProtectedCard(),
      const SizedBox(height: 16),
      const _AccountSectionLabel('AUTENTICACIÓN'),
      const SizedBox(height: 8),
      _SettingsPanel(
        children: [
          _SettingsRow(
            icon: Icons.key_outlined,
            color: FullTankColors.blue,
            title: 'Cambiar contraseña',
            detail: 'Última actualización hace 3 meses',
            onTap: () =>
                _showMessage(context, 'Flujo de cambio de contraseña.'),
          ),
          _SettingsRow(
            icon: Icons.phonelink_lock_outlined,
            color: _teal,
            title: 'Autenticación\nen dos pasos',
            detail: 'SMS al +52 81\n8340 2205',
            trailing: Switch(
              value: twoFactor,
              onChanged: (value) => setState(() => twoFactor = value),
              activeThumbColor: _teal,
            ),
            badge: twoFactor ? 'ACTIVO' : null,
          ),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _AccountSectionLabel('SESIONES ACTIVAS'),
          TextButton(
            onPressed: () => _showMessage(context, 'Sesiones cerradas.'),
            child: const Text(
              'Cerrar todas',
              style: TextStyle(color: FullTankColors.danger),
            ),
          ),
        ],
      ),
      _SettingsPanel(
        children: [
          _DeviceRow(
            icon: Icons.phone_iphone_outlined,
            title: 'iPhone 14 Pro ·\nMonterrey',
            detail: 'Sesión actual · Safari · hace 2 min',
            current: true,
          ),
          _DeviceRow(
            icon: Icons.laptop_mac_outlined,
            title: 'MacBook Pro · CDMX',
            detail: 'Chrome · hace 3 horas',
            onClose: () => _showMessage(context, 'Sesión cerrada.'),
          ),
        ],
      ),
      const SizedBox(height: 16),
      const _AccountSectionLabel('DISPOSITIVOS CONECTADOS'),
    ],
  );
}

class _ProtectedCard extends StatelessWidget {
  const _ProtectedCard();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: _tealSoft,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        const _AccountIconTile(icon: Icons.shield_outlined, color: _teal),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cuenta protegida', style: _bodyStrong),
              Text('Nivel de seguridad · Alto', style: _smallText),
            ],
          ),
        ),
        const Text('92/100', style: _scoreText),
      ],
    ),
  );
}

class _NotificationSettings extends StatefulWidget {
  const _NotificationSettings();

  @override
  State<_NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<_NotificationSettings> {
  final enabled = [true, true, true, false];
  int language = 0;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _AccountHeader(
        title: 'Notificaciones',
        subtitle: 'Alertas, avisos y preferencias',
      ),
      const SizedBox(height: 16),
      const _AccountSectionLabel('ALERTAS OPERACIONALES'),
      const SizedBox(height: 8),
      _SettingsPanel(
        children: [
          _NotificationRow(
            icon: Icons.local_gas_station_outlined,
            color: const Color(0xFFEF4444),
            title: 'Alertas de combustible',
            detail: 'Umbrales críticos y advertencias\nde nivel',
            value: enabled[0],
            onChanged: (value) => setState(() => enabled[0] = value),
          ),
          _NotificationRow(
            icon: Icons.receipt_long_outlined,
            color: FullTankColors.blue,
            title: 'Actualizaciones de\npedidos',
            detail: 'Aprobado · despachado ·\nentregado',
            value: enabled[1],
            onChanged: (value) => setState(() => enabled[1] = value),
          ),
          _NotificationRow(
            icon: Icons.description_outlined,
            color: _teal,
            title: 'Reportes periódicos',
            detail: 'Resumen semanal cada lunes\n08:00',
            value: enabled[2],
            onChanged: (value) => setState(() => enabled[2] = value),
          ),
        ],
      ),
      const SizedBox(height: 16),
      const _AccountSectionLabel('COMUNICACIONES'),
      const SizedBox(height: 8),
      _SettingsPanel(
        children: [
          _NotificationRow(
            icon: Icons.notifications_none_outlined,
            color: FullTankColors.inkSoft,
            title: 'Novedades del producto',
            detail: 'Nuevas funciones y mejoras',
            value: enabled[3],
            onChanged: (value) => setState(() => enabled[3] = value),
          ),
        ],
      ),
      const SizedBox(height: 16),
      const _AccountSectionLabel('PREFERENCIAS'),
      const SizedBox(height: 8),
      _LanguageSelector(
        selected: language,
        onChanged: (value) => setState(() => language = value),
      ),
    ],
  );
}

class _HelpSettings extends StatelessWidget {
  const _HelpSettings({required this.onSignOut});

  final Future<void> Function() onSignOut;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _AccountHeader(
        title: 'Ayuda y sesión',
        subtitle: 'Soporte, documentos legales y salida',
      ),
      const SizedBox(height: 18),
      const _AccountSectionLabel('AYUDA'),
      const SizedBox(height: 8),
      _SettingsPanel(
        children: [
          _HelpRow(
            icon: Icons.help_outline,
            color: FullTankColors.blue,
            title: 'Centro de ayuda',
            detail: 'Guías, FAQs y tutoriales',
            onTap: () => _showMessage(context, 'Centro de ayuda próximamente.'),
          ),
          _HelpRow(
            icon: Icons.headset_mic_outlined,
            color: _teal,
            title: 'Contactar soporte',
            detail: 'Respuesta promedio · 4 min',
            badge: '24/7',
            onTap: () => _showMessage(context, 'Soporte disponible 24/7.'),
          ),
        ],
      ),
      const SizedBox(height: 18),
      const _AccountSectionLabel('LEGAL'),
      const SizedBox(height: 8),
      _SettingsPanel(
        children: [
          _HelpRow(
            icon: Icons.description_outlined,
            color: FullTankColors.inkSoft,
            title: 'Términos y condiciones',
            detail: 'Versión 3.2 · vigente desde jul 2026',
            onTap: () => _showMessage(context, 'Términos y condiciones.'),
          ),
          _HelpRow(
            icon: Icons.privacy_tip_outlined,
            color: FullTankColors.inkSoft,
            title: 'Aviso de privacidad',
            detail: 'Manejo de datos y sensores IoT',
            onTap: () => _showMessage(context, 'Aviso de privacidad.'),
          ),
        ],
      ),
      const SizedBox(height: 18),
      const Center(
        child: Text('FULLTANK · VERSIÓN 3.2.1 · build 4482', style: _smallText),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onSignOut,
          icon: const Icon(Icons.logout, size: 14),
          label: const Text('Cerrar sesión'),
          style: OutlinedButton.styleFrom(
            foregroundColor: FullTankColors.danger,
            side: const BorderSide(color: Color(0xFFFECACA)),
            minimumSize: const Size.fromHeight(38),
            shape: const StadiumBorder(),
          ),
        ),
      ),
    ],
  );
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton(
        tooltip: 'Volver',
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back, size: 18),
        style: IconButton.styleFrom(
          backgroundColor: FullTankColors.card,
          fixedSize: const Size(42, 42),
          padding: EdgeInsets.zero,
        ),
      ),
      const SizedBox(width: 11),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: _headerTitle),
            Text(subtitle, style: _smallText),
          ],
        ),
      ),
    ],
  );
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) =>
      _AccountPanel(child: Column(children: _withDividers(children)));

  List<Widget> _withDividers(List<Widget> items) => [
    for (var i = 0; i < items.length; i++) ...[
      items[i],
      if (i < items.length - 1)
        const Divider(height: 1, color: FullTankColors.line),
    ],
  ];
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.detail,
    this.trailing,
    this.badge,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String detail;
  final Widget? trailing;
  final String? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          _AccountIconTile(icon: icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _bodyStrong),
                Text(detail, style: _smallText),
              ],
            ),
          ),
          if (badge != null)
            _StatusPill(label: badge!, color: _teal, softColor: _tealSoft),
          trailing ??
              const Icon(
                Icons.chevron_right,
                size: 16,
                color: FullTankColors.inkSoft,
              ),
        ],
      ),
    ),
  );
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.detail,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String detail;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 13),
    child: Row(
      children: [
        _AccountIconTile(icon: icon, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: _bodyStrong),
              Text(detail, style: _smallText),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: FullTankColors.blue,
        ),
      ],
    ),
  );
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow({
    required this.icon,
    required this.title,
    required this.detail,
    this.current = false,
    this.onClose,
  });

  final IconData icon;
  final String title;
  final String detail;
  final bool current;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 13),
    child: Row(
      children: [
        _AccountIconTile(icon: icon, color: FullTankColors.blue),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: _bodyStrong),
              Text(detail, style: _smallText),
            ],
          ),
        ),
        if (current)
          const _StatusPill(
            label: 'AHORA',
            color: FullTankColors.blue,
            softColor: FullTankColors.blueSoft,
          )
        else
          TextButton(
            onPressed: onClose,
            child: const Text(
              'Cerrar',
              style: TextStyle(color: FullTankColors.danger),
            ),
          ),
      ],
    ),
  );
}

class _HelpRow extends StatelessWidget {
  const _HelpRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.detail,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String detail;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          _AccountIconTile(icon: icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _bodyStrong),
                Text(detail, style: _smallText),
              ],
            ),
          ),
          if (badge != null)
            _StatusPill(label: badge!, color: _teal, softColor: _tealSoft),
          const Icon(
            Icons.chevron_right,
            size: 16,
            color: FullTankColors.inkSoft,
          ),
        ],
      ),
    ),
  );
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const languages = ['Español', 'English', 'Português'];
    return Container(
      height: 42,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: FullTankColors.card,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        children: [
          for (var i = 0; i < languages.length; i++)
            Expanded(
              child: InkWell(
                onTap: () => onChanged(i),
                borderRadius: BorderRadius.circular(99),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected == i
                        ? FullTankColors.blue
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    languages[i],
                    style: TextStyle(
                      color: selected == i
                          ? Colors.white
                          : FullTankColors.navyMid,
                      fontSize: 7.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickAccess extends StatelessWidget {
  const _QuickAccess({
    required this.icon,
    required this.label,
    required this.color,
    required this.softColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color softColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      height: 92,
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF0F2F5)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D1A202C),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _AccountIconTile(icon: icon, color: color, size: 30),
          Text(label, textAlign: TextAlign.center, style: _quickText),
        ],
      ),
    ),
  );
}

class _AccountSectionLabel extends StatelessWidget {
  const _AccountSectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: _microLabel);
}

class _AccountPanel extends StatelessWidget {
  const _AccountPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x10000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}

class _AccountIconTile extends StatelessWidget {
  const _AccountIconTile({
    required this.icon,
    required this.color,
    this.size = 26,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size * 1.2,
    height: size * 1.2,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color.withAlpha(20),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(icon, size: size * .58, color: color),
  );
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials, required this.size});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: FullTankColors.navy,
      borderRadius: BorderRadius.circular(size * .25),
    ),
    child: Text(
      initials,
      style: TextStyle(
        color: Colors.white,
        fontSize: size * .32,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
    required this.softColor,
  });

  final String label;
  final Color color;
  final Color softColor;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: softColor,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 6.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

const _headerTitle = TextStyle(
  color: FullTankColors.navy,
  fontSize: 19,
  fontWeight: FontWeight.w800,
  letterSpacing: -.5,
);
const _bodyStrong = TextStyle(
  color: FullTankColors.navy,
  fontSize: 9,
  fontWeight: FontWeight.w800,
);
const _smallText = TextStyle(color: FullTankColors.inkMid, fontSize: 7);
const _microLabel = TextStyle(
  color: FullTankColors.inkMid,
  fontSize: 6.5,
  fontWeight: FontWeight.w800,
);
const _contactValue = TextStyle(
  color: FullTankColors.navy,
  fontSize: 8,
  fontWeight: FontWeight.w700,
);
const _fieldText = TextStyle(
  color: FullTankColors.navyMid,
  fontSize: 8,
  fontWeight: FontWeight.w600,
);
const _scoreText = TextStyle(
  color: _teal,
  fontSize: 9,
  fontWeight: FontWeight.w800,
);
const _quickText = TextStyle(
  color: FullTankColors.navyMid,
  fontSize: 7,
  height: 1.05,
  fontWeight: FontWeight.w700,
);
