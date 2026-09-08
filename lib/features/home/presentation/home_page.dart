import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/fulltank_theme.dart';
import '../../auth/application/auth_providers.dart';

enum HomeRole { requester, provider }

const _green = Color(0xFF10B981);
const _greenSoft = Color(0xFFECFDF5);
const _amber = Color(0xFFF59E0B);
const _amberSoft = Color(0xFFFFFBEB);
const _red = Color(0xFFEF4444);
const _redSoft = Color(0xFFFEF2F2);
const _purple = Color(0xFF8B5CF6);
const _purpleSoft = Color(0xFFF5F3FF);
const _uiTextScale = 1.3;

Widget _withHomeUiScale(BuildContext context, Widget child) => MediaQuery(
  data: MediaQuery.of(
    context,
  ).copyWith(textScaler: const TextScaler.linear(_uiTextScale)),
  child: child,
);

class HomePage extends ConsumerWidget {
  const HomePage({required this.role, super.key});

  final HomeRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider).session;
    return _withHomeUiScale(
      context,
      Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: Transform(
            alignment: Alignment.topCenter,
            transform: Matrix4.diagonal3Values(1, 1.02, 1),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              child: role == HomeRole.provider
                  ? _ProviderHome(onSignOut: () => _signOut(context, ref))
                  : _RequesterHome(
                      guest: session?.token == 'guest',
                      onSignOut: () => _signOut(context, ref),
                    ),
            ),
          ),
        ),
        bottomNavigationBar: const FullTankBottomNav(active: 0),
      ),
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).signOut();
    if (context.mounted) context.go('/login');
  }
}

class _RequesterHome extends StatelessWidget {
  const _RequesterHome({required this.onSignOut, required this.guest});

  final VoidCallback onSignOut;
  final bool guest;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HomeHeader(
          initials: 'PE',
          eyebrow: 'BUENOS DÍAS · DOMINGO, 6 SEP',
          name: 'PetroAndes',
          subtitle: 'Solicitante · Operaciones de flota',
          onSignOut: onSignOut,
        ),
        const SizedBox(height: 18),
        const _TankSummaryCard(),
        const SizedBox(height: 18),
        const _SectionLabel('ACCIONES RÁPIDAS'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _QuickAction(
                icon: Icons.note_add_outlined,
                label: 'Crear\npedido',
                color: FullTankColors.blue,
                softColor: FullTankColors.blueSoft,
                onTap: () => context.push('/home/quick-actions'),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: _QuickAction(
                icon: Icons.receipt_long_outlined,
                label: 'Ver\npedidos',
                color: const Color(0xFF0F9B91),
                softColor: const Color(0xFFEAFBF8),
                onTap: () => context.push('/orders/history'),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: _QuickAction(
                icon: Icons.show_chart,
                label: 'Consumo',
                color: const Color(0xFFC56B2C),
                softColor: const Color(0xFFFFF4E9),
                onTap: () => context.push('/reports/consumption'),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: _QuickAction(
                icon: Icons.headset_mic_outlined,
                label: 'Soporte',
                color: _purple,
                softColor: _purpleSoft,
                onTap: () => context.push('/support/help'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const _SectionLabel('ESTADO DEL PEDIDO'),
        const SizedBox(height: 8),
        const _OrderStatusCard(),
        if (guest) ...[
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: onSignOut,
              child: const Text('Salir de vista previa'),
            ),
          ),
        ],
      ],
    );
  }
}

class _ProviderHome extends StatelessWidget {
  const _ProviderHome({required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HomeHeader(
          initials: 'FU',
          eyebrow: 'OPERACIONES · DOMINGO, 6 SEP',
          name: 'FuelMex Logistics',
          subtitle: 'Proveedor · Centro regional',
          onSignOut: onSignOut,
        ),
        const SizedBox(height: 18),
        const _SectionLabel('RESUMEN DE OPERACIONES'),
        const SizedBox(height: 8),
        const _SummaryGrid(),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _SectionLabel('ACCIONES PENDIENTES'),
            _TinyPill(label: '2 URGENTES', color: _red, softColor: _redSoft),
          ],
        ),
        const SizedBox(height: 8),
        _ActionRequiredCard(
          color: _red,
          priority: 'ALTA',
          reference: '#FT-2098',
          title: 'Aprobar pedido — AgroNorte',
          detail: '12.000 L Diésel B5 · hace 8 min',
          button: 'Aprobar',
          onTap: () => context.push('/provider/orders/FT-2098'),
        ),
        const SizedBox(height: 8),
        _ActionRequiredCard(
          color: _amber,
          priority: 'HIGH',
          reference: '#FT-2091',
          title: 'Asignar vehículo — Transportes Delta',
          detail: 'Bahía 2 · programado hoy 3:00 PM',
          button: 'Asignar',
          onTap: () => context.push('/dispatches/assign'),
        ),
        const SizedBox(height: 8),
        _ActionRequiredCard(
          color: _amber,
          priority: 'MEDIA',
          reference: 'INV-8112',
          title: 'Revisar pago — Cementos B',
          detail: '\$248.500 MXN · pendiente de confirmación',
          button: 'Revisar',
          onTap: () => context.push('/orders/FT-2098/payment'),
        ),
      ],
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.initials,
    required this.eyebrow,
    required this.name,
    required this.subtitle,
    required this.onSignOut,
  });

  final String initials;
  final String eyebrow;
  final String name;
  final String subtitle;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 47,
          height: 47,
          decoration: BoxDecoration(
            color: FullTankColors.navy,
            borderRadius: BorderRadius.circular(13),
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: const TextStyle(
                  color: FullTankColors.inkSoft,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .25,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                name,
                style: const TextStyle(
                  color: FullTankColors.navy,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.2,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: FullTankColors.inkMid,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          tooltip: 'Notificaciones',
          onSelected: (value) {
            if (value == 'activity') {
              context.push('/home/activity');
            } else if (value == 'notifications') {
              context.push('/notifications');
            } else {
              onSignOut();
            }
          },
          padding: EdgeInsets.zero,
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'notifications',
              child: Text('Notificaciones'),
            ),
            PopupMenuItem(value: 'activity', child: Text('Actividad')),
            PopupMenuItem(value: 'logout', child: Text('Cerrar sesión')),
          ],
          icon: Container(
            width: 47,
            height: 47,
            decoration: BoxDecoration(
              color: FullTankColors.card,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications_none_outlined, size: 23),
                Positioned(
                  right: 9,
                  top: 9,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: _red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

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

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.trend,
    required this.color,
    required this.softColor,
    this.unit,
  });

  final IconData icon;
  final String label;
  final String value;
  final String trend;
  final Color color;
  final Color softColor;
  final String? unit;

  @override
  Widget build(BuildContext context) => _Card(
    padding: const EdgeInsets.all(11),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _IconTile(icon: icon, color: color, softColor: softColor, size: 27),
            Text(
              '↑ $trend',
              style: const TextStyle(
                color: _green,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(label, style: _labelStyle),
        const SizedBox(height: 1),
        Text.rich(
          TextSpan(
            text: value,
            style: _valueStyle,
            children: [
              if (unit != null)
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(
                    color: FullTankColors.inkSoft,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ActionRequiredCard extends StatelessWidget {
  const _ActionRequiredCard({
    required this.color,
    required this.priority,
    required this.reference,
    required this.title,
    required this.detail,
    required this.button,
    this.onTap,
  });

  final Color color;
  final String priority;
  final String reference;
  final String title;
  final String detail;
  final String button;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(11, 11, 9, 11),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        left: BorderSide(color: color, width: 3),
        bottom: const BorderSide(color: FullTankColors.line),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IconTile(
          icon: Icons.check,
          color: color,
          softColor: color == _red ? _redSoft : _amberSoft,
          size: 31,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _TinyPill(
                    label: priority,
                    color: color,
                    softColor: color == _red ? _redSoft : _amberSoft,
                  ),
                  const SizedBox(width: 5),
                  Text(reference, style: _metaStyle),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                title,
                style: const TextStyle(
                  color: FullTankColors.navy,
                  fontSize: 11.5,
                  height: 1.12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: const TextStyle(
                  color: FullTankColors.inkMid,
                  fontSize: 9,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Padding(
          padding: const EdgeInsets.only(top: 14),
          child: _DarkButton(label: button, onTap: onTap ?? () {}),
        ),
      ],
    ),
  );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.softColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color softColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12 * _uiTextScale),
    child: Container(
      height: 70 * _uiTextScale,
      padding: EdgeInsets.symmetric(
        horizontal: 3 * _uiTextScale,
        vertical: 8 * _uiTextScale,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF0F2F5)),
        borderRadius: BorderRadius.circular(12 * _uiTextScale),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D1A202C),
            blurRadius: 10 * _uiTextScale,
            offset: Offset(0, 4 * _uiTextScale),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _IconTile(icon: icon, color: color, softColor: softColor, size: 27),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              color: FullTankColors.navyMid,
              fontSize: 8.5,
              height: 1.05,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}

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

class QuickActionsPage extends StatelessWidget {
  const QuickActionsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        const HomePage(role: HomeRole.requester),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: const ColoredBox(color: Color(0x660B1220)),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _QuickActionsSheet(onClose: () => context.pop()),
        ),
      ],
    ),
  );
}

class _QuickActionsSheet extends StatelessWidget {
  const _QuickActionsSheet({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => _withHomeUiScale(
    context,
    Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 3,
            decoration: BoxDecoration(
              color: FullTankColors.line,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Acciones rápidas',
                      style: TextStyle(
                        color: FullTankColors.navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text('Inicia operaciones desde aquí', style: _metaStyle),
                  ],
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close, size: 17),
                style: IconButton.styleFrom(
                  backgroundColor: FullTankColors.card,
                  fixedSize: const Size(28, 28),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _GradientAction(
            label: 'Crear pedido',
            icon: Icons.note_add_outlined,
            onTap: () => context.push('/orders/new'),
          ),
          const SizedBox(height: 7),
          const _SheetAction(
            icon: Icons.receipt_long_outlined,
            title: 'Ver pedidos',
            detail: '12 activos · 3 pendientes',
            color: Color(0xFF0F9B91),
            softColor: Color(0xFFEAFBF8),
          ),
          const SizedBox(height: 7),
          const _SheetAction(
            icon: Icons.description_outlined,
            title: 'Reportes',
            detail: 'Ventas · consumo · exportar',
            color: FullTankColors.blue,
            softColor: FullTankColors.blueSoft,
          ),
          const SizedBox(height: 7),
          const _SheetAction(
            icon: Icons.headset_mic_outlined,
            title: 'Soporte',
            detail: '24/7 · respuesta en 4 min',
            color: _purple,
            softColor: _purpleSoft,
          ),
        ],
      ),
    ),
  );
}

class ActivityCenterPage extends StatelessWidget {
  const ActivityCenterPage({super.key});

  @override
  Widget build(BuildContext context) => _withHomeUiScale(
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
                title: 'Actividad',
                subtitle: 'Cambios, alertas y eventos',
                trailing: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.tune, size: 17),
                ),
              ),
              const SizedBox(height: 12),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(label: 'Todos 7', selected: true),
                    SizedBox(width: 6),
                    _FilterChip(label: 'Pedidos 2'),
                    SizedBox(width: 6),
                    _FilterChip(label: 'IoT 2'),
                    SizedBox(width: 6),
                    _FilterChip(label: 'Alertas 1'),
                    SizedBox(width: 6),
                    _FilterChip(label: 'Otros'),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const _ActivityGroup(
                label: 'HOY · 6 SEP',
                items: [
                  _ActivityItem(
                    icon: Icons.warning_amber_rounded,
                    title: 'Nivel crítico · A-102',
                    detail:
                        'El combustible bajó a 12% · se recomienda reordenar',
                    time: 'hace 3 min',
                    color: _red,
                    softColor: _redSoft,
                  ),
                  _ActivityItem(
                    icon: Icons.local_shipping_outlined,
                    title: 'Combustible despachado · #FT-2041',
                    detail: '8.000 L Diésel B5 · camión TX-4402',
                    time: 'hace 32 min',
                    color: _amber,
                    softColor: _amberSoft,
                  ),
                  _ActivityItem(
                    icon: Icons.receipt_long_outlined,
                    title: 'Pedido aprobado · #FT-2041',
                    detail: 'Aprobado por FuelMex Logistics',
                    time: 'hace 2 h',
                    color: FullTankColors.blue,
                    softColor: FullTankColors.blueSoft,
                  ),
                  _ActivityItem(
                    icon: Icons.sensors_outlined,
                    title: 'Sensor SN-4492 conectado',
                    detail: 'Lectura reanudada tras 4 min sin conexión',
                    time: 'hace 3 h',
                    color: _purple,
                    softColor: _purpleSoft,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const _ActivityGroup(
                label: 'A PRINCIPIOS DE SEMANA',
                items: [
                  _ActivityItem(
                    icon: Icons.flag_outlined,
                    title: 'Entrega completada · #FT-2038',
                    detail: '12.000 L · confirmada a las 09:14',
                    time: 'Ayer',
                    color: _green,
                    softColor: _greenSoft,
                  ),
                  _ActivityItem(
                    icon: Icons.attach_money,
                    title: 'Factura #INV-8102 pagada',
                    detail: '\$192.400 MXN · FuelMex Logistics',
                    time: 'Hace 2 días',
                    color: Color(0xFF0F9B91),
                    softColor: Color(0xFFEAFBF8),
                  ),
                  _ActivityItem(
                    icon: Icons.show_chart,
                    title: 'Pico de temperatura · A-102',
                    detail: 'Alcanzó 41°C durante 12 min · normalizado',
                    time: 'Hace 3 días',
                    color: _purple,
                    softColor: _purpleSoft,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _BottomNav(active: 0),
    ),
  );
}

class EmptyHomePage extends StatelessWidget {
  const EmptyHomePage({required this.role, super.key});

  final HomeRole role;

  @override
  Widget build(BuildContext context) {
    final provider = role == HomeRole.provider;
    return _withHomeUiScale(
      context,
      Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HomeHeader(
                  initials: provider ? 'FU' : 'PE',
                  eyebrow: provider
                      ? 'OPERACIONES · DOMINGO, 6 SEP'
                      : 'BUENOS DÍAS · DOMINGO, 6 SEP',
                  name: provider ? 'FuelMex Logistics' : 'PetroAndes',
                  subtitle: provider
                      ? 'Proveedor · Centro regional'
                      : 'Solicitante · Operaciones de flota',
                  onSignOut: () => context.go('/login'),
                ),
                const SizedBox(height: 20),
                _Card(
                  child: Column(
                    children: [
                      _IconTile(
                        icon: provider
                            ? Icons.link_outlined
                            : Icons.inbox_outlined,
                        color: FullTankColors.inkSoft,
                        softColor: const Color(0xFFF5F7FA),
                        size: 42,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        provider
                            ? 'No hay operaciones hoy'
                            : 'No hay pedidos activos',
                        style: const TextStyle(
                          color: FullTankColors.navy,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        provider
                            ? 'Cuando tus clientes hagan pedidos, las tareas y entregas aparecerán aquí.'
                            : 'Cuando crees tu primer pedido o el sensor active una alerta, aparecerá aquí.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: FullTankColors.inkMid,
                          fontSize: 10.5,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _GradientAction(
                        label: provider ? 'Invitar cliente' : 'Crear pedido',
                        icon: provider
                            ? Icons.person_add_alt_1_outlined
                            : Icons.note_add_outlined,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                if (!provider) ...[
                  const SizedBox(height: 18),
                  const _SectionLabel('LISTA DE CONFIGURACIÓN'),
                  const SizedBox(height: 8),
                  const _SetupRow(
                    icon: Icons.business_outlined,
                    title: 'Agrega tu primer tanque',
                    detail: 'Conecta un sensor IoT',
                    done: false,
                  ),
                  const _SetupRow(
                    icon: Icons.person_add_alt_1_outlined,
                    title: 'Invita a tu equipo',
                    detail: 'Colabora en las operaciones',
                    done: false,
                  ),
                ],
              ],
            ),
          ),
        ),
        bottomNavigationBar: const _BottomNav(active: 0),
      ),
    );
  }
}

class _SubpageHeader extends StatelessWidget {
  const _SubpageHeader({
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back, size: 18),
        style: IconButton.styleFrom(
          backgroundColor: FullTankColors.card,
          fixedSize: const Size(36, 36),
          padding: EdgeInsets.zero,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: FullTankColors.navy,
                fontSize: 21,
                fontWeight: FontWeight.w800,
                letterSpacing: -.5,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: FullTankColors.inkMid,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
      ),
      if (trailing != null) trailing!,
    ],
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: selected ? FullTankColors.navy : FullTankColors.card,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: selected ? Colors.white : FullTankColors.navyMid,
        fontSize: 9.5,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _SearchResult extends StatelessWidget {
  const _SearchResult({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.detail,
    required this.color,
    required this.softColor,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final String detail;
  final Color color;
  final Color softColor;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 7),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: FullTankColors.line),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        _IconTile(icon: icon, color: color, softColor: softColor, size: 28),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: TextStyle(
                  color: color,
                  fontSize: 7.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  color: FullTankColors.navy,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                detail,
                style: const TextStyle(
                  color: FullTankColors.inkMid,
                  fontSize: 8.5,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.chevron_right,
          size: 16,
          color: FullTankColors.inkSoft,
        ),
      ],
    ),
  );
}

class _GradientAction extends StatelessWidget {
  const _GradientAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 39,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [FullTankColors.ctaFrom, FullTankColors.ctaTo],
        ),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x44FFA500),
            blurRadius: 14,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    ),
  );
}

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.title,
    required this.detail,
    required this.color,
    required this.softColor,
  });

  final IconData icon;
  final String title;
  final String detail;
  final Color color;
  final Color softColor;

  @override
  Widget build(BuildContext context) => Container(
    height: 42,
    padding: const EdgeInsets.symmetric(horizontal: 9),
    decoration: BoxDecoration(
      color: const Color(0xFFF8F9FB),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      children: [
        _IconTile(icon: icon, color: color, softColor: softColor, size: 27),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: FullTankColors.navy,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(detail, style: _metaStyle),
            ],
          ),
        ),
        const Icon(
          Icons.chevron_right,
          size: 16,
          color: FullTankColors.inkSoft,
        ),
      ],
    ),
  );
}

class _ActivityGroup extends StatelessWidget {
  const _ActivityGroup({required this.label, required this.items});

  final String label;
  final List<_ActivityItem> items;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: _labelStyle),
      const SizedBox(height: 8),
      ...items,
    ],
  );
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.detail,
    required this.time,
    required this.color,
    required this.softColor,
  });

  final IconData icon;
  final String title;
  final String detail;
  final String time;
  final Color color;
  final Color softColor;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: FullTankColors.line),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IconTile(icon: icon, color: color, softColor: softColor, size: 28),
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
              const SizedBox(height: 2),
              Text(
                detail,
                style: const TextStyle(
                  color: FullTankColors.inkMid,
                  fontSize: 8.5,
                ),
              ),
            ],
          ),
        ),
        Text(time, style: _metaStyle),
      ],
    ),
  );
}

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
