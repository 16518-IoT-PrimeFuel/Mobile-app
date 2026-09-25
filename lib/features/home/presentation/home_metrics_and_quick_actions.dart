part of 'home_page.dart';

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.trend,
    required this.color,
    required this.softColor,
    this.unit,
  });

  final IconData icon;
  final String label;
  final String value;
  final String trend;
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
            Text(
              '↑ $trend',
              style: const TextStyle(
                color: _green,
                fontSize: 13.05,
                fontWeight: FontWeight.w800,
              ),
            ),
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
                    color: Color(0xFF94A3B8),
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

class _ActionRequiredCard extends StatelessWidget {
  const _ActionRequiredCard({
    required this.color,
    required this.priority,
    required this.reference,
    required this.title,
    required this.detail,
    required this.button,
    this.onTap,
  });

  final Color color;
  final String priority;
  final String reference;
  final String title;
  final String detail;
  final String button;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(11, 11, 9, 11),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        left: BorderSide(color: color, width: 3),
        bottom: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IconTile(
          icon: Icons.check,
          color: color,
          softColor: color == _red ? _redSoft : _amberSoft,
          size: 31,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _TinyPill(
                    label: priority,
                    color: color,
                    softColor: color == _red ? _redSoft : _amberSoft,
                  ),
                  const SizedBox(width: 5),
                  Text(reference, style: _metaStyle),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1A202C),
                  fontSize: 16.675,
                  height: 1.12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: const TextStyle(
                  color: Color(0xFF4A5568),
                  fontSize: 13.05,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Padding(
          padding: const EdgeInsets.only(top: 14),
          child: _DarkButton(label: button, onTap: onTap ?? () {}),
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
        border: Border.all(color: const Color(0xFFF0F2F5)),
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
              color: Color(0xFF2D3748),
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
