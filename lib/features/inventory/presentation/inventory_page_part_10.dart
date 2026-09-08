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
      padding: EdgeInsets.symmetric(
        horizontal: 11 * _uiScale,
        vertical: 5 * _uiScale,
      ),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: Colors.white,
      foregroundColor: FullTankColors.navy,
      side: const BorderSide(color: FullTankColors.line),
      shape: const StadiumBorder(),
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
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
      padding: EdgeInsets.symmetric(
        horizontal: 12 * _uiScale,
        vertical: 10 * _uiScale,
      ),
      decoration: BoxDecoration(
        color: FullTankColors.card,
        borderRadius: BorderRadius.circular(8 * _uiScale),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18 * _uiScale, color: FullTankColors.inkSoft),
          SizedBox(width: 8 * _uiScale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label.toUpperCase(), style: _metaLabelStyle),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: FullTankColors.navy,
                    fontSize: 12,
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

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    required this.quantity,
    required this.fuel,
    required this.delivery,
    required this.taxes,
    required this.total,
  });

  final int quantity;
  final double fuel;
  final double delivery;
  final double taxes;
  final double total;

  String _money(double value) => '\$${value.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(14 * _uiScale),
    decoration: BoxDecoration(
      color: FullTankColors.blueSoft,
      border: Border.all(color: FullTankColors.blue.withAlpha(56)),
      borderRadius: BorderRadius.circular(8 * _uiScale),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ORDER SUMMARY',
          style: TextStyle(
            color: FullTankColors.blue,
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: .6,
          ),
        ),
        SizedBox(height: 8 * _uiScale),
        _SummaryRow(
          label: 'Fuel (${_liters(quantity)} L × \$1.28)',
          value: _money(fuel),
        ),
        _SummaryRow(label: 'Urgent delivery', value: '+ ${_money(delivery)}'),
        _SummaryRow(label: 'Taxes', value: _money(taxes)),
        SizedBox(height: 6 * _uiScale),
        Divider(height: 1, color: FullTankColors.blue.withAlpha(56)),
        SizedBox(height: 6 * _uiScale),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Estimated total',
              style: TextStyle(
                color: FullTankColors.navy,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              _money(total),
              style: const TextStyle(
                color: FullTankColors.navy,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 5 * _uiScale),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: FullTankColors.inkMid,
              fontSize: 12.5,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: FullTankColors.navy,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

