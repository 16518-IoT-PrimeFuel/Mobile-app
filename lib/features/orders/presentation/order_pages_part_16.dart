part of 'order_pages.dart';

class _DarkButton extends StatelessWidget {
  const _DarkButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: _ink,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      textStyle: const TextStyle(fontSize: 7, fontWeight: FontWeight.w700),
    ),
    child: Text(label),
  );
}

class _LightButton extends StatelessWidget {
  const _LightButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onTap,
    child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    style: OutlinedButton.styleFrom(
      foregroundColor: _blue,
      side: const BorderSide(color: Color(0xFFBCD4FF)),
      padding: const EdgeInsets.symmetric(vertical: 11),
      textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
    ),
  );
}
