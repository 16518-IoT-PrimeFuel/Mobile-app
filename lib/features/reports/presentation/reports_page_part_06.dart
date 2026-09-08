part of 'reports_page.dart';

class _TinyIcon extends StatelessWidget {
  const _TinyIcon({required this.icon, required this.color});
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    width: 22,
    height: 22,
    decoration: BoxDecoration(
      color: color.withAlpha(24),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Icon(icon, size: 12, color: color),
  );
}
