part of 'order_pages.dart';

class _ErrorIllustration extends StatelessWidget {
  const _ErrorIllustration();
  @override
  Widget build(BuildContext context) => Container(
    width: 82,
    height: 82,
    decoration: const BoxDecoration(
      color: Color(0xFFFFF0F1),
      shape: BoxShape.circle,
    ),
    child: Container(
      margin: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: _red, shape: BoxShape.circle),
      child: const Icon(Icons.wifi_off, color: Colors.white, size: 27),
    ),
  );
}

class _ErrorMeta extends StatelessWidget {
  const _ErrorMeta({required this.history});
  final bool history;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CÓDIGO DE ERROR',
              style: TextStyle(
                color: _subtle,
                fontSize: 6,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              history ? 'HIST_ERR_503' : 'NET_ERR_502',
              style: TextStyle(
                color: _muted,
                fontSize: 8,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'ÚLTIMA SINCRONIZACIÓN',
              style: TextStyle(
                color: _subtle,
                fontSize: 6,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              history ? 'hace 3 min' : 'hace 2 min',
              style: TextStyle(
                color: _muted,
                fontSize: 8,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _DeliveredBanner extends StatelessWidget {
  const _DeliveredBanner();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: _greenSoft,
      border: Border.all(color: const Color(0xFFC7F3DE)),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: _green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ENTREGADO CON ÉXITO',
                style: TextStyle(
                  color: _green,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Ayer, 17:45',
                style: TextStyle(
                  color: _ink,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Recibido por M. Sánchez · Sector 4',
                style: TextStyle(color: _muted, fontSize: 7),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _FuelMetric extends StatelessWidget {
  const _FuelMetric({
    required this.label,
    required this.value,
    required this.detail,
    required this.icon,
    required this.color,
  });
  final String label, value, detail;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(9),
      border: Border.all(color: _line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 15),
        const SizedBox(height: 7),
        Text(
          label,
          style: const TextStyle(
            color: _subtle,
            fontSize: 7,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: _ink,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(detail, style: const TextStyle(color: _muted, fontSize: 7)),
      ],
    ),
  );
}
