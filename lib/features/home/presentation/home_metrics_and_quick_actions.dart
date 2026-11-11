part of 'home_page.dart';

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.softColor,
    this.unit,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color softColor;
  final String? unit;

  @override
  Widget build(BuildContext context) => _Card(
    padding: const EdgeInsets.all(11),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _IconTile(icon: icon, color: color, softColor: softColor, size: 27),
          ],
        ),
        const Spacer(),
        Text(label, style: _labelStyle),
        const SizedBox(height: 1),
        Text.rich(
          TextSpan(
            text: value,
            style: _valueStyle,
            children: [
              if (unit != null)
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(
                    color: FullTankColors.muted,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
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
    borderRadius: BorderRadius.circular(17.4),
    child: Container(
      height: 101.5,
      padding: EdgeInsets.symmetric(horizontal: 4.35, vertical: 11.6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: FullTankColors.background),
        borderRadius: BorderRadius.circular(17.4),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D1A202C),
            blurRadius: 14.5,
            offset: const Offset(0, 5.8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _IconTile(icon: icon, color: color, softColor: softColor, size: 27),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              color: FullTankColors.text,
              fontSize: 12.325,
              height: 1.05,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}
