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
        color: FullTankColors.background,
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
                    color: FullTankColors.text,
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
                        color: FullTankColors.textSecondary,
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
      color: FullTankColors.background,
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
                  color: FullTankColors.text,
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
                color: FullTankColors.muted,
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
