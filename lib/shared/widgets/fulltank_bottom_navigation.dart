import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    return Container(
      padding: const EdgeInsets.fromLTRB(11.6, 11.6, 11.6, 13.05),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          labels.length,
          (index) => Expanded(
            child: InkWell(
              onTap: () =>
                  (onTap ?? (value) => _navigate(context, value))(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icons[index],
                    size: 26.1,
                    color: index == active
                        ? const Color(0xFF1E40AF)
                        : const Color(0xFF94A3B8),
                  ),
                  const SizedBox(height: 4.35),
                  Text(
                    labels[index],
                    style: TextStyle(
                      color: index == active
                          ? const Color(0xFF1E40AF)
                          : const Color(0xFF94A3B8),
                      fontSize: 12.325,
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
