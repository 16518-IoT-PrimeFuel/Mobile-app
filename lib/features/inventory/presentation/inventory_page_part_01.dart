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
    name: 'Diesel Tank A-102',
    location: 'North Yard · Sector 4',
    type: 'Diesel',
    level: 12,
    capacity: 12000,
    current: 1440,
    sensor: 'SN-4492',
    updated: '2 min ago',
  ),
  TankData(
    id: 'B-05',
    name: 'Water Tank B-05',
    location: 'Sector 1',
    type: 'Coolant',
    level: 84,
    capacity: 50000,
    current: 42000,
    sensor: 'SN-2011',
    updated: '1 min ago',
  ),
  TankData(
    id: 'C-12',
    name: 'Lube Tank C-12',
    location: 'Sector 9',
    type: 'Lubricant',
    level: 35,
    capacity: 8000,
    current: 2800,
    sensor: 'SN-8821',
    updated: '3 min ago',
  ),
  TankData(
    id: 'A-204',
    name: 'Diesel Tank A-204',
    location: 'North Yard · Sector 4',
    type: 'Diesel',
    level: 72,
    capacity: 15000,
    current: 10800,
    sensor: 'SN-4499',
    updated: 'just now',
  ),
  TankData(
    id: 'G-11',
    name: 'Propane G-11',
    location: 'Sector 6',
    type: 'Propane',
    level: 18,
    capacity: 6000,
    current: 1080,
    sensor: 'SN-9002',
    updated: '5 min ago',
  ),
  TankData(
    id: 'D-4',
    name: 'Hydraulic D-4',
    location: 'Sector 2',
    type: 'Hydraulic',
    level: 58,
    capacity: 4000,
    current: 2320,
    sensor: 'SN-3355',
    updated: '4 min ago',
  ),
];

TankData _tankForId(String id) {
  for (final tank in _tanks) {
    if (tank.id == id) return tank;
  }
  if (id == 'B-07') {
    return const TankData(
      id: 'B-07',
      name: 'Coolant B-07',
      location: 'Sector 1',
      type: 'Coolant',
      level: 28,
      capacity: 50000,
      current: 14000,
      sensor: 'SN-2018',
      updated: '18 min ago',
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
  _TankStatus.critical => 'Critical',
  _TankStatus.warning => 'Warning',
  _TankStatus.optimal => 'Optimal',
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
    return _withInventoryScale(
      context,
      _InventoryShell(
        title: 'Inventory',
        subtitle: '${_tanks.length} tanks · live IoT',
        right: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HeaderIconButton(
              icon: Icons.search,
              label: 'Search tanks',
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
              label: 'View alerts',
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
                  label: 'Critical',
                  count: _tanks.where((tank) => tank.level < 20).length,
                  status: _TankStatus.critical,
                ),
              ),
              SizedBox(width: 8 * _uiScale),
              Expanded(
                child: _SummaryMetric(
                  label: 'Warning',
                  count: _tanks
                      .where((tank) => tank.level >= 20 && tank.level < 40)
                      .length,
                  status: _TankStatus.warning,
                ),
              ),
              SizedBox(width: 8 * _uiScale),
              Expanded(
                child: _SummaryMetric(
                  label: 'Optimal',
                  count: _tanks.where((tank) => tank.level >= 40).length,
                  status: _TankStatus.optimal,
                ),
              ),
            ],
          ),
          SizedBox(height: 14 * _uiScale),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  count: _tanks.length,
                  selected: _filter == 'all',
                  onPressed: () => setState(() => _filter = 'all'),
                ),
                _FilterChip(
                  label: 'Critical',
                  count: 2,
                  status: _TankStatus.critical,
                  selected: _filter == 'critical',
                  onPressed: () => setState(() => _filter = 'critical'),
                ),
                _FilterChip(
                  label: 'Warning',
                  count: 1,
                  status: _TankStatus.warning,
                  selected: _filter == 'warning',
                  onPressed: () => setState(() => _filter = 'warning'),
                ),
                _FilterChip(
                  label: 'Optimal',
                  count: 3,
                  status: _TankStatus.optimal,
                  selected: _filter == 'optimal',
                  onPressed: () => setState(() => _filter = 'optimal'),
                ),
              ],
            ),
          ),
          SizedBox(height: 12 * _uiScale),
          ...visible.map(
            (tank) => Padding(
              padding: EdgeInsets.only(bottom: 8 * _uiScale),
              child: _TankRow(tank: tank),
            ),
          ),
        ],
      ),
    );
  }
}

