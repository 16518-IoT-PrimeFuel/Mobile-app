part of 'order_pages.dart';

class _DetailTable extends StatelessWidget {
  const _DetailTable({required this.title, required this.rows});
  final String title;
  final List<(String, String)> rows;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(9),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _subtle,
            fontSize: 7,
            fontWeight: FontWeight.w800,
            letterSpacing: .3,
          ),
        ),
        const SizedBox(height: 7),
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const Divider(height: 12, color: _line),
          Row(
            children: [
              Expanded(
                child: Text(
                  rows[i].$1,
                  style: const TextStyle(color: _muted, fontSize: 8),
                ),
              ),
              Expanded(
                child: Text(
                  rows[i].$2,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

class _CurrentStateBanner extends StatelessWidget {
  const _CurrentStateBanner();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF5E9),
      border: Border.all(color: const Color(0xFFFFD9AB)),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      children: [
        Container(
          width: 29,
          height: 29,
          decoration: const BoxDecoration(
            color: _orange,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.local_shipping_outlined,
            color: Colors.white,
            size: 17,
          ),
        ),
        const SizedBox(width: 8),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CURRENT STATE',
              style: TextStyle(
                color: _orange,
                fontSize: 7,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'En tránsito',
              style: TextStyle(
                color: _ink,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'ETA en ~1h 20m · 12 km remaining',
              style: TextStyle(color: _muted, fontSize: 7),
            ),
          ],
        ),
      ],
    ),
  );
}

class _DeliveryTimeline extends StatelessWidget {
  const _DeliveryTimeline();
  @override
  Widget build(BuildContext context) => const Column(
    children: [
      _TimelineStep(
        label: 'Pedido creado',
        detail: 'Today, 09:12',
        color: _orange,
        icon: Icons.check,
      ),
      _TimelineStep(
        label: 'Aprobado',
        detail: 'Today, 09:34',
        color: _blue,
        icon: Icons.check,
      ),
      _TimelineStep(
        label: 'En tránsito',
        detail: 'Today, 10:05',
        color: _muted,
        icon: Icons.local_shipping_outlined,
      ),
      _TimelineStep(
        label: 'Entregado',
        detail: 'ETA ~11:30',
        color: _line,
        icon: Icons.circle,
      ),
    ],
  );
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.label,
    required this.detail,
    required this.color,
    required this.icon,
  });
  final String label, detail;
  final Color color;
  final IconData icon;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 46,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          child: Column(
            children: [
              Container(
                width: 19,
                height: 19,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Icon(
                  icon,
                  color: color == _line ? _subtle : Colors.white,
                  size: 11,
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: color == _line ? _line : color.withAlpha(100),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: _ink,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(detail, style: const TextStyle(color: _muted, fontSize: 7)),
          ],
        ),
      ],
    ),
  );
}

