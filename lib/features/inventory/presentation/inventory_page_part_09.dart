part of 'inventory_page.dart';

class _TargetTankCard extends StatelessWidget {
  const _TargetTankCard({required this.tank});
  final TankData tank;

  @override
  Widget build(BuildContext context) {
    final status = _statusFor(tank.level);
    return Container(
      padding: EdgeInsets.all(14 * _uiScale),
      decoration: BoxDecoration(
        color: FullTankColors.card,
        borderRadius: BorderRadius.circular(8 * _uiScale),
      ),
      child: Row(
        children: [
          _TankIcon(status: status),
          SizedBox(width: 12 * _uiScale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('TARGET TANK', style: _metaLabelStyle),
                Text(
                  tank.name,
                  style: const TextStyle(
                    color: FullTankColors.navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    _StatusPill(status: status),
                    SizedBox(width: 8 * _uiScale),
                    Text(
                      '${_liters(tank.current)} / ${_liters(tank.capacity)} L',
                      style: const TextStyle(
                        color: FullTankColors.inkMid,
                        fontSize: 11,
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
          padding: EdgeInsets.all(12 * _uiScale),
          alignment: Alignment.centerLeft,
          backgroundColor: selected ? _statusSoft(status) : FullTankColors.card,
          foregroundColor: selected ? color : FullTankColors.navy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8 * _uiScale),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  detail,
                  style: const TextStyle(
                    color: FullTankColors.inkMid,
                    fontSize: 10.5,
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
    padding: EdgeInsets.all(16 * _uiScale),
    decoration: BoxDecoration(
      color: FullTankColors.card,
      borderRadius: BorderRadius.circular(8 * _uiScale),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            SizedBox(
              width: 130 * _uiScale,
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
                  color: FullTankColors.navy,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
            ),
            SizedBox(width: 6 * _uiScale),
            const Text(
              'L',
              style: TextStyle(
                color: FullTankColors.inkSoft,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 10 * _uiScale),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6 * _uiScale,
          runSpacing: 6 * _uiScale,
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
              label: 'Fill up',
              value: maxQuantity,
              onPressed: onQuickPick,
            ),
          ],
        ),
      ],
    ),
  );
}

