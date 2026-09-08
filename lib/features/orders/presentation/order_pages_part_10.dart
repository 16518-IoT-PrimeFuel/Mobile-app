part of 'order_pages.dart';

class _MiniData extends StatelessWidget {
  const _MiniData({
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label, value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 10, color: _muted),
      const SizedBox(width: 4),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _subtle,
              fontSize: 6,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: _ink,
              fontSize: 7,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ],
  );
}

class _StatusTag extends StatelessWidget {
  const _StatusTag(this.label, {required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      color: color.withAlpha(22),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      label,
      style: TextStyle(color: color, fontSize: 7, fontWeight: FontWeight.w800),
    ),
  );
}

class _SkeletonMetrics extends StatelessWidget {
  const _SkeletonMetrics();
  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (var i = 0; i < 3; i++)
        Expanded(
          child: Container(
            height: 39,
            margin: EdgeInsets.only(right: i == 2 ? 0 : 6),
            decoration: BoxDecoration(
              color: _panel,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
    ],
  );
}

class _SkeletonOrders extends StatelessWidget {
  const _SkeletonOrders();
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        height: 62,
        decoration: BoxDecoration(
          color: _panel,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      const SizedBox(height: 8),
      for (var i = 0; i < 3; i++)
        Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _panel,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const _SkeletonLine(width: 18),
                  const SizedBox(width: 7),
                  const _SkeletonLine(width: 75),
                  const Spacer(),
                  const _SkeletonLine(width: 42),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const _SkeletonLine(width: 120),
                  const Spacer(),
                  const _SkeletonLine(width: 70),
                ],
              ),
              const SizedBox(height: 12),
              const _SkeletonLine(width: double.infinity),
            ],
          ),
        ),
    ],
  );
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.width});
  final double width;
  @override
  Widget build(BuildContext context) => Container(
    width: width.isFinite ? width : double.infinity,
    height: 8,
    decoration: BoxDecoration(
      color: const Color(0xFFE8EEF6),
      borderRadius: BorderRadius.circular(99),
    ),
  );
}

class _EmptyIllustration extends StatelessWidget {
  const _EmptyIllustration({required this.icon, required this.color});
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    width: 82,
    height: 82,
    decoration: const BoxDecoration(color: _blueSoft, shape: BoxShape.circle),
    child: Center(
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Colors.white54,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: _blue, size: 34),
      ),
    ),
  );
}

class _TipBox extends StatelessWidget {
  const _TipBox({required this.history});
  final bool history;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: _blueSoft,
      border: Border.all(color: const Color(0xFFD9E5FF)),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info, size: 13, color: _blue),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            history
                ? 'Tip: Podrás filtrar por fecha, tipo de combustible y estado para revisar tu consumo mensual.'
                : 'Tip: puedes crear un pedido rápido desde la lista de tanques cuando el nivel esté bajo.',
            style: const TextStyle(color: _muted, fontSize: 8, height: 1.4),
          ),
        ),
      ],
    ),
  );
}
