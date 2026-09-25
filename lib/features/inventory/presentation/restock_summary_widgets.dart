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
      foregroundColor: Color(0xFF1A202C),
      side: const BorderSide(color: Color(0xFFE2E8F0)),
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
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(11.6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 26.1, color: Color(0xFF94A3B8)),
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
                    color: Color(0xFF1A202C),
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
    padding: EdgeInsets.all(20.3),
    decoration: BoxDecoration(
      color: Color(0xFFEFF4FF),
      border: Border.all(color: Color(0xFF1E40AF).withAlpha(56)),
      borderRadius: BorderRadius.circular(11.6),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RESUMEN DEL PEDIDO',
          style: TextStyle(
            color: Color(0xFF1E40AF),
            fontSize: 15.225,
            fontWeight: FontWeight.w700,
            letterSpacing: .6,
          ),
        ),
        SizedBox(height: 11.6),
        _SummaryRow(
          label: 'Combustible (${_liters(quantity)} L × \$1.28)',
          value: _money(fuel),
        ),
        _SummaryRow(label: 'Entrega urgente', value: '+ ${_money(delivery)}'),
        _SummaryRow(label: 'Impuestos', value: _money(taxes)),
        SizedBox(height: 8.7),
        Divider(height: 1, color: Color(0xFF1E40AF).withAlpha(56)),
        SizedBox(height: 8.7),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total estimado',
              style: TextStyle(
                color: Color(0xFF1A202C),
                fontSize: 21.75,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              _money(total),
              style: const TextStyle(
                color: Color(0xFF1A202C),
                fontSize: 21.75,
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
    padding: EdgeInsets.only(bottom: 7.25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF4A5568), fontSize: 18.125),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1A202C),
            fontSize: 18.125,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
