part of 'order_pages.dart';

class _TankCard extends StatelessWidget {
  const _TankCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: _blueSoft,
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      children: [
        Container(
          width: 27,
          height: 27,
          decoration: const BoxDecoration(
            color: _blue,
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
          child: const Icon(
            Icons.inventory_2_outlined,
            color: Colors.white,
            size: 15,
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DESTINATION',
                style: TextStyle(
                  color: _muted,
                  fontSize: 6,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Diesel Tank A-102',
                style: TextStyle(
                  color: _ink,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Sector 4 · Current 12% (1,440 L)',
                style: TextStyle(color: _muted, fontSize: 7),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Change',
            style: TextStyle(
              color: _blue,
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ),
  );
}

class _SupplierCard extends StatelessWidget {
  const _SupplierCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      children: [
        Container(
          width: 27,
          height: 27,
          decoration: const BoxDecoration(
            color: _ink,
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
          child: const Icon(
            Icons.local_shipping_outlined,
            color: Colors.white,
            size: 14,
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FAVORITE',
                style: TextStyle(
                  color: _muted,
                  fontSize: 6,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Global Fuel Corp',
                style: TextStyle(
                  color: _ink,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '98.4% reliability · ETA 2.5h',
                style: TextStyle(color: _muted, fontSize: 7),
              ),
            ],
          ),
        ),
        const Text(
          '• Available',
          style: TextStyle(
            color: _green,
            fontSize: 8,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _DeliveryField extends StatelessWidget {
  const _DeliveryField();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Icon(Icons.schedule, color: _muted, size: 14),
        SizedBox(width: 7),
        Expanded(
          child: Text(
            'Sep 5, 08:00 – 12:00',
            style: TextStyle(
              color: _ink,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Icon(Icons.keyboard_arrow_down, color: _muted, size: 15),
      ],
    ),
  );
}

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
