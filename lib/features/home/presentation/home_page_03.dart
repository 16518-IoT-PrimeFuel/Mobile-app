part of 'home_page.dart';

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid();

  @override
  Widget build(BuildContext context) => GridView.count(
    crossAxisCount: 2,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    childAspectRatio: 1.65,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    children: const [
      _SummaryMetric(
        icon: Icons.description_outlined,
        label: 'PEDIDOS PENDIENTES',
        value: '12',
        trend: '+8%',
        color: FullTankColors.blue,
        softColor: FullTankColors.blueSoft,
      ),
      _SummaryMetric(
        icon: Icons.local_shipping_outlined,
        label: 'ENTREGAS ACTIVAS',
        value: '7',
        trend: '+2%',
        color: _amber,
        softColor: _amberSoft,
      ),
      _SummaryMetric(
        icon: Icons.business_center_outlined,
        label: 'CLIENTES',
        value: '48',
        trend: '+4%',
        color: Color(0xFF0F9B91),
        softColor: Color(0xFFEAFBF8),
      ),
      _SummaryMetric(
        icon: Icons.opacity_outlined,
        label: 'COMBUSTIBLE VENDIDO',
        value: '74',
        unit: 'kL',
        trend: '+15%',
        color: Color(0xFFE06B2D),
        softColor: Color(0xFFFFF1E8),
      ),
    ],
  );
}

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
                fontSize: 9,
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
                    color: FullTankColors.inkSoft,
                    fontSize: 10,
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
        bottom: const BorderSide(color: FullTankColors.line),
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
                  color: FullTankColors.navy,
                  fontSize: 11.5,
                  height: 1.12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: const TextStyle(
                  color: FullTankColors.inkMid,
                  fontSize: 9,
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
    borderRadius: BorderRadius.circular(12 * _uiTextScale),
    child: Container(
      height: 70 * _uiTextScale,
      padding: EdgeInsets.symmetric(
        horizontal: 3 * _uiTextScale,
        vertical: 8 * _uiTextScale,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF0F2F5)),
        borderRadius: BorderRadius.circular(12 * _uiTextScale),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D1A202C),
            blurRadius: 10 * _uiTextScale,
            offset: Offset(0, 4 * _uiTextScale),
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
              color: FullTankColors.navyMid,
              fontSize: 8.5,
              height: 1.05,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding = const EdgeInsets.all(14)});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.fromLTRB(
      padding.left * _uiTextScale,
      padding.top * _uiTextScale,
      padding.right * _uiTextScale,
      padding.bottom * _uiTextScale,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14 * _uiTextScale),
      border: Border.all(color: const Color(0xFFF0F2F5)),
      boxShadow: [
        BoxShadow(
          color: const Color(0x0D1A202C),
          blurRadius: 18 * _uiTextScale,
          offset: Offset(0, 7 * _uiTextScale),
        ),
      ],
    ),
    child: child,
  );
}
