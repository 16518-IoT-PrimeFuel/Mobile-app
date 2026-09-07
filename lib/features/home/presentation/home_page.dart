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

class HomePage extends ConsumerWidget {
  const HomePage({required this.role, super.key});

  final HomeRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider).session;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: role == HomeRole.provider
              ? _ProviderHome(onSignOut: () => _signOut(context, ref))
              : _RequesterHome(
                  guest: session?.token == 'guest',
                  onSignOut: () => _signOut(context, ref),
                ),
        ),
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
          eyebrow: 'GOOD MORNING · SUNDAY, SEP 6',
          name: 'PetroAndes',
          subtitle: 'Requester · Fleet ops',
          onSignOut: onSignOut,
        ),
        const SizedBox(height: 18),
        const _TankSummaryCard(),
        const SizedBox(height: 18),
        const _SectionLabel('QUICK ACTIONS'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _QuickAction(
                icon: Icons.note_add_outlined,
                label: 'Create\norder',
                color: FullTankColors.blue,
                softColor: FullTankColors.blueSoft,
                onTap: () => context.push('/home/quick-actions'),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: _QuickAction(
                icon: Icons.receipt_long_outlined,
                label: 'View\norders',
                color: const Color(0xFF0F9B91),
                softColor: const Color(0xFFEAFBF8),
                onTap: () => context.push('/home/search'),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: _QuickAction(
                icon: Icons.show_chart,
                label: 'Consumption',
                color: const Color(0xFFC56B2C),
                softColor: const Color(0xFFFFF4E9),
                onTap: () => context.push('/home/activity'),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: _QuickAction(
                icon: Icons.headset_mic_outlined,
                label: 'Support',
                color: _purple,
                softColor: _purpleSoft,
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Support is available 24/7.')),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const _SectionLabel('ORDER STATUS'),
        const SizedBox(height: 8),
        const _OrderStatusCard(),
        if (guest) ...[
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: onSignOut,
              child: const Text('Exit guest preview'),
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
          eyebrow: 'OPERATIONS · SUNDAY, SEP 6',
          name: 'FuelMex Logistics',
          subtitle: 'Supplier · Regional hub',
          onSignOut: onSignOut,
        ),
        const SizedBox(height: 18),
        const _SectionLabel('OPERATION SUMMARY'),
        const SizedBox(height: 8),
        const _SummaryGrid(),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _SectionLabel('ACTION REQUIRED'),
            _TinyPill(label: '2 URGENT', color: _red, softColor: _redSoft),
          ],
        ),
        const SizedBox(height: 8),
        _ActionRequiredCard(
          color: _red,
          priority: 'HIGH',
          reference: '#FT-2098',
          title: 'Approve order — AgroNorte',
          detail: '12,000 L Diesel B5 · placed 8 min ago',
          button: 'Approve',
        ),
        const SizedBox(height: 8),
        _ActionRequiredCard(
          color: _amber,
          priority: 'HIGH',
          reference: '#FT-2091',
          title: 'Assign vehicle — Transportes Delta',
          detail: 'Loading bay 2 · scheduled today 3:00 PM',
          button: 'Assign',
        ),
        const SizedBox(height: 8),
        _ActionRequiredCard(
          color: _amber,
          priority: 'MED',
          reference: 'INV-8112',
          title: 'Review payment — Cementos B',
          detail: '\$248,500 MXN · pending confirmation',
          button: 'Review',
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
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: FullTankColors.navy,
            borderRadius: BorderRadius.circular(10),
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
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(eyebrow, style: const TextStyle(color: FullTankColors.inkSoft, fontSize: 8.5, fontWeight: FontWeight.w700, letterSpacing: .25)),
              const SizedBox(height: 1),
              Text(name, style: const TextStyle(color: FullTankColors.navy, fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: -.2)),
              Text(subtitle, style: const TextStyle(color: FullTankColors.inkMid, fontSize: 9.5, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        PopupMenuButton<String>(
          tooltip: 'Notifications',
          onSelected: (value) {
            if (value == 'activity') {
              context.push('/home/activity');
            } else {
              onSignOut();
            }
          },
          padding: EdgeInsets.zero,
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'activity', child: Text('Activity')),
            PopupMenuItem(value: 'logout', child: Text('Log out')),
          ],
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: FullTankColors.card, borderRadius: BorderRadius.circular(10)),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications_none_outlined, size: 18),
                Positioned(right: 7, top: 7, child: Container(width: 7, height: 7, decoration: BoxDecoration(color: _red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)))),
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
                    Text('MAIN TANK · A-102 DIESEL', style: _labelStyle),
                    SizedBox(height: 3),
                    Row(children: [Icon(Icons.location_on_outlined, size: 12, color: FullTankColors.inkMid), SizedBox(width: 3), Text('North Yard · Sector 4', style: _metaStyle)]),
                  ],
                ),
              ),
              _TinyPill(label: 'LIVE', color: _green, softColor: _greenSoft, dot: true),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FUEL LEVEL', style: _labelStyle),
                    SizedBox(height: 1),
                    Text.rich(TextSpan(text: '68', style: TextStyle(color: FullTankColors.navy, fontSize: 42, height: 1, fontWeight: FontWeight.w800, letterSpacing: -1.8), children: [TextSpan(text: '%', style: TextStyle(fontSize: 19, letterSpacing: -.5))])),
                    SizedBox(height: 3),
                    Text('10,200 / 15,000 L', style: _metaStyle),
                  ],
                ),
              ),
              const _VerticalLevelBar(value: .68),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: FullTankColors.line),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_TinyPill(label: 'Normal', color: _green, softColor: _greenSoft, dot: true), const Row(children: [Icon(Icons.sync, size: 12, color: FullTankColors.inkSoft), SizedBox(width: 4), Text('Updated 5 min ago', style: _metaStyle)])]),
        ],
      ),
    );
  }
}

class _VerticalLevelBar extends StatelessWidget {
  const _VerticalLevelBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) => Container(width: 40, height: 80, padding: const EdgeInsets.all(2), decoration: BoxDecoration(color: const Color(0xFFF3F7F8), borderRadius: BorderRadius.circular(10)), child: Align(alignment: Alignment.bottomCenter, child: FractionallySizedBox(heightFactor: value, widthFactor: 1, child: DecoratedBox(decoration: BoxDecoration(color: const Color(0xFF27BD91), borderRadius: BorderRadius.circular(8))))));
}

class _OrderStatusCard extends StatelessWidget {
  const _OrderStatusCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('ACTIVE ORDER', style: _labelStyle), SizedBox(height: 2), Text('#FT-2041', style: _valueStyle), Text('8,000 L · Diesel B5', style: _metaStyle)]), TextButton(onPressed: () => context.push('/home/activity'), style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 32), tapTargetSize: MaterialTapTargetSize.shrinkWrap), child: const Row(children: [Text('View details', style: TextStyle(color: FullTankColors.blue, fontSize: 9, fontWeight: FontWeight.w700)), SizedBox(width: 2), Icon(Icons.chevron_right, size: 16, color: FullTankColors.blue)]))]),
          const SizedBox(height: 14),
          const _OrderProgress(),
          const SizedBox(height: 13),
          const Divider(height: 1, color: FullTankColors.line),
          const SizedBox(height: 10),
          const Row(children: [Icon(Icons.schedule, size: 13, color: FullTankColors.inkMid), SizedBox(width: 4), Text('ETA Today · 4:30 PM', style: TextStyle(color: FullTankColors.navy, fontSize: 10, fontWeight: FontWeight.w700)), Spacer(), Text('from FuelMex Logistics', style: _metaStyle)]),
        ],
      ),
    );
  }
}

class _OrderProgress extends StatelessWidget {
  const _OrderProgress();

  @override
  Widget build(BuildContext context) => Row(children: [_ProgressNode(label: 'APPROVED', icon: Icons.check, color: _green, active: true), const Expanded(child: Divider(color: _green, thickness: 1.5)), _ProgressNode(label: 'DISPATCHED', icon: Icons.local_shipping_outlined, color: _green, active: true), const Expanded(child: Divider(color: FullTankColors.line, thickness: 1.5)), _ProgressNode(label: 'DELIVERED', icon: Icons.flag_outlined, color: FullTankColors.inkSoft, active: false)]);
}

class _ProgressNode extends StatelessWidget {
  const _ProgressNode({required this.label, required this.icon, required this.color, required this.active});

  final String label;
  final IconData icon;
  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) => Column(children: [Container(width: 23, height: 23, decoration: BoxDecoration(color: active ? color : const Color(0xFFF4F6F8), shape: BoxShape.circle), alignment: Alignment.center, child: Icon(icon, size: 13, color: active ? Colors.white : color)), const SizedBox(height: 4), Text(label, style: TextStyle(color: active ? FullTankColors.inkMid : FullTankColors.inkSoft, fontSize: 8.5, fontWeight: FontWeight.w700))]);
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid();

  @override
  Widget build(BuildContext context) => GridView.count(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1.65, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), children: const [_SummaryMetric(icon: Icons.description_outlined, label: 'PENDING ORDERS', value: '12', trend: '+8%', color: FullTankColors.blue, softColor: FullTankColors.blueSoft), _SummaryMetric(icon: Icons.local_shipping_outlined, label: 'ACTIVE DELIVERIES', value: '7', trend: '+2%', color: _amber, softColor: _amberSoft), _SummaryMetric(icon: Icons.business_center_outlined, label: 'CUSTOMERS', value: '48', trend: '+4%', color: Color(0xFF0F9B91), softColor: Color(0xFFEAFBF8)), _SummaryMetric(icon: Icons.opacity_outlined, label: 'FUEL SOLD', value: '74', unit: 'kL', trend: '+15%', color: Color(0xFFE06B2D), softColor: Color(0xFFFFF1E8))]);
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.icon, required this.label, required this.value, required this.trend, required this.color, required this.softColor, this.unit});

  final IconData icon;
  final String label;
  final String value;
  final String trend;
  final Color color;
  final Color softColor;
  final String? unit;

  @override
  Widget build(BuildContext context) => _Card(padding: const EdgeInsets.all(11), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_IconTile(icon: icon, color: color, softColor: softColor, size: 27), Text('↑ $trend', style: const TextStyle(color: _green, fontSize: 9, fontWeight: FontWeight.w800))]), const Spacer(), Text(label, style: _labelStyle), const SizedBox(height: 1), Text.rich(TextSpan(text: value, style: _valueStyle, children: [if (unit != null) TextSpan(text: ' $unit', style: const TextStyle(color: FullTankColors.inkSoft, fontSize: 10, fontWeight: FontWeight.w600))]))]));
}

class _ActionRequiredCard extends StatelessWidget {
  const _ActionRequiredCard({required this.color, required this.priority, required this.reference, required this.title, required this.detail, required this.button});

  final Color color;
  final String priority;
  final String reference;
  final String title;
  final String detail;
  final String button;

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.fromLTRB(11, 11, 9, 11), decoration: BoxDecoration(color: Colors.white, border: Border(left: BorderSide(color: color, width: 3), bottom: const BorderSide(color: FullTankColors.line))), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [_IconTile(icon: Icons.check, color: color, softColor: color == _red ? _redSoft : _amberSoft, size: 31), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [_TinyPill(label: priority, color: color, softColor: color == _red ? _redSoft : _amberSoft), const SizedBox(width: 5), Text(reference, style: _metaStyle)]), const SizedBox(height: 3), Text(title, style: const TextStyle(color: FullTankColors.navy, fontSize: 11.5, height: 1.12, fontWeight: FontWeight.w800)), const SizedBox(height: 2), Text(detail, style: const TextStyle(color: FullTankColors.inkMid, fontSize: 9, height: 1.2))])), const SizedBox(width: 6), Padding(padding: const EdgeInsets.only(top: 14), child: _DarkButton(label: button, onTap: () {}))]));
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.color, required this.softColor, required this.onTap});

  final IconData icon;
  final String label;
  final Color color;
  final Color softColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12), child: Container(height: 70, padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFF0F2F5)), borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Color(0x0D1A202C), blurRadius: 10, offset: Offset(0, 4))]), child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_IconTile(icon: icon, color: color, softColor: softColor, size: 27), Text(label, textAlign: TextAlign.center, maxLines: 2, style: const TextStyle(color: FullTankColors.navyMid, fontSize: 8.5, height: 1.05, fontWeight: FontWeight.w700))])));
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding = const EdgeInsets.all(14)});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(width: double.infinity, padding: padding, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFF0F2F5)), boxShadow: const [BoxShadow(color: Color(0x0D1A202C), blurRadius: 18, offset: Offset(0, 7))]), child: child);
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon, required this.color, required this.softColor, this.size = 32});

  final IconData icon;
  final Color color;
  final Color softColor;
  final double size;

  @override
  Widget build(BuildContext context) => Container(width: size, height: size, decoration: BoxDecoration(color: softColor, borderRadius: BorderRadius.circular(9)), alignment: Alignment.center, child: Icon(icon, size: size * .52, color: color));
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({required this.label, required this.color, required this.softColor, this.dot = false});

  final String label;
  final Color color;
  final Color softColor;
  final bool dot;

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3), decoration: BoxDecoration(color: softColor, borderRadius: BorderRadius.circular(999)), child: Row(mainAxisSize: MainAxisSize.min, children: [if (dot) ...[Container(width: 5, height: 5, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 4)], Text(label, style: TextStyle(color: color, fontSize: 8.5, fontWeight: FontWeight.w800, letterSpacing: .2))]));
}

class _DarkButton extends StatelessWidget {
  const _DarkButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: FullTankColors.navy, borderRadius: BorderRadius.circular(999)), child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800))));
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: _labelStyle);
}

const _labelStyle = TextStyle(color: FullTankColors.inkMid, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: .25);
const _metaStyle = TextStyle(color: FullTankColors.inkSoft, fontSize: 9.5, fontWeight: FontWeight.w600);
const _valueStyle = TextStyle(color: FullTankColors.navy, fontSize: 19, height: 1, fontWeight: FontWeight.w800, letterSpacing: -.5);

class GlobalSearchPage extends StatelessWidget {
  const GlobalSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _SubpageHeader(title: 'Global search', subtitle: 'Find tanks, orders, and customers'),
            const SizedBox(height: 14),
            Container(height: 44, padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: FullTankColors.card, borderRadius: BorderRadius.circular(12)), child: const Row(children: [Icon(Icons.search, size: 18, color: FullTankColors.inkSoft), SizedBox(width: 8), Text('Search for "diesel"', style: TextStyle(color: FullTankColors.inkSoft, fontSize: 12))])),
            const SizedBox(height: 12),
            const Wrap(spacing: 6, children: [_FilterChip(label: 'All', selected: true), _FilterChip(label: 'Orders 2'), _FilterChip(label: 'Customers 2'), _FilterChip(label: 'Products')]),
            const SizedBox(height: 18),
            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('6 RESULTS FOR "DIESEL"', style: _labelStyle), Text('Sorted by relevance', style: _metaStyle)]),
            const SizedBox(height: 8),
            const _SearchResult(icon: Icons.receipt_long_outlined, eyebrow: 'ORDER · FT-2041', title: 'Diesel B5 · 8,000 L', detail: 'Dispatched · Today · 4:30 PM', color: FullTankColors.blue, softColor: FullTankColors.blueSoft),
            const _SearchResult(icon: Icons.receipt_long_outlined, eyebrow: 'ORDER · FT-2038', title: 'Diesel B5 · 12,000 L', detail: 'Delivered · Yesterday', color: FullTankColors.blue, softColor: FullTankColors.blueSoft),
            const _SearchResult(icon: Icons.person_outline, eyebrow: 'CUSTOMER · C002', title: 'Transportes Delta', detail: 'Transport · Nuevo León · 142 orders', color: Color(0xFF0F9B91), softColor: Color(0xFFEAFBF8)),
            const _SearchResult(icon: Icons.person_outline, eyebrow: 'CUSTOMER · C001', title: 'AgroNorte S.A.', detail: 'Agriculture · Sonora · 84 orders', color: Color(0xFF0F9B91), softColor: Color(0xFFEAFBF8)),
            const _SearchResult(icon: Icons.opacity_outlined, eyebrow: 'PRODUCT · P01', title: 'Diesel B5', detail: '12,410 L · \$24.10/L · Available', color: _amber, softColor: _amberSoft),
            const _SearchResult(icon: Icons.inventory_2_outlined, eyebrow: 'TANK · A-102', title: 'Diesel Tank A-102', detail: 'North Yard · Sector 4 · 68%', color: _purple, softColor: _purpleSoft),
          ]),
        ),
      ),
      bottomNavigationBar: const _BottomNav(active: 0),
    );
  }
}

class QuickActionsPage extends StatelessWidget {
  const QuickActionsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(body: Stack(fit: StackFit.expand, children: [const HomePage(role: HomeRole.requester), BackdropFilter(filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), child: const ColoredBox(color: Color(0x660B1220))), Align(alignment: Alignment.bottomCenter, child: _QuickActionsSheet(onClose: () => context.pop()))]));
}

class _QuickActionsSheet extends StatelessWidget {
  const _QuickActionsSheet({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.fromLTRB(16, 10, 16, 24), decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(22))), child: Column(mainAxisSize: MainAxisSize.min, children: [Container(width: 28, height: 3, decoration: BoxDecoration(color: FullTankColors.line, borderRadius: BorderRadius.circular(99))), const SizedBox(height: 14), Row(children: [const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Quick actions', style: TextStyle(color: FullTankColors.navy, fontSize: 14, fontWeight: FontWeight.w800)), SizedBox(height: 2), Text('Start operations from here', style: _metaStyle)])), IconButton(onPressed: onClose, icon: const Icon(Icons.close, size: 17), style: IconButton.styleFrom(backgroundColor: FullTankColors.card, fixedSize: const Size(28, 28), padding: EdgeInsets.zero))]), const SizedBox(height: 12), _GradientAction(label: 'Create order', icon: Icons.note_add_outlined, onTap: onClose), const SizedBox(height: 7), const _SheetAction(icon: Icons.receipt_long_outlined, title: 'View orders', detail: '12 active · 3 pending', color: Color(0xFF0F9B91), softColor: Color(0xFFEAFBF8)), const SizedBox(height: 7), const _SheetAction(icon: Icons.description_outlined, title: 'Reports', detail: 'Sales · consumption · export', color: FullTankColors.blue, softColor: FullTankColors.blueSoft), const SizedBox(height: 7), const _SheetAction(icon: Icons.headset_mic_outlined, title: 'Support', detail: '24/7 · response in 4 min', color: _purple, softColor: _purpleSoft)]));
}

class ActivityCenterPage extends StatelessWidget {
  const ActivityCenterPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: Colors.white, body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(20, 12, 20, 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const _SubpageHeader(title: 'Activity', subtitle: 'State changes, alerts and events', trailing: IconButton(onPressed: null, icon: Icon(Icons.tune, size: 17))), const SizedBox(height: 12), const SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [_FilterChip(label: 'All 7', selected: true), SizedBox(width: 6), _FilterChip(label: 'Orders 2'), SizedBox(width: 6), _FilterChip(label: 'IoT 2'), SizedBox(width: 6), _FilterChip(label: 'Alerts 1'), SizedBox(width: 6), _FilterChip(label: 'Other')])), const SizedBox(height: 18), const _ActivityGroup(label: 'TODAY · SEP 6', items: [_ActivityItem(icon: Icons.warning_amber_rounded, title: 'Critical level · A-102', detail: 'Fuel dropped to 12% · reorder recommended', time: '3 min ago', color: _red, softColor: _redSoft), _ActivityItem(icon: Icons.local_shipping_outlined, title: 'Fuel dispatched · #FT-2041', detail: '8,000 L Diesel B5 · truck TX-4402', time: '32 min ago', color: _amber, softColor: _amberSoft), _ActivityItem(icon: Icons.receipt_long_outlined, title: 'Order approved · #FT-2041', detail: 'Approved by FuelMex Logistics', time: '2 h ago', color: FullTankColors.blue, softColor: FullTankColors.blueSoft), _ActivityItem(icon: Icons.sensors_outlined, title: 'Sensor SN-4492 online', detail: 'Reading resumed after 4 min offline', time: '3 h ago', color: _purple, softColor: _purpleSoft)]), const SizedBox(height: 18), const _ActivityGroup(label: 'EARLIER THIS WEEK', items: [_ActivityItem(icon: Icons.flag_outlined, title: 'Delivery completed · #FT-2038', detail: '12,000 L · confirmed at 09:14', time: 'Yesterday', color: _green, softColor: _greenSoft), _ActivityItem(icon: Icons.attach_money, title: 'Invoice #INV-8102 paid', detail: '\$192,400 MXN · FuelMex Logistics', time: '2 days ago', color: Color(0xFF0F9B91), softColor: Color(0xFFEAFBF8)), _ActivityItem(icon: Icons.show_chart, title: 'Temperature spike · A-102', detail: 'Peaked 41°C for 12 min · normalized', time: '3 days ago', color: _purple, softColor: _purpleSoft)])]))), bottomNavigationBar: const _BottomNav(active: 0));
}

class EmptyHomePage extends StatelessWidget {
  const EmptyHomePage({required this.role, super.key});

  final HomeRole role;

  @override
  Widget build(BuildContext context) {
    final provider = role == HomeRole.provider;
    return Scaffold(
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
                    ? 'OPERATIONS · SUNDAY, SEP 6'
                    : 'GOOD MORNING · SUNDAY, SEP 6',
                name: provider ? 'FuelMex Logistics' : 'PetroAndes',
                subtitle: provider
                    ? 'Supplier · Regional hub'
                    : 'Requester · Fleet ops',
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
                      provider ? 'No operations today' : 'No active orders',
                      style: const TextStyle(
                        color: FullTankColors.navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      provider
                          ? 'When your customers place orders, tasks and deliveries will appear here.'
                          : 'Once you create your first order or the sensor triggers an alert, it will appear here.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: FullTankColors.inkMid,
                        fontSize: 10.5,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _GradientAction(
                      label: provider ? 'Invite customer' : 'Create order',
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
                const _SectionLabel('SETUP CHECKLIST'),
                const SizedBox(height: 8),
                const _SetupRow(
                  icon: Icons.business_outlined,
                  title: 'Add your first tank',
                  detail: 'Connect an IoT sensor',
                  done: false,
                ),
                const _SetupRow(
                  icon: Icons.person_add_alt_1_outlined,
                  title: 'Invite your team',
                  detail: 'Collaborate on operations',
                  done: false,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SubpageHeader extends StatelessWidget {
  const _SubpageHeader({required this.title, required this.subtitle, this.trailing});

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(children: [IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back, size: 18), style: IconButton.styleFrom(backgroundColor: FullTankColors.card, fixedSize: const Size(36, 36), padding: EdgeInsets.zero)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: FullTankColors.navy, fontSize: 21, fontWeight: FontWeight.w800, letterSpacing: -.5)), Text(subtitle, style: const TextStyle(color: FullTankColors.inkMid, fontSize: 10.5))])), if (trailing != null) trailing!]);
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: selected ? FullTankColors.navy : FullTankColors.card, borderRadius: BorderRadius.circular(999)), child: Text(label, style: TextStyle(color: selected ? Colors.white : FullTankColors.navyMid, fontSize: 9.5, fontWeight: FontWeight.w700)));
}

class _SearchResult extends StatelessWidget {
  const _SearchResult({required this.icon, required this.eyebrow, required this.title, required this.detail, required this.color, required this.softColor});

  final IconData icon;
  final String eyebrow;
  final String title;
  final String detail;
  final Color color;
  final Color softColor;

  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 7), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: FullTankColors.line), borderRadius: BorderRadius.circular(10)), child: Row(children: [_IconTile(icon: icon, color: color, softColor: softColor, size: 28), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(eyebrow, style: TextStyle(color: color, fontSize: 7.5, fontWeight: FontWeight.w800)), const SizedBox(height: 2), Text(title, style: const TextStyle(color: FullTankColors.navy, fontSize: 10.5, fontWeight: FontWeight.w800)), Text(detail, style: const TextStyle(color: FullTankColors.inkMid, fontSize: 8.5))])), const Icon(Icons.chevron_right, size: 16, color: FullTankColors.inkSoft)]));
}

class _GradientAction extends StatelessWidget {
  const _GradientAction({required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap, child: Container(height: 39, width: double.infinity, decoration: BoxDecoration(gradient: const LinearGradient(colors: [FullTankColors.ctaFrom, FullTankColors.ctaTo]), borderRadius: BorderRadius.circular(999), boxShadow: const [BoxShadow(color: Color(0x44FFA500), blurRadius: 14, offset: Offset(0, 7))]), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 14, color: Colors.white), const SizedBox(width: 6), Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800))])));
}

class _SheetAction extends StatelessWidget {
  const _SheetAction({required this.icon, required this.title, required this.detail, required this.color, required this.softColor});

  final IconData icon;
  final String title;
  final String detail;
  final Color color;
  final Color softColor;

  @override
  Widget build(BuildContext context) => Container(height: 42, padding: const EdgeInsets.symmetric(horizontal: 9), decoration: BoxDecoration(color: const Color(0xFFF8F9FB), borderRadius: BorderRadius.circular(9)), child: Row(children: [_IconTile(icon: icon, color: color, softColor: softColor, size: 27), const SizedBox(width: 9), Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: FullTankColors.navy, fontSize: 10, fontWeight: FontWeight.w800)), Text(detail, style: _metaStyle)])), const Icon(Icons.chevron_right, size: 16, color: FullTankColors.inkSoft)]));
}

class _ActivityGroup extends StatelessWidget {
  const _ActivityGroup({required this.label, required this.items});

  final String label;
  final List<_ActivityItem> items;

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: _labelStyle), const SizedBox(height: 8), ...items]);
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({required this.icon, required this.title, required this.detail, required this.time, required this.color, required this.softColor});

  final IconData icon;
  final String title;
  final String detail;
  final String time;
  final Color color;
  final Color softColor;

  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: FullTankColors.line), borderRadius: BorderRadius.circular(10)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [_IconTile(icon: icon, color: color, softColor: softColor, size: 28), const SizedBox(width: 9), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: FullTankColors.navy, fontSize: 10.5, fontWeight: FontWeight.w800)), const SizedBox(height: 2), Text(detail, style: const TextStyle(color: FullTankColors.inkMid, fontSize: 8.5))])), Text(time, style: _metaStyle)]));
}

class _SetupRow extends StatelessWidget {
  const _SetupRow({required this.icon, required this.title, required this.detail, required this.done});

  final IconData icon;
  final String title;
  final String detail;
  final bool done;

  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 7), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: FullTankColors.card, borderRadius: BorderRadius.circular(10)), child: Row(children: [_IconTile(icon: icon, color: FullTankColors.blue, softColor: Colors.white, size: 30), const SizedBox(width: 9), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: FullTankColors.navy, fontSize: 10.5, fontWeight: FontWeight.w800)), Text(detail, style: _metaStyle)])), Icon(done ? Icons.check_circle : Icons.chevron_right, size: 17, color: done ? _green : FullTankColors.inkSoft)]));
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.active});

  final int active;

  @override
  Widget build(BuildContext context) {
    const labels = ['Home', 'Inventory', 'Alerts', 'Reports', 'Account'];
    const icons = [Icons.home_outlined, Icons.inventory_2_outlined, Icons.notifications_none_outlined, Icons.bar_chart_outlined, Icons.person_outline];
    return Container(padding: const EdgeInsets.fromLTRB(8, 8, 8, 14), decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: FullTankColors.line))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(labels.length, (index) => Column(mainAxisSize: MainAxisSize.min, children: [Icon(icons[index], size: 18, color: index == active ? FullTankColors.blue : FullTankColors.inkSoft), const SizedBox(height: 3), Text(labels[index], style: TextStyle(color: index == active ? FullTankColors.blue : FullTankColors.inkSoft, fontSize: 8.5, fontWeight: index == active ? FontWeight.w700 : FontWeight.w500))]))));
  }
}
