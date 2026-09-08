part of 'home_page.dart';

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding = const EdgeInsets.all(14)});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.fromLTRB(
      padding.left * _uiTextScale,
      padding.top * _uiTextScale,
      padding.right * _uiTextScale,
      padding.bottom * _uiTextScale,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14 * _uiTextScale),
      border: Border.all(color: const Color(0xFFF0F2F5)),
      boxShadow: [
        BoxShadow(
          color: const Color(0x0D1A202C),
          blurRadius: 18 * _uiTextScale,
          offset: Offset(0, 7 * _uiTextScale),
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
    final scaledSize = size * _uiTextScale;
    return Container(
      width: scaledSize,
      height: scaledSize,
      decoration: BoxDecoration(
        color: softColor,
        borderRadius: BorderRadius.circular(9 * _uiTextScale),
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
    padding: EdgeInsets.symmetric(
      horizontal: 7 * _uiTextScale,
      vertical: 3 * _uiTextScale,
    ),
    decoration: BoxDecoration(
      color: softColor,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dot) ...[
          Container(
            width: 5 * _uiTextScale,
            height: 5 * _uiTextScale,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 4 * _uiTextScale),
        ],
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 8.5,
            fontWeight: FontWeight.w800,
            letterSpacing: .2,
          ),
        ),
      ],
    ),
  );
}

class _DarkButton extends StatelessWidget {
  const _DarkButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10 * _uiTextScale,
        vertical: 6 * _uiTextScale,
      ),
      decoration: BoxDecoration(
        color: FullTankColors.navy,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
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
  color: FullTankColors.inkMid,
  fontSize: 9.5,
  fontWeight: FontWeight.w800,
  letterSpacing: .25,
);
const _metaStyle = TextStyle(
  color: FullTankColors.inkSoft,
  fontSize: 9.5,
  fontWeight: FontWeight.w600,
);
const _valueStyle = TextStyle(
  color: FullTankColors.navy,
  fontSize: 19,
  height: 1,
  fontWeight: FontWeight.w800,
  letterSpacing: -.5,
);

class GlobalSearchPage extends StatelessWidget {
  const GlobalSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _withHomeUiScale(
      context,
      Scaffold(
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
                    color: FullTankColors.card,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 18,
                        color: FullTankColors.inkSoft,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Buscar "diésel"',
                        style: TextStyle(
                          color: FullTankColors.inkSoft,
                          fontSize: 12,
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
                  color: FullTankColors.blue,
                  softColor: FullTankColors.blueSoft,
                ),
                const _SearchResult(
                  icon: Icons.receipt_long_outlined,
                  eyebrow: 'PEDIDO · FT-2038',
                  title: 'Diésel B5 · 12.000 L',
                  detail: 'Entregado · Ayer',
                  color: FullTankColors.blue,
                  softColor: FullTankColors.blueSoft,
                ),
                const _SearchResult(
                  icon: Icons.person_outline,
                  eyebrow: 'CLIENTE · C002',
                  title: 'Transportes Delta',
                  detail: 'Transporte · Nuevo León · 142 pedidos',
                  color: Color(0xFF0F9B91),
                  softColor: Color(0xFFEAFBF8),
                ),
                const _SearchResult(
                  icon: Icons.person_outline,
                  eyebrow: 'CLIENTE · C001',
                  title: 'AgroNorte S.A.',
                  detail: 'Agricultura · Sonora · 84 pedidos',
                  color: Color(0xFF0F9B91),
                  softColor: Color(0xFFEAFBF8),
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
        bottomNavigationBar: const _BottomNav(active: 0),
      ),
    );
  }
}
