part of 'account_page.dart';

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
