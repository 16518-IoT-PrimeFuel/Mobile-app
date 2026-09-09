part of 'inventory_page.dart';

class _TargetTankCard extends StatelessWidget {
  const _TargetTankCard({required this.tank});
  final TankData tank;

  @override
  Widget build(BuildContext context) {
    final status = _statusFor(tank.level);
    return Container(
      padding: EdgeInsets.all(20.3),
      decoration: BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(11.6),
      ),
      child: Row(
        children: [
          _TankIcon(status: status),
          SizedBox(width: 17.4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('TANQUE DESTINO', style: _metaLabelStyle),
                Text(
                  tank.name,
                  style: const TextStyle(
                    color: Color(0xFF1A202C),
                    fontSize: 20.3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    _StatusPill(status: status),
                    SizedBox(width: 11.6),
                    Text(
                      '${_liters(tank.current)} / ${_liters(tank.capacity)} L',
                      style: const TextStyle(
                        color: Color(0xFF4A5568),
                        fontSize: 15.95,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({
    required this.id,
    required this.label,
    required this.detail,
    required this.status,
    required this.selected,
    required this.onPressed,
  });

  final String id;
  final String label;
  final String detail;
  final _TankStatus status;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Semantics(
      button: true,
      selected: selected,
      label: '$label, $detail',
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(17.4),
          alignment: Alignment.centerLeft,
          backgroundColor: selected ? _statusSoft(status) : Color(0xFFF3F4F6),
          foregroundColor: selected ? color : Color(0xFF1A202C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.6),
            side: BorderSide(
              color: selected ? color : Colors.transparent,
              width: 1.5,
            ),
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 17.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  detail,
                  style: const TextStyle(
                    color: Color(0xFF4A5568),
                    fontSize: 15.225,
                  ),
                ),
              ],
            ),
            if (selected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QuantityPicker extends StatelessWidget {
  const _QuantityPicker({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onQuickPick,
    required this.maxQuantity,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<int> onQuickPick;
  final int maxQuantity;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(23.2),
    decoration: BoxDecoration(
      color: Color(0xFFF3F4F6),
      borderRadius: BorderRadius.circular(11.6),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            SizedBox(
              width: 188.5,
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: const TextStyle(
                  color: Color(0xFF1A202C),
                  fontSize: 49.3,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
            ),
            SizedBox(width: 8.7),
            const Text(
              'L',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 23.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.5),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.7,
          runSpacing: 8.7,
          children: [
            _QuickQuantity(
              label: '3,000 L',
              value: 3000,
              onPressed: onQuickPick,
            ),
            _QuickQuantity(
              label: '6,000 L',
              value: 6000,
              onPressed: onQuickPick,
            ),
            _QuickQuantity(
              label: '9,000 L',
              value: 9000,
              onPressed: onQuickPick,
            ),
            _QuickQuantity(
              label: 'Llenar',
              value: maxQuantity,
              onPressed: onQuickPick,
            ),
          ],
        ),
      ],
    ),
  );
}
