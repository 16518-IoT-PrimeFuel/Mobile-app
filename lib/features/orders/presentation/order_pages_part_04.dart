part of 'order_pages.dart';

class _ConnectionErrorCard extends StatelessWidget {
  const _ConnectionErrorCard({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF1F2),
      border: Border.all(color: const Color(0xFFFFC7CC)),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      children: [
        Container(
          width: 27,
          height: 27,
          decoration: const BoxDecoration(color: _red, shape: BoxShape.circle),
          child: const Icon(Icons.wifi_off, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 7),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Connection error',
                style: TextStyle(
                  color: _red,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Couldn't reach the supplier service. Check your connection and retry.",
                style: TextStyle(color: _muted, fontSize: 7, height: 1.3),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onRetry,
          child: const Text(
            '↻ Retry',
            style: TextStyle(
              color: _red,
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ),
  );
}
