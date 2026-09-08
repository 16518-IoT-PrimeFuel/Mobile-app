part of 'account_page.dart';

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
