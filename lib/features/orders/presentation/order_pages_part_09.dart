part of 'order_pages.dart';

class _ActiveOrders extends StatelessWidget {
  const _ActiveOrders({required this.filter});
  final String filter;
  @override
  Widget build(BuildContext context) {
    const items = [
      _ActiveOrderData(
        id: '#FT-88421',
        status: 'En tránsito',
        fuel: 'Diesel · ULSD B5',
        quantity: '6,000 L',
        supplier: 'Global Fuel Corp',
        eta: '~1h 20m',
        color: _orange,
      ),
      _ActiveOrderData(
        id: '#FT-88418',
        status: 'Aprobado',
        fuel: 'Gasoline · 95',
        quantity: '3,200 L',
        supplier: 'Midwest PetroLink',
        eta: 'Dispatch 14:00',
        color: _blue,
      ),
      _ActiveOrderData(
        id: '#FT-88415',
        status: 'Pendiente',
        fuel: 'Diesel · ULSD B5',
        quantity: '4,000 L',
        supplier: 'Global Fuel Corp',
        eta: 'Pending approval',
        color: _orange,
      ),
    ];
    final shown = switch (filter) {
      'Pendiente 1' => items.where((item) => item.status == 'Pendiente'),
      'Aprobado 1' => items.where((item) => item.status == 'Aprobado'),
      'En tránsito 1' => items.where((item) => item.status == 'En tránsito'),
      _ => items,
    };
    return Column(
      children: [
        for (final item in shown) ...[
          _ActiveOrderCard(
            data: item,
            onTap: () => context.push('/orders/${item.id.substring(1)}'),
          ),
          if (item != shown.last) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _ActiveOrderData {
  const _ActiveOrderData({
    required this.id,
    required this.status,
    required this.fuel,
    required this.quantity,
    required this.supplier,
    required this.eta,
    required this.color,
  });
  final String id, status, fuel, quantity, supplier, eta;
  final Color color;
}

class _ActiveOrderCard extends StatelessWidget {
  const _ActiveOrderCard({required this.data, required this.onTap});
  final _ActiveOrderData data;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '${data.id}, ${data.status}, ${data.fuel}',
    child: InkWell(
      onTap: onTap,
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
                Icon(
                  data.status == 'Pendiente'
                      ? Icons.hourglass_empty
                      : Icons.local_shipping_outlined,
                  size: 13,
                  color: data.color,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    data.id,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _StatusTag(data.status, color: data.color),
              ],
            ),
            const SizedBox(height: 7),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(8, 7, 8, 6),
              decoration: BoxDecoration(
                color: _panel,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _MiniData(
                          label: 'FUEL',
                          value: data.fuel,
                          icon: Icons.opacity_outlined,
                        ),
                      ),
                      Expanded(
                        child: _MiniData(
                          label: 'QUANTITY',
                          value: data.quantity,
                          icon: Icons.local_gas_station_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text(
                        'SUPPLIER',
                        style: TextStyle(
                          color: _subtle,
                          fontSize: 6,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        data.supplier,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: data.status == 'Pendiente'
                        ? .1
                        : data.status == 'Aprobado'
                        ? .45
                        : .76,
                    minHeight: 3,
                    color: data.color,
                    backgroundColor: _line,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  data.eta,
                  style: const TextStyle(color: _muted, fontSize: 7),
                ),
                const SizedBox(width: 7),
                const Text(
                  'Track  ›',
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

