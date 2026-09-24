part of 'order_pages.dart';

class _FieldCaption extends StatelessWidget {
  const _FieldCaption({required this.label, this.error = false});
  final String label;
  final bool error;
  @override
  Widget build(BuildContext context) => Text(
    error ? '$label · REQUIRED' : label,
    style: TextStyle(
      color: error ? _red : _subtle,
      fontSize: 7,
      fontWeight: FontWeight.w800,
      letterSpacing: .35,
    ),
  );
}
