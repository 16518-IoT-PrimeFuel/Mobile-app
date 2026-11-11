part of 'inventory_page.dart';

class _QuickQuantity extends StatelessWidget {
  const _QuickQuantity({
    required this.label,
    required this.value,
    required this.onPressed,
  });
  final String label;
  final int value;
  final ValueChanged<int> onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: () => onPressed(value),
    style: OutlinedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 15.95, vertical: 7.25),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: Colors.white,
      foregroundColor: FullTankColors.text,
      side: const BorderSide(color: FullTankColors.border),
      shape: const StadiumBorder(),
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 16.675, fontWeight: FontWeight.w600),
    ),
  );
}

class _FormInfoRow extends StatelessWidget {
  const _FormInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label: $value',
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 17.4, vertical: 14.5),
      decoration: BoxDecoration(
        color: FullTankColors.background,
        borderRadius: BorderRadius.circular(11.6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 26.1, color: FullTankColors.muted),
          SizedBox(width: 11.6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label.toUpperCase(), style: _metaLabelStyle),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: FullTankColors.text,
                    fontSize: 17.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
