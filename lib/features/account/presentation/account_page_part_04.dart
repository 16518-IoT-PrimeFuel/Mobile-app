part of 'account_page.dart';

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
            onTap: () => context.push('/support/help'),
          ),
          _HelpRow(
            icon: Icons.headset_mic_outlined,
            color: _teal,
            title: 'Contactar soporte',
            detail: 'Respuesta promedio · 4 min',
            badge: '24/7',
            onTap: () => context.push('/support/contact'),
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
