part of 'order_pages.dart';

class _SalesDashboard extends StatelessWidget {
  const _SalesDashboard();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Row(
        children: [
          Expanded(
            child: _MetricCard(
              label: 'VENTAS TOTALES',
              value: 'S/ 148,320',
              accent: _blue,
              badge: '+8.2%',
            ),
          ),
          SizedBox(width: 6),
          Expanded(
            child: _MetricCard(
              label: 'LITROS VENDIDOS',
              value: '42.8K L',
              accent: _blue,
              badge: '+5.6%',
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      const Row(
        children: [
          Expanded(
            child: _MetricCard(
              label: 'PEDIDOS',
              value: '24',
              accent: _orange,
              badge: '+3',
            ),
          ),
          SizedBox(width: 6),
          Expanded(
            child: _MetricCard(
              label: 'CLIENTES ATENDIDOS',
              value: '18',
              accent: _muted,
              badge: '+2',
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      const _SalesBars(),
      const SizedBox(height: 12),
      const Text(
        'Filtros del reporte',
        style: TextStyle(
          color: _ink,
          fontSize: 15.95,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'RANGO DE FECHAS',
        style: TextStyle(
          color: _subtle,
          fontSize: 10.15,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 5),
      const _SelectField(label: '01 Ago 2026 – 03 Sep 2026'),
      const SizedBox(height: 8),
      const Row(
        children: [
          Expanded(child: _SelectField(label: 'Todos los clientes')),
          SizedBox(width: 6),
          Expanded(child: _SelectField(label: 'Todos los combustibles')),
        ],
      ),
    ],
  );
}

class _SalesBars extends StatelessWidget {
  const _SalesBars();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(10, 9, 10, 7),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(11),
      border: Border.all(color: _line),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'VENTAS POR SEMANA',
              style: TextStyle(
                color: _muted,
                fontSize: 10.15,
                fontWeight: FontWeight.w800,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: _panel,
                borderRadius: BorderRadius.circular(99),
              ),
              child: const Row(
                children: [
                  Text(
                    '30d',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 10.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, size: 11, color: _muted),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 67,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < 8; i++)
                _Bar(
                  value: [0.48, .67, .72, .57, .9, .75, .82, .88][i],
                  label: 'S${i + 1}',
                  highlighted: i == 4,
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SelectField extends StatelessWidget {
  const _SelectField({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.schedule, size: 10, color: _muted),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _muted,
                fontSize: 11.6,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, size: 12, color: _muted),
        ],
      ),
    ),
  );
}
