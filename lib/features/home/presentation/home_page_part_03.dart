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
  const _OrderStatusCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PEDIDO ACTIVO', style: _labelStyle),
                  SizedBox(height: 2),
                  Text('#FT-2041', style: _valueStyle),
                  Text('8.000 L · Diésel B5', style: _metaStyle),
                ],
              ),
              TextButton(
                onPressed: () => context.push('/orders/FT-88421'),
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
                        color: FullTankColors.blue,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: FullTankColors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _OrderProgress(),
          const SizedBox(height: 13),
          const Divider(height: 1, color: FullTankColors.line),
          const SizedBox(height: 10),
          const Row(
            children: [
              Icon(Icons.schedule, size: 13, color: FullTankColors.inkMid),
              SizedBox(width: 4),
              Text(
                'ETA Hoy · 4:30 PM',
                style: TextStyle(
                  color: FullTankColors.navy,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Text('de FuelMex Logistics', style: _metaStyle),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderProgress extends StatelessWidget {
  const _OrderProgress();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      _ProgressNode(
        label: 'APROBADO',
        icon: Icons.check,
        color: _green,
        active: true,
      ),
      const Expanded(child: Divider(color: _green, thickness: 1.5)),
      _ProgressNode(
        label: 'DESPACHADO',
        icon: Icons.local_shipping_outlined,
        color: _green,
        active: true,
      ),
      const Expanded(
        child: Divider(color: FullTankColors.line, thickness: 1.5),
      ),
      _ProgressNode(
        label: 'ENTREGADO',
        icon: Icons.flag_outlined,
        color: FullTankColors.inkSoft,
        active: false,
      ),
    ],
  );
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
          color: active ? color : const Color(0xFFF4F6F8),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 13, color: active ? Colors.white : color),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          color: active ? FullTankColors.inkMid : FullTankColors.inkSoft,
          fontSize: 8.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid();

  @override
  Widget build(BuildContext context) => GridView.count(
    crossAxisCount: 2,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    childAspectRatio: 1.65,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    children: const [
      _SummaryMetric(
        icon: Icons.description_outlined,
        label: 'PEDIDOS PENDIENTES',
        value: '12',
        trend: '+8%',
        color: FullTankColors.blue,
        softColor: FullTankColors.blueSoft,
      ),
      _SummaryMetric(
        icon: Icons.local_shipping_outlined,
        label: 'ENTREGAS ACTIVAS',
        value: '7',
        trend: '+2%',
        color: _amber,
        softColor: _amberSoft,
      ),
      _SummaryMetric(
        icon: Icons.business_center_outlined,
        label: 'CLIENTES',
        value: '48',
        trend: '+4%',
        color: Color(0xFF0F9B91),
        softColor: Color(0xFFEAFBF8),
      ),
      _SummaryMetric(
        icon: Icons.opacity_outlined,
        label: 'COMBUSTIBLE VENDIDO',
        value: '74',
        unit: 'kL',
        trend: '+15%',
        color: Color(0xFFE06B2D),
        softColor: Color(0xFFFFF1E8),
      ),
    ],
  );
}
