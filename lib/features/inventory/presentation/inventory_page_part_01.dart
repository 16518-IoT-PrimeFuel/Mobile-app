part of 'inventory_page.dart';

class TankData {
  const TankData({
    required this.id,
    this.equipmentId,
    required this.name,
    required this.location,
    required this.type,
    required this.level,
    required this.capacity,
    required this.current,
  });

  final String id;
  final int? equipmentId;
  String get routeId => equipmentId?.toString() ?? id;
  final String name;
  final String location;
  final String type;
  final int level;
  final int capacity;
  final int current;
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
  ),
  TankData(
    id: 'B-05',
    name: 'Water Tank B-05',
    location: 'Sector 1',
    type: 'Coolant',
    level: 84,
    capacity: 50000,
    current: 42000,
  ),
  TankData(
    id: 'C-12',
    name: 'Lube Tank C-12',
    location: 'Sector 9',
    type: 'Lubricant',
    level: 35,
    capacity: 8000,
    current: 2800,
  ),
  TankData(
    id: 'A-204',
    name: 'Diesel Tank A-204',
    location: 'North Yard · Sector 4',
    type: 'Diesel',
    level: 72,
    capacity: 15000,
    current: 10800,
  ),
  TankData(
    id: 'G-11',
    name: 'Propane G-11',
    location: 'Sector 6',
    type: 'Propane',
    level: 18,
    capacity: 6000,
    current: 1080,
  ),
  TankData(
    id: 'D-4',
    name: 'Hydraulic D-4',
    location: 'Sector 2',
    type: 'Hydraulic',
    level: 58,
    capacity: 4000,
    current: 2320,
  ),
];

TankData _tankForId(String id) {
  for (final tank in _tanks) {
    if (tank.id == id || tank.routeId == id) return tank;
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

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(inventoryEquipmentProvider)
        .when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, _) => Scaffold(
            body: Center(
              child: Text('No se pudo cargar el inventario: $error'),
            ),
          ),
          data: (equipment) =>
              _buildForTanks(equipment.map(_tankFromEquipment).toList()),
        );
  }

  Widget _buildForTanks(List<TankData> tanks) {
    final visible = tanks.where((tank) {
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
        subtitle: '${tanks.length} tanks',
        right: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HeaderIconButton(
              icon: Icons.search,
              label: 'Search tanks',
              onPressed: () async {
                final selected = await showSearch<TankData?>(
                  context: context,
                  delegate: _TankSearchDelegate(tanks),
                );
                if (context.mounted && selected != null) {
                  context.go('/inventory/tank/${selected.routeId}');
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
                  count: tanks.where((tank) => tank.level < 20).length,
                  status: _TankStatus.critical,
                ),
              ),
              SizedBox(width: 8 * _uiScale),
              Expanded(
                child: _SummaryMetric(
                  label: 'Warning',
                  count: tanks
                      .where((tank) => tank.level >= 20 && tank.level < 40)
                      .length,
                  status: _TankStatus.warning,
                ),
              ),
              SizedBox(width: 8 * _uiScale),
              Expanded(
                child: _SummaryMetric(
                  label: 'Optimal',
                  count: tanks.where((tank) => tank.level >= 40).length,
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
                  count: tanks.length,
                  selected: _filter == 'all',
                  onPressed: () => setState(() => _filter = 'all'),
                ),
                _FilterChip(
                  label: 'Critical',
                  count: tanks.where((tank) => tank.level < 20).length,
                  status: _TankStatus.critical,
                  selected: _filter == 'critical',
                  onPressed: () => setState(() => _filter = 'critical'),
                ),
                _FilterChip(
                  label: 'Warning',
                  count: tanks
                      .where((tank) => tank.level >= 20 && tank.level < 40)
                      .length,
                  status: _TankStatus.warning,
                  selected: _filter == 'warning',
                  onPressed: () => setState(() => _filter = 'warning'),
                ),
                _FilterChip(
                  label: 'Optimal',
                  count: tanks.where((tank) => tank.level >= 40).length,
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

TankData _tankFromEquipment(Equipment equipment) => TankData(
  id:
      RegExp(r'([A-Z]-?\d+)$').firstMatch(equipment.name)?.group(1) ??
      '${equipment.id}',
  equipmentId: equipment.id,
  name: equipment.name,
  location: equipment.location,
  type: equipment.fuelType,
  level: equipment.capacity <= 0
      ? 0
      : (equipment.currentLevel / equipment.capacity * 100).round(),
  capacity: equipment.capacity.round(),
  current: equipment.currentLevel.round(),
);
