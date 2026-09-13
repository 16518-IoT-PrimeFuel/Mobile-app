part of 'order_pages.dart';

class _ErrorIllustration extends StatelessWidget {
  const _ErrorIllustration();
  @override
  Widget build(BuildContext context) => Container(
    width: 82,
    height: 82,
    decoration: const BoxDecoration(
      color: Color(0xFFFFF0F1),
      shape: BoxShape.circle,
    ),
    child: Container(
      margin: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: _red, shape: BoxShape.circle),
      child: const Icon(Icons.wifi_off, color: Colors.white, size: 27),
    ),
  );
}

class _ErrorMeta extends StatelessWidget {
  const _ErrorMeta({required this.history});
  final bool history;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ERROR CODE',
              style: TextStyle(
                color: _subtle,
                fontSize: 6,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              history ? 'HIST_ERR_503' : 'NET_ERR_502',
              style: TextStyle(
                color: _muted,
                fontSize: 8,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'LAST SYNC',
              style: TextStyle(
                color: _subtle,
                fontSize: 6,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              history ? 'hace 3 min' : '2 min ago',
              style: TextStyle(
                color: _muted,
                fontSize: 8,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
