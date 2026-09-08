part of 'home_page.dart';

class _TankSummaryCard extends StatelessWidget {
  const _TankSummaryCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TANQUE PRINCIPAL · A-102 DIÉSEL', style: _labelStyle),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: FullTankColors.inkMid,
                        ),
                        SizedBox(width: 4),
                        Text('Norte · Sector 4', style: _metaStyle),
                      ],
                    ),
                  ],
                ),
              ),
              _TinyPill(
                label: 'ACTIVO',
                color: _green,
                softColor: _greenSoft,
                dot: true,
              ),
            ],
          ),
          const SizedBox(height: 21),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NIVEL DE COMBUSTIBLE', style: _labelStyle),
                    SizedBox(height: 1),
                    Text.rich(
                      TextSpan(
                        text: '68',
                        style: TextStyle(
                          color: FullTankColors.navy,
                          fontSize: 42,
                          height: 1,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.8,
                        ),
                        children: [
                          TextSpan(
                            text: '%',
                            style: TextStyle(fontSize: 19, letterSpacing: -.5),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3),
                    Text('10.200 / 15.000 L', style: _metaStyle),
                  ],
                ),
              ),
              const _VerticalLevelBar(value: .68),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: FullTankColors.line),
          const SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TinyPill(
                label: 'Normal',
                color: _green,
                softColor: _greenSoft,
                dot: true,
              ),
              const Row(
                children: [
                  Icon(Icons.sync, size: 15, color: FullTankColors.inkSoft),
                  SizedBox(width: 5),
                  Text('Actualizado hace 5 min', style: _metaStyle),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
                onPressed: () => context.push('/home/activity'),
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
