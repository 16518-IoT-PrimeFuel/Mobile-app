part of 'inventory_page.dart';

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

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 52 * _uiScale,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: FullTankColors.ctaTo,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        elevation: 5,
        shadowColor: const Color(0x55FFA500),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          SizedBox(width: 10 * _uiScale),
          const Icon(Icons.arrow_forward, size: 18),
        ],
      ),
    ),
  );
}

class _TankSearchDelegate extends SearchDelegate<TankData?> {
  @override
  List<Widget>? buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, null),
    icon: const Icon(Icons.arrow_back),
  );

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final matches = _tanks.where((tank) {
      final value = '${tank.id} ${tank.name} ${tank.location}'.toLowerCase();
      return value.contains(query.toLowerCase());
    }).toList();
    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final tank = matches[index];
        return ListTile(
          leading: const Icon(Icons.local_gas_station_outlined),
          title: Text(tank.name),
          subtitle: Text('${tank.location} · ${tank.level}%'),
          onTap: () => close(context, tank),
        );
      },
    );
  }
}
