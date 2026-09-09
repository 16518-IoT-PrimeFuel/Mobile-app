part of 'inventory_page.dart';

class _InventoryShell extends StatelessWidget {
  const _InventoryShell({
    required this.title,
    required this.subtitle,
    required this.children,
    this.back = false,
    this.right,
    this.hasBottomNav = true,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool back;
  final Widget? right;
  final bool hasBottomNav;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(29.0, 5.8, 29.0, 11.6),
            child: Row(
              children: [
                if (back) ...[
                  Semantics(
                    button: true,
                    label: 'Volver',
                    child: IconButton(
                      onPressed: () => context.go('/inventory'),
                      tooltip: 'Volver',
                      icon: const Icon(Icons.arrow_back, size: 18),
                      style: IconButton.styleFrom(
                        backgroundColor: Color(0xFFF3F4F6),
                        fixedSize: Size.square(58.0),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.5),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF1A202C),
                          fontSize: 31.9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -.5,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFF4A5568),
                          fontSize: 17.4,
                        ),
                      ),
                    ],
                  ),
                ),
                if (right != null) right!,
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                29.0,
                14.5,
                29.0,
                hasBottomNav ? 34.8 : 29.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: hasBottomNav
        ? const FullTankBottomNav(active: null)
        : null,
  );
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.badge,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final int? badge;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: IconButton(
      onPressed: onPressed,
      tooltip: label,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, size: 27.55),
          if (badge != null)
            Positioned(
              right: -7,
              top: -7,
              child: Container(
                width: 15,
                height: 15,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: _red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$badge',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.05,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
      style: IconButton.styleFrom(
        backgroundColor: Color(0xFFF3F4F6),
        fixedSize: Size.square(58.0),
        padding: EdgeInsets.zero,
      ),
    ),
  );
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.count,
    required this.status,
  });

  final String label;
  final int count;
  final _TankStatus status;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 17.4, vertical: 14.5),
    decoration: BoxDecoration(
      color: _statusSoft(status),
      borderRadius: BorderRadius.circular(11.6),
      border: Border.all(color: _statusColor(status).withAlpha(56)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: _statusColor(status),
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            letterSpacing: .6,
          ),
        ),
        Text(
          count.toString().padLeft(2, '0'),
          style: const TextStyle(
            color: Color(0xFF1A202C),
            fontSize: 31.9,
            fontWeight: FontWeight.w800,
            letterSpacing: -.5,
          ),
        ),
      ],
    ),
  );
}
