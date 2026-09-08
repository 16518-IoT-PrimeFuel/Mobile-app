part of 'dispatch_pages.dart';

class _ChoiceList extends StatelessWidget {
  const _ChoiceList({
    required this.title,
    required this.helper,
    required this.children,
  });
  final String title, helper;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: _muted,
          fontSize: 7,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 3),
      Text(helper, style: const TextStyle(color: _subtle, fontSize: 7)),
      const SizedBox(height: 7),
      ...children.map(
        (child) =>
            Padding(padding: const EdgeInsets.only(bottom: 7), child: child),
      ),
    ],
  );
}

class _OrderChoice extends StatelessWidget {
  const _OrderChoice({
    required this.title,
    required this.detail,
    this.selected = false,
  });
  final String title, detail;
  final bool selected;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: selected ? _blue : _line),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        const Icon(Icons.inventory_2_outlined, color: _blue, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                detail,
                style: const TextStyle(color: _muted, fontSize: 7.5),
              ),
            ],
          ),
        ),
        if (selected) const Icon(Icons.check_circle, color: _blue, size: 16),
      ],
    ),
  );
}

class _SelectableChoice extends StatelessWidget {
  const _SelectableChoice({
    required this.selected,
    required this.title,
    required this.detail,
    required this.icon,
    required this.onTap,
  });
  final bool selected;
  final String title, detail;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: selected ? _blue : _line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: selected ? _green : _muted, size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: const TextStyle(color: _muted, fontSize: 7.5),
                ),
              ],
            ),
          ),
          if (selected) const Icon(Icons.check_circle, color: _blue, size: 16),
        ],
      ),
    ),
  );
}

class _AssignmentSummary extends StatelessWidget {
  const _AssignmentSummary({required this.vehicle, required this.driver});
  final int vehicle, driver;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _ink,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'RESUMEN DE ASIGNACIÓN',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 7,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            _DarkRow(
              icon: Icons.inventory_2_outlined,
              label: 'PEDIDO',
              value: '#ORD-4820 · Cliente B · 8,500 L',
            ),
            const Divider(color: Colors.white24),
            _DarkRow(
              icon: Icons.local_shipping_outlined,
              label: 'VEHÍCULO',
              value:
                  '${_vehicles[vehicle].plate} · ${_vehicles[vehicle].brand} · 20k L',
            ),
            const Divider(color: Colors.white24),
            _DarkRow(
              icon: Icons.person_outline,
              label: 'CONDUCTOR',
              value: _driversData[driver].name,
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Salida estimada',
                  style: TextStyle(color: Colors.white70, fontSize: 7),
                ),
                Text(
                  'Hoy · 14:15',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

