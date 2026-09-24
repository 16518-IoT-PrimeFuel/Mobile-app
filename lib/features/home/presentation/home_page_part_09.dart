part of 'home_page.dart';

class _SetupRow extends StatelessWidget {
  const _SetupRow({
    required this.icon,
    required this.title,
    required this.detail,
    required this.done,
  });

  final IconData icon;
  final String title;
  final String detail;
  final bool done;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 7),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: FullTankColors.card,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        _IconTile(
          icon: icon,
          color: FullTankColors.blue,
          softColor: Colors.white,
          size: 30,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: FullTankColors.navy,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(detail, style: _metaStyle),
            ],
          ),
        ),
        Icon(
          done ? Icons.check_circle : Icons.chevron_right,
          size: 17,
          color: done ? _green : FullTankColors.inkSoft,
        ),
      ],
    ),
  );
}

class _BottomNav extends FullTankBottomNav {
  const _BottomNav({required super.active});
}

class FullTankBottomNav extends StatelessWidget {
  const FullTankBottomNav({required this.active, this.onTap, super.key});

  final int active;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    const labels = ['Inicio', 'Pedidos', 'Despachos', 'Reportes', 'Cuenta'];
    const icons = [
      Icons.home_outlined,
      Icons.receipt_long_outlined,
      Icons.local_shipping_outlined,
      Icons.bar_chart_outlined,
      Icons.person_outline,
    ];
    return Container(
      padding: EdgeInsets.fromLTRB(
        8 * _uiTextScale,
        8 * _uiTextScale,
        8 * _uiTextScale,
        9 * _uiTextScale,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: FullTankColors.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          labels.length,
          (index) => Expanded(
            child: InkWell(
              onTap: () =>
                  (onTap ?? (value) => _navigateFromBottomBar(context, value))(
                    index,
                  ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icons[index],
                    size: 18 * _uiTextScale,
                    color: index == active
                        ? FullTankColors.blue
                        : FullTankColors.inkSoft,
                  ),
                  SizedBox(height: 3 * _uiTextScale),
                  Text(
                    labels[index],
                    style: TextStyle(
                      color: index == active
                          ? FullTankColors.blue
                          : FullTankColors.inkSoft,
                      fontSize: 8.5,
                      fontWeight: index == active
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateFromBottomBar(BuildContext context, int index) {
    final router = GoRouter.maybeOf(context);
    if (router == null) return;
    switch (index) {
      case 0:
        router.go('/home');
      case 1:
        router.go('/orders');
      case 2:
        router.go('/dispatches');
      case 3:
        router.go('/reports/sales');
      case 4:
        router.go('/account');
    }
  }
}
