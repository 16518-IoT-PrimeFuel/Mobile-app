import '../../app/role_routing.dart';
import '../../domain/auth/auth_session.dart';
import '../../features/auth/application/auth_providers.dart';
import '../theme/fulltank_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const _dispatchesTab = 2;

/// Tabs visible to [session]: buyers do not get `Despachos` (their role guard
/// sends `/dispatches` back to `/home`). Guest and unknown sessions see all.
List<int> visibleNavTabs(AuthSession? session) {
  final buyerOnly =
      session != null &&
      !isGuestSession(session) &&
      !session.roles.contains(providerRole);
  return [
    for (var i = 0; i < 5; i++)
      if (!(buyerOnly && i == _dispatchesTab)) i,
  ];
}

class FullTankBottomNav extends StatelessWidget {
  const FullTankBottomNav({required this.active, this.onTap, super.key});

  final int? active;
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
    final scope = context
        .dependOnInheritedWidgetOfExactType<UncontrolledProviderScope>();
    final tabs = visibleNavTabs(
      scope?.container.read(authControllerProvider).session,
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(11.6, 11.6, 11.6, 13.05),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: FullTankColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          tabs.length,
          (position) =>
              Expanded(child: _tab(context, tabs[position], labels, icons)),
        ),
      ),
    );
  }

  Widget _tab(
    BuildContext context,
    int index,
    List<String> labels,
    List<IconData> icons,
  ) {
    return InkWell(
      onTap: () => (onTap ?? (value) => _navigate(context, value))(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icons[index],
            size: 26.1,
            color: index == active
                ? FullTankColors.primary
                : FullTankColors.muted,
          ),
          const SizedBox(height: 4.35),
          Text(
            labels[index],
            style: TextStyle(
              color: index == active
                  ? FullTankColors.primary
                  : FullTankColors.muted,
              fontSize: 12.325,
              fontWeight: index == active ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, int index) {
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
