part of 'order_pages.dart';

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4),
    child: Semantics(
      button: true,
      label: label,
      child: IconButton(
        onPressed: onTap,
        tooltip: label,
        icon: Icon(icon, size: 14, color: _muted),
        style: IconButton.styleFrom(
          backgroundColor: _panel,
          fixedSize: const Size(32, 32),
          padding: EdgeInsets.zero,
        ),
      ),
    ),
  );
}

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
        child: _MetricCard(label: 'PENDING', value: '01', accent: _orange),
      ),
      SizedBox(width: 6),
      Expanded(
        child: _MetricCard(label: 'APPROVED', value: '01', accent: _blue),
      ),
      SizedBox(width: 6),
      Expanded(
        child: _MetricCard(label: 'TRANSIT', value: '01', accent: _orange),
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

class _Filters extends StatelessWidget {
  const _Filters({
    required this.selected,
    required this.labels,
    required this.onSelected,
    this.leading,
  });
  final String selected;
  final List<String> labels;
  final ValueChanged<String> onSelected;
  final String? leading;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        if (leading != null)
          _Chip(
            label: leading!,
            selected: true,
            icon: Icons.filter_alt_outlined,
            onTap: () {},
          ),
        if (leading != null) const SizedBox(width: 5),
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) const SizedBox(width: 5),
          _Chip(
            label: labels[i],
            selected: selected == labels[i],
            onTap: () => onSelected(labels[i]),
          ),
        ],
      ],
    ),
  );
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: label,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? _ink : Colors.white,
          border: Border.all(color: selected ? _ink : _line),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 11, color: selected ? Colors.white : _muted),
              const SizedBox(width: 3),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : _muted,
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
