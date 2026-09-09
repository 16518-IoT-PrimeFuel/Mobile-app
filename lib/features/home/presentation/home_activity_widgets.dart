part of 'home_page.dart';

class _GradientAction extends StatelessWidget {
  const _GradientAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 39,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [FullTankColors.ctaFrom, FullTankColors.ctaTo],
        ),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x44FFA500),
            blurRadius: 14,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    ),
  );
}

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.title,
    required this.detail,
    required this.color,
    required this.softColor,
  });

  final IconData icon;
  final String title;
  final String detail;
  final Color color;
  final Color softColor;

  @override
  Widget build(BuildContext context) => Container(
    height: 42,
    padding: const EdgeInsets.symmetric(horizontal: 9),
    decoration: BoxDecoration(
      color: const Color(0xFFF8F9FB),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      children: [
        _IconTile(icon: icon, color: color, softColor: softColor, size: 27),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: FullTankColors.navy,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(detail, style: _metaStyle),
            ],
          ),
        ),
        const Icon(
          Icons.chevron_right,
          size: 16,
          color: FullTankColors.inkSoft,
        ),
      ],
    ),
  );
}

class _ActivityGroup extends StatelessWidget {
  const _ActivityGroup({required this.label, required this.items});

  final String label;
  final List<_ActivityItem> items;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: _labelStyle),
      const SizedBox(height: 8),
      ...items,
    ],
  );
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.detail,
    required this.time,
    required this.color,
    required this.softColor,
  });

  final IconData icon;
  final String title;
  final String detail;
  final String time;
  final Color color;
  final Color softColor;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: FullTankColors.line),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IconTile(icon: icon, color: color, softColor: softColor, size: 28),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: FullTankColors.navy,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: const TextStyle(
                  color: FullTankColors.inkMid,
                  fontSize: 8.5,
                ),
              ),
            ],
          ),
        ),
        Text(time, style: _metaStyle),
      ],
    ),
  );
}
