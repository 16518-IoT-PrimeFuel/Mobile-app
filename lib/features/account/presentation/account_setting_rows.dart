part of 'account_page.dart';

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
