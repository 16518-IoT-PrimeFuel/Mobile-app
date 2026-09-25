part of 'missing_pages.dart';

const _ink = Color(0xFF1A202C);
const _muted = Color(0xFF4A5568);
const _line = Color(0xFFE2E8F0);
const _blue = Color(0xFF1E40AF);
const _blueSoft = Color(0xFFEFF4FF);
const _green = Color(0xFF0F9B91);
const _greenSoft = Color(0xFFEAFBF8);
const _orange = Color(0xFFFF8A0A);
const _orangeSoft = Color(0xFFFFF4E9);
const _red = Color(0xFFEF4444);
const _redSoft = Color(0xFFFEF2F2);

class MissingPageShell extends StatelessWidget {
  const MissingPageShell({
    required this.title,
    required this.child,
    this.subtitle,
    this.actions = const [],
    this.bottomNav,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget> actions;
  final int? bottomNav;

  @override
  Widget build(BuildContext context) {
    final showBack =
        GoRouter.maybeOf(context)?.canPop() ?? Navigator.of(context).canPop();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (showBack)
                    IconButton(
                      onPressed: context.pop,
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Volver',
                      visualDensity: VisualDensity.compact,
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: _ink,
                            fontSize: 33.35,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -.4,
                          ),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: const TextStyle(
                              color: _muted,
                              fontSize: 19.575,
                              height: 1.5,
                            ),
                          ),
                      ],
                    ),
                  ),
                  ...actions,
                ],
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNav == null
          ? null
          : FullTankBottomNav(active: bottomNav!),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.color = Colors.white});
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _line),
    ),
    child: Material(color: Colors.transparent, child: child),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        color: _muted,
        fontSize: 15.95,
        fontWeight: FontWeight.w800,
        letterSpacing: .6,
      ),
    ),
  );
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: _blue,
        minimumSize: const Size.fromHeight(52),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontSize: 20.3, fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    ),
  );
}

class _StatusChip extends StatelessWidget {
  const _StatusChip(this.label, this.color, this.background);
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 14.5,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}
