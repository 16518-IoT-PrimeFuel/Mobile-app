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
      color: FullTankColors.background,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        _IconTile(
          icon: icon,
          color: FullTankColors.primary,
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
                  color: FullTankColors.text,
                  fontSize: 15.225,
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
          color: done ? _green : FullTankColors.muted,
        ),
      ],
    ),
  );
}
