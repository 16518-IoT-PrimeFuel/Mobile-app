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
            padding: EdgeInsets.fromLTRB(
              20 * _uiScale,
              4 * _uiScale,
              20 * _uiScale,
              8 * _uiScale,
            ),
            child: Row(
              children: [
                if (back) ...[
                  Semantics(
                    button: true,
                    label: 'Go back',
                    child: IconButton(
                      onPressed: () => context.go('/inventory'),
                      tooltip: 'Go back',
                      icon: const Icon(Icons.arrow_back, size: 18),
                      style: IconButton.styleFrom(
                        backgroundColor: FullTankColors.card,
                        fixedSize: Size.square(40 * _uiScale),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  SizedBox(width: 10 * _uiScale),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: FullTankColors.navy,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -.5,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: FullTankColors.inkMid,
                          fontSize: 12,
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
                20 * _uiScale,
                10 * _uiScale,
                20 * _uiScale,
                hasBottomNav ? 24 * _uiScale : 20 * _uiScale,
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
        ? const FullTankBottomNav(active: 1)
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
          Icon(icon, size: 19 * _uiScale),
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
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
      style: IconButton.styleFrom(
        backgroundColor: FullTankColors.card,
        fixedSize: Size.square(40 * _uiScale),
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
    padding: EdgeInsets.symmetric(
      horizontal: 12 * _uiScale,
      vertical: 10 * _uiScale,
    ),
    decoration: BoxDecoration(
      color: _statusSoft(status),
      borderRadius: BorderRadius.circular(8 * _uiScale),
      border: Border.all(color: _statusColor(status).withAlpha(56)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: _statusColor(status),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: .6,
          ),
        ),
        Text(
          count.toString().padLeft(2, '0'),
          style: const TextStyle(
            color: FullTankColors.navy,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -.5,
          ),
        ),
      ],
    ),
  );
}
