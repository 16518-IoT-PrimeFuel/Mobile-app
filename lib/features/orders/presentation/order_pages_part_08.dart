part of 'order_pages.dart';

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

class _HistoryOrders extends StatelessWidget {
  const _HistoryOrders({required this.filter});
  final String filter;
  @override
  Widget build(BuildContext context) {
    final items = [
      const _OrderData(
        id: '#FT-88421',
        status: 'En tránsito',
        fuel: 'Diesel · ULSD B5',
        amount: '6,000 L',
        supplier: 'Global Fuel Corp',
        total: 'S/ 9,274.80',
        color: _orange,
      ),
      const _OrderData(
        id: '#FT-88418',
        status: 'Aprobado',
        fuel: 'Gasolina · 95',
        amount: '3,200 L',
        supplier: 'Midwest PetroLink',
        total: 'S/ 5,120.00',
        color: _blue,
      ),
    ];
    final shown = filter == 'Entregado' ? const <_OrderData>[] : items;
    return Column(
      children: [
        for (final item in shown)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _HistoryOrderCard(item: item),
          ),
      ],
    );
  }
}

class _OrderData {
  const _OrderData({
    required this.id,
    required this.status,
    required this.fuel,
    required this.amount,
    required this.supplier,
    required this.total,
    required this.color,
  });
  final String id, status, fuel, amount, supplier, total;
  final Color color;
}

class _HistoryOrderCard extends StatelessWidget {
  const _HistoryOrderCard({required this.item});
  final _OrderData item;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '${item.id}, ${item.status}, ${item.fuel}',
    child: InkWell(
      onTap: () => context.push('/orders/history/${item.id.substring(1)}'),
      borderRadius: BorderRadius.circular(11),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: _line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 17,
                  height: 17,
                  decoration: BoxDecoration(
                    color: item.color.withAlpha(22),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_shipping_outlined,
                    size: 10,
                    color: item.color,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.id,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _StatusTag(item.status, color: item.color),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${item.fuel}  ·  ${item.amount}  ·  ${item.supplier}',
              style: const TextStyle(color: _muted, fontSize: 7.5),
            ),
            const Divider(height: 13, color: _line),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOTAL',
                      style: TextStyle(
                        color: _subtle,
                        fontSize: 6,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      item.total,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Ver detalle  ›',
                  style: TextStyle(
                    color: _blue,
                    fontSize: 7,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
