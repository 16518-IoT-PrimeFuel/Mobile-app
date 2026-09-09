part of 'inventory_page.dart';

class TankData {
  const TankData({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    required this.level,
    required this.capacity,
    required this.current,
    required this.sensor,
    required this.updated,
  });

  final String id;
  final String name;
  final String location;
  final String type;
  final int level;
  final int capacity;
  final int current;
  final String sensor;
  final String updated;
}

const _tanks = [
  TankData(
    id: 'A-102',
    name: 'Tanque diésel A-102',
    location: 'Patio norte · Sector 4',
    type: 'Diésel',
    level: 12,
    capacity: 12000,
    current: 1440,
    sensor: 'SN-4492',
    updated: 'hace 2 min',
  ),
  TankData(
    id: 'B-05',
    name: 'Tanque de agua B-05',
    location: 'Sector 1',
    type: 'Refrigerante',
    level: 84,
    capacity: 50000,
    current: 42000,
    sensor: 'SN-2011',
    updated: 'hace 1 min',
  ),
  TankData(
    id: 'C-12',
    name: 'Tanque de lubricante C-12',
    location: 'Sector 9',
    type: 'Lubricante',
    level: 35,
    capacity: 8000,
    current: 2800,
    sensor: 'SN-8821',
    updated: 'hace 3 min',
  ),
  TankData(
    id: 'A-204',
    name: 'Tanque diésel A-204',
    location: 'Patio norte · Sector 4',
    type: 'Diésel',
    level: 72,
    capacity: 15000,
    current: 10800,
    sensor: 'SN-4499',
    updated: 'ahora mismo',
  ),
  TankData(
    id: 'G-11',
    name: 'Propano G-11',
    location: 'Sector 6',
    type: 'Propano',
    level: 18,
    capacity: 6000,
    current: 1080,
    sensor: 'SN-9002',
    updated: 'hace 5 min',
  ),
  TankData(
    id: 'D-4',
    name: 'Hidráulico D-4',
    location: 'Sector 2',
    type: 'Hidráulico',
    level: 58,
    capacity: 4000,
    current: 2320,
    sensor: 'SN-3355',
    updated: 'hace 4 min',
  ),
];

TankData _tankForId(String id) {
  for (final tank in _tanks) {
    if (tank.id == id) return tank;
  }
  if (id == 'B-07') {
    return const TankData(
      id: 'B-07',
      name: 'Refrigerante B-07',
      location: 'Sector 1',
      type: 'Refrigerante',
      level: 28,
      capacity: 50000,
      current: 14000,
      sensor: 'SN-2018',
      updated: 'hace 18 min',
    );
  }
  return _tanks.first;
}

_TankStatus _statusFor(int level) {
  if (level < 20) return _TankStatus.critical;
  if (level < 40) return _TankStatus.warning;
  return _TankStatus.optimal;
}

Color _statusColor(_TankStatus status) => switch (status) {
  _TankStatus.critical => _red,
  _TankStatus.warning => _amber,
  _TankStatus.optimal => _green,
};

Color _statusSoft(_TankStatus status) => switch (status) {
  _TankStatus.critical => _redSoft,
  _TankStatus.warning => _amberSoft,
  _TankStatus.optimal => _greenSoft,
};

String _statusLabel(_TankStatus status) => switch (status) {
  _TankStatus.critical => 'Crítico',
  _TankStatus.warning => 'Advertencia',
  _TankStatus.optimal => 'Óptimo',
};

String _liters(int value) => value.toString().replaceAllMapped(
  RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
  (match) => '${match[1]},',
);

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final visible = _tanks.where((tank) {
      return switch (_filter) {
        'critical' => tank.level < 20,
        'warning' => tank.level >= 20 && tank.level < 40,
        'optimal' => tank.level >= 40,
        _ => true,
      };
    }).toList();
    return _InventoryShell(
      title: 'Inventario',
      subtitle: '${_tanks.length} tanques · IoT en vivo',
      right: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _HeaderIconButton(
            icon: Icons.search,
            label: 'Buscar tanques',
            onPressed: () async {
              final selected = await showSearch<TankData?>(
                context: context,
                delegate: _TankSearchDelegate(),
              );
              if (context.mounted && selected != null) {
                context.go('/inventory/tank/${selected.id}');
              }
            },
          ),
          _HeaderIconButton(
            icon: Icons.notifications_none_outlined,
            label: 'Ver alertas',
            badge: 3,
            onPressed: () => context.go('/inventory/alerts'),
          ),
        ],
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryMetric(
                label: 'Crítico',
                count: _tanks.where((tank) => tank.level < 20).length,
                status: _TankStatus.critical,
              ),
            ),
            SizedBox(width: 11.6),
            Expanded(
              child: _SummaryMetric(
                label: 'Advertencia',
                count: _tanks
                    .where((tank) => tank.level >= 20 && tank.level < 40)
                    .length,
                status: _TankStatus.warning,
              ),
            ),
            SizedBox(width: 11.6),
            Expanded(
              child: _SummaryMetric(
                label: 'Óptimo',
                count: _tanks.where((tank) => tank.level >= 40).length,
                status: _TankStatus.optimal,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.3),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(
                label: 'Todos',
                count: _tanks.length,
                selected: _filter == 'all',
                onPressed: () => setState(() => _filter = 'all'),
              ),
              _FilterChip(
                label: 'Crítico',
                count: 2,
                status: _TankStatus.critical,
                selected: _filter == 'critical',
                onPressed: () => setState(() => _filter = 'critical'),
              ),
              _FilterChip(
                label: 'Advertencia',
                count: 1,
                status: _TankStatus.warning,
                selected: _filter == 'warning',
                onPressed: () => setState(() => _filter = 'warning'),
              ),
              _FilterChip(
                label: 'Óptimo',
                count: 3,
                status: _TankStatus.optimal,
                selected: _filter == 'optimal',
                onPressed: () => setState(() => _filter = 'optimal'),
              ),
            ],
          ),
        ),
        SizedBox(height: 17.4),
        ...visible.map(
          (tank) => Padding(
            padding: EdgeInsets.only(bottom: 11.6),
            child: _TankRow(tank: tank),
          ),
        ),
      ],
    );
  }
}
