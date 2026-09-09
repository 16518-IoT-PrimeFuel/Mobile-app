part of 'inventory_page.dart';

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 75.4,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFFA500),
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
            style: const TextStyle(
              fontSize: 21.75,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 14.5),
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
