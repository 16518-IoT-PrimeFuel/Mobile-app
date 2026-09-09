part of 'order_pages.dart';

class _HistoryMetrics extends StatelessWidget {
  const _HistoryMetrics();
  @override
  Widget build(BuildContext context) => const Row(
    children: [
      Expanded(
        child: _MetricCard(
          label: 'CONSUMO',
          value: '42.8k\nL',
          accent: _blue,
          badge: '+8%',
        ),
      ),
      SizedBox(width: 6),
      Expanded(
        child: _MetricCard(
          label: 'PEDIDOS',
          value: '24',
          accent: _orange,
          badge: '+3',
        ),
      ),
      SizedBox(width: 6),
      Expanded(
        child: _MetricCard(
          label: 'TOTAL',
          value: 'S/\n63k',
          accent: _muted,
          badge: 'mes',
        ),
      ),
    ],
  );
}

class _ActiveMetrics extends StatelessWidget {
  const _ActiveMetrics();
  @override
  Widget build(BuildContext context) => const Row(
    children: [
      Expanded(
        child: _MetricCard(label: 'PENDIENTES', value: '01', accent: _orange),
      ),
      SizedBox(width: 6),
      Expanded(
        child: _MetricCard(label: 'APROBADOS', value: '01', accent: _blue),
      ),
      SizedBox(width: 6),
      Expanded(
        child: _MetricCard(label: 'EN TRÁNSITO', value: '01', accent: _orange),
      ),
    ],
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.accent,
    this.badge,
  });
  final String label, value;
  final Color accent;
  final String? badge;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(9, 8, 7, 8),
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: accent.withAlpha(22),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.insights_outlined, size: 9, color: accent),
            ),
            if (badge != null)
              Text(
                badge!,
                style: TextStyle(
                  color: accent,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                ),
              ),
          ],
        ),
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
            fontSize: 12,
            height: 1.05,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _WeeklyBars extends StatelessWidget {
  const _WeeklyBars({required this.label, required this.action});
  final String label, action;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(11),
      border: Border.all(color: _line),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontSize: 7,
                fontWeight: FontWeight.w800,
                letterSpacing: .3,
              ),
            ),
            Text(
              action,
              style: const TextStyle(
                color: _blue,
                fontSize: 7,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        SizedBox(
          height: 58,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < 8; i++)
                _Bar(
                  value: [0.62, .58, .84, .76, .96, .68, .79, .88][i],
                  label: ['L', 'M', 'M', 'J', 'V', 'S', 'D', ''][i],
                  highlighted: i == 4,
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.value,
    required this.label,
    required this.highlighted,
  });
  final double value;
  final String label;
  final bool highlighted;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 17,
        height: 42 * value,
        decoration: BoxDecoration(
          color: highlighted ? _orange : const Color(0xFF5D8FEF),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
        ),
      ),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(color: _subtle, fontSize: 6)),
    ],
  );
}
