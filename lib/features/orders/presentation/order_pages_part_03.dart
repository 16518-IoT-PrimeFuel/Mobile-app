part of 'order_pages.dart';

class _FieldCaption extends StatelessWidget {
  const _FieldCaption({required this.label, this.error = false});
  final String label;
  final bool error;
  @override
  Widget build(BuildContext context) => Text(
    error ? '$label · REQUIRED' : label,
    style: TextStyle(
      color: error ? _red : _subtle,
      fontSize: 7,
      fontWeight: FontWeight.w800,
      letterSpacing: .35,
    ),
  );
}

class _FuelGrid extends StatelessWidget {
  const _FuelGrid({
    required this.selected,
    required this.onSelected,
    required this.error,
  });
  final String selected;
  final ValueChanged<String> onSelected;
  final bool error;
  @override
  Widget build(BuildContext context) {
    const fuels = [
      ('Diesel', 'ULSD B5', Icons.opacity_outlined),
      ('Gasoline', '95 · 97', Icons.receipt_long_outlined),
      ('LPG', 'Propano', Icons.local_fire_department_outlined),
      ('Other', 'Custom', Icons.storage_outlined),
    ];
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: error ? Border.all(color: _red) : null,
        borderRadius: BorderRadius.circular(9),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 2.25,
        children: [
          for (final fuel in fuels)
            _FuelChoice(
              name: fuel.$1,
              detail: fuel.$2,
              icon: fuel.$3,
              selected: selected == fuel.$1 && !error,
              onTap: () => onSelected(fuel.$1),
            ),
        ],
      ),
    );
  }
}

class _FuelChoice extends StatelessWidget {
  const _FuelChoice({
    required this.name,
    required this.detail,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String name, detail;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: '$name $detail',
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? _blueSoft : _panel,
          border: Border.all(color: selected ? _blue : Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: selected ? _blue : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : _muted,
                size: 14,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: selected ? _blue : _ink,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    detail,
                    style: const TextStyle(color: _muted, fontSize: 7),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: _blue, size: 13),
          ],
        ),
      ),
    ),
  );
}

class _MoneyCard extends StatelessWidget {
  const _MoneyCard();
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(9),
      border: Border.all(color: _line),
    ),
    child: Column(
      children: [
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'S/ ',
                style: TextStyle(
                  color: _muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: '6,000',
                style: TextStyle(
                  color: _ink,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '✓ Coincide con el total del pedido',
          style: TextStyle(
            color: _green,
            fontSize: 8,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
