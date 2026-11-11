part of 'home_page.dart';

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding = const EdgeInsets.all(14)});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.fromLTRB(
      padding.left * 1.45,
      padding.top * 1.45,
      padding.right * 1.45,
      padding.bottom * 1.45,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.3),
      border: Border.all(color: FullTankColors.background),
      boxShadow: [
        BoxShadow(
          color: const Color(0x0D1A202C),
          blurRadius: 26.1,
          offset: const Offset(0, 10.15),
        ),
      ],
    ),
    child: child,
  );
}

class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.icon,
    required this.color,
    required this.softColor,
    this.size = 32,
  });

  final IconData icon;
  final Color color;
  final Color softColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scaledSize = size * 1.45;
    return Container(
      width: scaledSize,
      height: scaledSize,
      decoration: BoxDecoration(
        color: softColor,
        borderRadius: BorderRadius.circular(13.05),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: scaledSize * .52, color: color),
    );
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({
    required this.label,
    required this.color,
    required this.softColor,
    this.dot = false,
  });

  final String label;
  final Color color;
  final Color softColor;
  final bool dot;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 10.15, vertical: 4.35),
    decoration: BoxDecoration(
      color: softColor,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dot) ...[
          Container(
            width: 7.25,
            height: 7.25,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5.8),
        ],
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12.325,
            fontWeight: FontWeight.w800,
            letterSpacing: .2,
          ),
        ),
      ],
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: _labelStyle);
}

const _labelStyle = TextStyle(
  color: FullTankColors.textSecondary,
  fontSize: 13.775,
  fontWeight: FontWeight.w800,
  letterSpacing: .25,
);
const _metaStyle = TextStyle(
  color: FullTankColors.muted,
  fontSize: 13.775,
  fontWeight: FontWeight.w600,
);
const _valueStyle = TextStyle(
  color: FullTankColors.text,
  fontSize: 27.55,
  height: 1,
  fontWeight: FontWeight.w800,
  letterSpacing: -.5,
);

class GlobalSearchPage extends StatelessWidget {
  const GlobalSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SubpageHeader(
                title: 'Búsqueda global',
                subtitle: 'Encuentra tanques, pedidos y clientes',
              ),
              const SizedBox(height: 14),
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: FullTankColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, size: 18, color: FullTankColors.muted),
                    SizedBox(width: 8),
                    Text(
                      'Buscar "diésel"',
                      style: TextStyle(
                        color: FullTankColors.muted,
                        fontSize: 17.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Wrap(
                spacing: 6,
                children: [
                  _FilterChip(label: 'Todos', selected: true),
                  _FilterChip(label: 'Pedidos 2'),
                  _FilterChip(label: 'Clientes 2'),
                  _FilterChip(label: 'Productos'),
                ],
              ),
              const SizedBox(height: 18),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('6 RESULTADOS PARA "DIÉSEL"', style: _labelStyle),
                  Text('Ordenados por relevancia', style: _metaStyle),
                ],
              ),
              const SizedBox(height: 8),
              const _SearchResult(
                icon: Icons.receipt_long_outlined,
                eyebrow: 'PEDIDO · FT-2041',
                title: 'Diésel B5 · 8.000 L',
                detail: 'Despachado · Hoy · 4:30 PM',
                color: FullTankColors.primary,
                softColor: FullTankColors.primarySoft,
              ),
              const _SearchResult(
                icon: Icons.receipt_long_outlined,
                eyebrow: 'PEDIDO · FT-2038',
                title: 'Diésel B5 · 12.000 L',
                detail: 'Entregado · Ayer',
                color: FullTankColors.primary,
                softColor: FullTankColors.primarySoft,
              ),
              const _SearchResult(
                icon: Icons.person_outline,
                eyebrow: 'CLIENTE · C002',
                title: 'Transportes Delta',
                detail: 'Transporte · Nuevo León · 142 pedidos',
                color: FullTankColors.success,
                softColor: FullTankColors.successSoft,
              ),
              const _SearchResult(
                icon: Icons.person_outline,
                eyebrow: 'CLIENTE · C001',
                title: 'AgroNorte S.A.',
                detail: 'Agricultura · Sonora · 84 pedidos',
                color: FullTankColors.success,
                softColor: FullTankColors.successSoft,
              ),
              const _SearchResult(
                icon: Icons.opacity_outlined,
                eyebrow: 'PRODUCTO · P01',
                title: 'Diésel B5',
                detail: '12.410 L · \$24,10/L · Disponible',
                color: _amber,
                softColor: _amberSoft,
              ),
              const _SearchResult(
                icon: Icons.inventory_2_outlined,
                eyebrow: 'TANQUE · A-102',
                title: 'Tanque de diésel A-102',
                detail: 'Norte · Sector 4 · 68%',
                color: _purple,
                softColor: _purpleSoft,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FullTankBottomNav(active: 0),
    );
  }
}
