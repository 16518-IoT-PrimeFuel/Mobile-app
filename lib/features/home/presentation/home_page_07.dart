part of 'home_page.dart';

class _BottomNav extends FullTankBottomNav {
  const _BottomNav({required super.active});
}

class FullTankBottomNav extends StatelessWidget {
  const FullTankBottomNav({required this.active, this.onTap, super.key});

  final int active;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    const labels = ['Clientes', 'Inventario', 'Ventas', 'Reportes', 'Cuenta'];
    const icons = [
      Icons.people_outline,
      Icons.inventory_2_outlined,
      Icons.show_chart,
      Icons.description_outlined,
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
        router.go('/inventory');
      case 2:
        router.go('/reports/sales');
      case 3:
        router.go('/reports/consumption');
      case 4:
        router.go('/account');
    }
  }
}
