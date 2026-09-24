part of 'order_pages.dart';

class _ActiveOrders extends StatelessWidget {
  const _ActiveOrders({
    required this.filter,
    required this.orders,
    required this.providerMode,
    required this.onAccept,
    required this.onReject,
  });
  final String filter;
  final List<Order> orders;
  final bool providerMode;
  final ValueChanged<int> onAccept;
  final ValueChanged<int> onReject;
  @override
  Widget build(BuildContext context) {
    final shown = orders
        .where((order) {
          if (filter.startsWith('Pendiente'))
            return order.status == OrderStatus.pending;
          if (filter.startsWith('Aprobado'))
            return order.status == OrderStatus.approved;
          if (filter.startsWith('En tránsito'))
            return order.status == OrderStatus.inTransit;
          return true;
        })
        .map(
          (order) => _ActiveOrderData(
            id: '#${order.id}',
            status: _orderStatusLabel(order.status),
            fuel: order.fuel,
            quantity: '${order.quantity.toStringAsFixed(0)} L',
            supplier: order.deliveryAddress.isEmpty
                ? '—'
                : order.deliveryAddress,
            eta: order.deliveryAddress,
            color: order.status == OrderStatus.approved ? _blue : _orange,
            request: order.request,
          ),
        )
        .toList();
    return Column(
      children: [
        for (final item in shown) ...[
          _ActiveOrderCard(
            data: item,
            onTap: () => context.push('/orders/${item.id.substring(1)}'),
            showRequestActions: providerMode && item.request,
            onAccept: () => onAccept(int.tryParse(item.id.substring(1)) ?? 0),
            onReject: () => onReject(int.tryParse(item.id.substring(1)) ?? 0),
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
    this.request = false,
  });
  final String id, status, fuel, quantity, supplier, eta;
  final Color color;
  final bool request;
}

class _ActiveOrderCard extends StatelessWidget {
  const _ActiveOrderCard({
    required this.data,
    required this.onTap,
    required this.showRequestActions,
    required this.onAccept,
    required this.onReject,
  });
  final _ActiveOrderData data;
  final VoidCallback onTap;
  final bool showRequestActions;
  final VoidCallback onAccept;
  final VoidCallback onReject;
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
                        'ENTREGA',
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
                if (showRequestActions) ...[
                  TextButton(
                    onPressed: onReject,
                    child: const Text('Rechazar'),
                  ),
                  TextButton(onPressed: onAccept, child: const Text('Aceptar')),
                ] else
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
