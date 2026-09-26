part of 'order_pages.dart';

class _ActiveOrders extends StatelessWidget {
  const _ActiveOrders({required this.orders, required this.filter});
  final List<Order> orders;
  final String filter;
  @override
  Widget build(BuildContext context) {
    final items = orders
        .map(
          (order) => _ActiveOrderData(
            order: order,
            id: '#${order.id}',
            status: orderStatusLabel(order.status),
            fuel: order.fuel,
            quantity: orderQuantityLabel(order.quantity),
            supplier: order.deliveryAddress.isEmpty
                ? 'Proveedor asignado'
                : order.deliveryAddress,
            eta: order.status == OrderStatus.pending
                ? 'Pendiente de aprobación'
                : 'Seguimiento disponible',
            color: orderStatusColor(order.status),
          ),
        )
        .toList();
    final shown = switch (filter) {
      'Pendiente' => items.where((item) => item.status == 'Pendiente'),
      'Aprobado' => items.where((item) => item.status == 'Aprobado'),
      'En tránsito' => items.where((item) => item.status == 'En tránsito'),
      _ => items,
    };
    return Column(
      children: [
        for (final item in shown) ...[
          _ActiveOrderCard(
            data: item,
            onTap: () => context.push('/orders/${item.order.id}'),
          ),
          if (item != shown.last) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _ActiveOrderData {
  const _ActiveOrderData({
    required this.order,
    required this.id,
    required this.status,
    required this.fuel,
    required this.quantity,
    required this.supplier,
    required this.eta,
    required this.color,
  });
  final Order order;
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
                      fontSize: 14.5,
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
                          label: 'COMBUSTIBLE',
                          value: data.fuel,
                          icon: Icons.opacity_outlined,
                        ),
                      ),
                      Expanded(
                        child: _MiniData(
                          label: 'CANTIDAD',
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
                        'PROVEEDOR',
                        style: TextStyle(
                          color: _subtle,
                          fontSize: 8.7,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        data.supplier,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 10.15,
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
                  style: const TextStyle(color: _muted, fontSize: 10.15),
                ),
                const SizedBox(width: 7),
                const Text(
                  'Ver  ›',
                  style: TextStyle(
                    color: _blue,
                    fontSize: 10.15,
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
