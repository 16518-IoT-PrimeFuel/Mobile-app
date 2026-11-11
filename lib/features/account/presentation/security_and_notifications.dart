part of 'account_page.dart';

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.icon,
    required this.controller,
    this.keyboardType,
    this.errorText,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? errorText;

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
            errorText: errorText,
            prefixIcon: Icon(icon, size: 15, color: FullTankColors.muted),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 14,
            ),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: FullTankColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: FullTankColors.border),
            ),
          ),
        ),
      ],
    ),
  );
}

class _SecuritySettings extends ConsumerStatefulWidget {
  const _SecuritySettings();

  @override
  ConsumerState<_SecuritySettings> createState() => _SecuritySettingsState();
}

class _SecuritySettingsState extends ConsumerState<_SecuritySettings> {
  bool _busy = false;

  Future<void> _sendResetEmail() async {
    final session = ref.read(authControllerProvider).session;
    if (_busy || session == null || isGuestSession(session)) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .requestPasswordReset(session.username);
      if (mounted) {
        _showMessage(
          context,
          'Te enviamos un correo para cambiar tu contraseña.',
        );
      }
    } catch (_) {
      if (mounted) _showMessage(context, 'No se pudo enviar el correo.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signOut() async {
    await ref.read(authControllerProvider.notifier).signOut();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final guest = isGuestSession(ref.watch(authControllerProvider).session);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AccountHeader(
          title: 'Seguridad',
          subtitle: 'Protege tu cuenta y sesiones',
        ),
        const SizedBox(height: 16),
        const _AccountSectionLabel('AUTENTICACIÓN'),
        const SizedBox(height: 8),
        _SettingsPanel(
          children: [
            _SettingsRow(
              icon: Icons.key_outlined,
              color: FullTankColors.primary,
              title: 'Cambiar contraseña por correo',
              detail: guest
                  ? 'Vista previa: requiere una cuenta'
                  : 'Te enviamos un enlace para restablecerla',
              onTap: guest ? null : _sendResetEmail,
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _AccountSectionLabel('SESIÓN'),
        const SizedBox(height: 8),
        _SettingsPanel(
          children: [
            _SettingsRow(
              icon: Icons.logout,
              color: FullTankColors.error,
              title: 'Cerrar sesión',
              detail: 'Finaliza la sesión actual en este dispositivo',
              onTap: _signOut,
            ),
          ],
        ),
      ],
    );
  }
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
            color: FullTankColors.error,
            title: 'Alertas de combustible',
            detail: 'Umbrales críticos y advertencias\nde nivel',
            value: enabled[0],
            onChanged: (value) => setState(() => enabled[0] = value),
          ),
          _NotificationRow(
            icon: Icons.receipt_long_outlined,
            color: FullTankColors.primary,
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
            color: FullTankColors.muted,
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
