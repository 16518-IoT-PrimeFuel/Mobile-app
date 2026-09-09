part of 'reports_page.dart';

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: FullTankColors.inkMid,
          fontSize: 5.5,
          fontWeight: FontWeight.w800,
        ),
      ),
      Text(
        value,
        style: const TextStyle(
          color: FullTankColors.navy,
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton();
  @override
  Widget build(BuildContext context) => Container(
    height: 46,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [FullTankColors.ctaFrom, FullTankColors.ctaTo],
      ),
      borderRadius: BorderRadius.circular(99),
      boxShadow: const [
        BoxShadow(
          color: Color(0x44FFA500),
          blurRadius: 14,
          offset: Offset(0, 7),
        ),
      ],
    ),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.download_outlined, size: 14, color: Colors.white),
        SizedBox(width: 6),
        Text(
          'Generar y descargar PDF',
          style: TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _DeltaBadge extends StatelessWidget {
  const _DeltaBadge(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFE9FFF4),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      '↑ $text',
      style: const TextStyle(
        color: Color(0xFF059669),
        fontSize: 6.5,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _IndustryRows extends StatelessWidget {
  const _IndustryRows();
  @override
  Widget build(BuildContext context) => const Column(
    children: [
      _IndustryRow(
        icon: Icons.local_shipping_outlined,
        label: 'Transporte',
        liters: '184.000 L',
        percent: '42%',
        widthFactor: .42,
        color: FullTankColors.blue,
      ),
      _IndustryRow(
        icon: Icons.agriculture_outlined,
        label: 'Agricultura',
        liters: '118.000 L',
        percent: '27%',
        widthFactor: .27,
        color: Color(0xFF0F9B91),
      ),
      _IndustryRow(
        icon: Icons.factory_outlined,
        label: 'Manufactura',
        liters: '81.000 L',
        percent: '18%',
        widthFactor: .18,
        color: Color(0xFFC56B2C),
      ),
      _IndustryRow(
        icon: Icons.construction_outlined,
        label: 'Construcción',
        liters: '57.000 L',
        percent: '13%',
        widthFactor: .13,
        color: Color(0xFF8B5CF6),
      ),
    ],
  );
}

class _IndustryRow extends StatelessWidget {
  const _IndustryRow({
    required this.icon,
    required this.label,
    required this.liters,
    required this.percent,
    required this.widthFactor,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String liters;
  final String percent;
  final double widthFactor;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 7),
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          color: Color(0x10000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            _TinyIcon(icon: icon, color: color),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: FullTankColors.navy,
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    liters,
                    style: const TextStyle(
                      color: FullTankColors.inkSoft,
                      fontSize: 6.5,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              percent,
              style: const TextStyle(
                color: FullTankColors.navy,
                fontSize: 8,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: widthFactor,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
