part of 'home_page.dart';

class _VerticalLevelBar extends StatelessWidget {
  const _VerticalLevelBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) => Container(
    width: 52,
    height: 104,
    padding: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: const Color(0xFFF3F7F8),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: value,
        widthFactor: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF27BD91),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
  );
}

class _OrderStatusCard extends StatelessWidget {
  const _OrderStatusCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PEDIDO ACTIVO', style: _labelStyle),
                  const SizedBox(height: 2),
                  Text('#${order.id}', style: _valueStyle),
                  Text(
                    '${_litres(order.quantity)} L · ${order.fuel}',
                    style: _metaStyle,
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.push('/orders/${order.id}'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Row(
                  children: [
                    Text(
                      'Ver detalles',
                      style: TextStyle(
                        color: FullTankColors.primary,
                        fontSize: 13.05,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: FullTankColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _OrderProgress(status: order.status),
        ],
      ),
    );
  }
}

class _OrderProgress extends StatelessWidget {
  const _OrderProgress({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final approved =
        status == OrderStatus.approved ||
        status == OrderStatus.inTransit ||
        status == OrderStatus.delivered;
    final dispatched =
        status == OrderStatus.inTransit || status == OrderStatus.delivered;
    final delivered = status == OrderStatus.delivered;
    Color line(bool on) => on ? _green : FullTankColors.border;
    return Row(
      children: [
        _ProgressNode(
          label: 'APROBADO',
          icon: Icons.check,
          color: approved ? _green : FullTankColors.muted,
          active: approved,
        ),
        Expanded(child: Divider(color: line(dispatched), thickness: 1.5)),
        _ProgressNode(
          label: 'DESPACHADO',
          icon: Icons.local_shipping_outlined,
          color: dispatched ? _green : FullTankColors.muted,
          active: dispatched,
        ),
        Expanded(child: Divider(color: line(delivered), thickness: 1.5)),
        _ProgressNode(
          label: 'ENTREGADO',
          icon: Icons.flag_outlined,
          color: delivered ? _green : FullTankColors.muted,
          active: delivered,
        ),
      ],
    );
  }
}

class _ProgressNode extends StatelessWidget {
  const _ProgressNode({
    required this.label,
    required this.icon,
    required this.color,
    required this.active,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 23,
        height: 23,
        decoration: BoxDecoration(
          color: active ? color : FullTankColors.background,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 13, color: active ? Colors.white : color),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          color: active ? FullTankColors.textSecondary : FullTankColors.muted,
          fontSize: 12.325,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({this.pendingOrders, this.totalFuelSoldLitres});

  final int? pendingOrders;
  final double? totalFuelSoldLitres;

  @override
  Widget build(BuildContext context) => GridView.count(
    crossAxisCount: 2,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    childAspectRatio: 1.65,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    children: [
      if (pendingOrders != null)
        _SummaryMetric(
          icon: Icons.description_outlined,
          label: 'PEDIDOS PENDIENTES',
          value: '$pendingOrders',
          color: FullTankColors.primary,
          softColor: FullTankColors.primarySoft,
        ),
      if (totalFuelSoldLitres != null)
        _SummaryMetric(
          icon: Icons.opacity_outlined,
          label: 'COMBUSTIBLE VENDIDO',
          value: _litres(totalFuelSoldLitres!),
          unit: 'L',
          color: FullTankColors.accent,
          softColor: const Color(0xFFFFF1E8),
        ),
    ],
  );
}
