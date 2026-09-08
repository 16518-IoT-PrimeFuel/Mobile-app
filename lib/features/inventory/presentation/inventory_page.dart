import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/fulltank_theme.dart';
import '../../home/presentation/home_page.dart';

const _uiScale = 1.3;
const _green = Color(0xFF10B981);
const _greenSoft = Color(0xFFECFDF5);
const _amber = Color(0xFFF59E0B);
const _amberSoft = Color(0xFFFFFBEB);
const _red = Color(0xFFEF4444);
const _redSoft = Color(0xFFFEF2F2);

Widget _withInventoryScale(BuildContext context, Widget child) => MediaQuery(
  data: MediaQuery.of(
    context,
  ).copyWith(textScaler: const TextScaler.linear(_uiScale)),
  child: child,
);

enum _TankStatus { critical, warning, optimal }

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

class TankDetailPage extends StatelessWidget {
  const TankDetailPage({required this.tankId, super.key});

  final String tankId;

  @override
  Widget build(BuildContext context) {
    final tank = _tankForId(tankId);
    final status = _statusFor(tank.level);
    return _withInventoryScale(
      context,
      _InventoryShell(
        title: tank.id,
        subtitle: tank.type,
        back: true,
        right: _LivePill(),
        children: [
          _GaugeCard(tank: tank, status: status),
          _InventorySectionLabel('Real-time telemetry'),
          SizedBox(height: 8 * _uiScale),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8 * _uiScale,
            mainAxisSpacing: 8 * _uiScale,
            childAspectRatio: 1.18,
            children: const [
              _MetricCard(
                icon: Icons.thermostat_outlined,
                label: 'Temperature',
                value: '24.3',
                unit: '°C',
              ),
              _MetricCard(
                icon: Icons.speed_outlined,
                label: 'Pressure',
                value: '1.02',
                unit: 'atm',
                trend: '+0.4%',
              ),
              _MetricCard(
                icon: Icons.water_drop_outlined,
                label: 'Flow rate',
                value: '0.8',
                unit: 'L/h out',
                status: _TankStatus.warning,
              ),
              _MetricCard(
                icon: Icons.access_time,
                label: 'ETA to empty',
                value: '~4h',
                status: _TankStatus.critical,
              ),
            ],
          ),
          SizedBox(height: 14 * _uiScale),
          _SensorCard(tank: tank),
          SizedBox(height: 14 * _uiScale),
          _PrimaryButton(
            label: 'Request Restock',
            onPressed: () => context.go('/inventory/restock/${tank.id}'),
          ),
        ],
      ),
    );
  }
}

class InventoryAlertsPage extends StatefulWidget {
  const InventoryAlertsPage({super.key});

  @override
  State<InventoryAlertsPage> createState() => _InventoryAlertsPageState();
}

class _InventoryAlertsPageState extends State<InventoryAlertsPage> {
  String _filter = 'all';

  static const _alerts = [
    _AlertData(
      tankId: 'A-102',
      tank: 'Diesel Tank A-102',
      level: 12,
      status: _TankStatus.critical,
      location: 'North Yard · Sector 4',
      time: '2 min ago',
      eta: '~4h to depletion',
    ),
    _AlertData(
      tankId: 'G-11',
      tank: 'Propane G-11',
      level: 18,
      status: _TankStatus.critical,
      location: 'Sector 6',
      time: '5 min ago',
      eta: '~7h to depletion',
    ),
    _AlertData(
      tankId: 'C-12',
      tank: 'Lube Tank C-12',
      level: 35,
      status: _TankStatus.warning,
      location: 'Sector 9',
      time: '12 min ago',
      eta: '~2 days',
    ),
    _AlertData(
      tankId: 'B-07',
      tank: 'Coolant B-07',
      level: 28,
      status: _TankStatus.warning,
      location: 'Sector 1',
      time: '18 min ago',
      eta: '~1.5 days',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final visible = _alerts.where((alert) {
      return _filter == 'all' ||
          (_filter == 'critical' && alert.status == _TankStatus.critical) ||
          (_filter == 'warning' && alert.status == _TankStatus.warning);
    }).toList();
    final critical = visible
        .where((alert) => alert.status == _TankStatus.critical)
        .toList();
    final warning = visible
        .where((alert) => alert.status == _TankStatus.warning)
        .toList();
    return _withInventoryScale(
      context,
      _InventoryShell(
        title: 'Alerts',
        subtitle: '4 active · 2 critical',
        back: true,
        right: _HeaderIconButton(
          icon: Icons.filter_alt_outlined,
          label: 'Filter alerts',
          onPressed: () async {
            final selected = await showModalBottomSheet<String>(
              context: context,
              builder: (context) => SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ListTile(
                      title: Text(
                        'Filter alerts',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    for (final option in const [
                      ('all', 'All alerts'),
                      ('critical', 'Critical only'),
                      ('warning', 'Warnings only'),
                    ])
                      ListTile(
                        leading: Icon(
                          option.$1 == 'critical'
                              ? Icons.error_outline
                              : option.$1 == 'warning'
                              ? Icons.warning_amber_outlined
                              : Icons.notifications_none,
                        ),
                        title: Text(option.$2),
                        trailing: _filter == option.$1
                            ? const Icon(
                                Icons.check,
                                color: FullTankColors.blue,
                              )
                            : null,
                        onTap: () => Navigator.pop(context, option.$1),
                      ),
                  ],
                ),
              ),
            );
            if (selected != null) setState(() => _filter = selected);
          },
        ),
        children: [
          _CriticalBanner(count: _alerts.where((a) => a.level < 20).length),
          if (critical.isNotEmpty) ...[
            _AlertGroupLabel(label: 'Critical', status: _TankStatus.critical),
            ...critical.map(
              (alert) => Padding(
                padding: EdgeInsets.only(bottom: 8 * _uiScale),
                child: _AlertRow(alert: alert),
              ),
            ),
            SizedBox(height: 8 * _uiScale),
          ],
          if (warning.isNotEmpty) ...[
            _AlertGroupLabel(label: 'Warning', status: _TankStatus.warning),
            ...warning.map(
              (alert) => Padding(
                padding: EdgeInsets.only(bottom: 8 * _uiScale),
                child: _AlertRow(alert: alert),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class RestockPage extends StatefulWidget {
  const RestockPage({required this.tankId, super.key});

  final String tankId;

  @override
  State<RestockPage> createState() => _RestockPageState();
}

class _RestockPageState extends State<RestockPage> {
  late final TankData _tank;
  late final TextEditingController _quantityController;
  String _priority = 'urgent';
  int _quantity = 9000;

  @override
  void initState() {
    super.initState();
    _tank = _tankForId(widget.tankId);
    _quantityController = TextEditingController(text: _quantity.toString());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _setQuantity(int value) {
    final next = value.clamp(0, _tank.capacity - _tank.current).toInt();
    setState(() {
      _quantity = next;
      _quantityController.text = next.toString();
      _quantityController.selection = TextSelection.collapsed(
        offset: _quantityController.text.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxQuantity = _tank.capacity - _tank.current;
    final delivery = switch (_priority) {
      'urgent' => 340.0,
      'standard' => 120.0,
      _ => 0.0,
    };
    final fuel = _quantity * 1.28;
    final taxes = _quantity == 9000 && _priority == 'urgent'
        ? 1884.16
        : (fuel + delivery) * .16;
    final total = fuel + delivery + taxes;
    return _withInventoryScale(
      context,
      _InventoryShell(
        title: 'Restock Request',
        subtitle: 'Order fuel replenishment',
        back: true,
        hasBottomNav: false,
        children: [
          _TargetTankCard(tank: _tank),
          SizedBox(height: 18 * _uiScale),
          _InventorySectionLabel('Priority'),
          SizedBox(height: 8 * _uiScale),
          Row(
            children: [
              Expanded(
                child: _PriorityChip(
                  id: 'urgent',
                  label: 'Urgent',
                  detail: 'ETA < 4h',
                  status: _TankStatus.critical,
                  selected: _priority == 'urgent',
                  onPressed: () => setState(() => _priority = 'urgent'),
                ),
              ),
              SizedBox(width: 8 * _uiScale),
              Expanded(
                child: _PriorityChip(
                  id: 'standard',
                  label: 'Standard',
                  detail: 'ETA 24h',
                  status: _TankStatus.warning,
                  selected: _priority == 'standard',
                  onPressed: () => setState(() => _priority = 'standard'),
                ),
              ),
              SizedBox(width: 8 * _uiScale),
              Expanded(
                child: _PriorityChip(
                  id: 'planned',
                  label: 'Planned',
                  detail: '3–5 days',
                  status: _TankStatus.optimal,
                  selected: _priority == 'planned',
                  onPressed: () => setState(() => _priority = 'planned'),
                ),
              ),
            ],
          ),
          SizedBox(height: 18 * _uiScale),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const _InventorySectionLabel('Quantity'),
              Text(
                'max ${_liters(maxQuantity)} L',
                style: const TextStyle(
                  color: FullTankColors.inkSoft,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8 * _uiScale),
          _QuantityPicker(
            controller: _quantityController,
            onChanged: (value) {
              final parsed = int.tryParse(value.replaceAll(',', '')) ?? 0;
              _quantity = parsed.clamp(0, maxQuantity).toInt();
            },
            onSubmitted: (value) => _setQuantity(
              int.tryParse(value.replaceAll(',', '')) ?? _quantity,
            ),
            onQuickPick: _setQuantity,
            maxQuantity: maxQuantity,
          ),
          SizedBox(height: 18 * _uiScale),
          const _FormInfoRow(
            icon: Icons.local_gas_station_outlined,
            label: 'Preferred supplier',
            value: 'Global Fuel Corp',
          ),
          SizedBox(height: 12 * _uiScale),
          Row(
            children: [
              const Expanded(
                child: _FormInfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Delivery date',
                  value: 'Today',
                ),
              ),
              SizedBox(width: 10 * _uiScale),
              const Expanded(
                child: _FormInfoRow(
                  icon: Icons.access_time,
                  label: 'Window',
                  value: '14:00 – 17:00',
                ),
              ),
            ],
          ),
          SizedBox(height: 12 * _uiScale),
          const _FormInfoRow(
            icon: Icons.send_outlined,
            label: 'Notes for driver',
            value: 'Gate B, ask for shift supervisor',
          ),
          SizedBox(height: 18 * _uiScale),
          _OrderSummary(
            quantity: _quantity,
            fuel: fuel,
            delivery: delivery,
            taxes: taxes,
            total: total,
          ),
          SizedBox(height: 18 * _uiScale),
          _PrimaryButton(
            label: 'Submit Request',
            onPressed: () {
              if (_quantity <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enter a quantity first.')),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Request ready to submit.')),
              );
            },
          ),
          SizedBox(height: 10 * _uiScale),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shield_outlined,
                size: 14,
                color: FullTankColors.inkSoft,
              ),
              SizedBox(width: 5),
              Text(
                'Encrypted transmission · SLA-guaranteed',
                style: TextStyle(color: FullTankColors.inkSoft, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InventoryShell extends StatelessWidget {
  const _InventoryShell({
    required this.title,
    required this.subtitle,
    required this.children,
    this.back = false,
    this.right,
    this.hasBottomNav = true,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool back;
  final Widget? right;
  final bool hasBottomNav;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              20 * _uiScale,
              4 * _uiScale,
              20 * _uiScale,
              8 * _uiScale,
            ),
            child: Row(
              children: [
                if (back) ...[
                  Semantics(
                    button: true,
                    label: 'Go back',
                    child: IconButton(
                      onPressed: () => context.go('/inventory'),
                      tooltip: 'Go back',
                      icon: const Icon(Icons.arrow_back, size: 18),
                      style: IconButton.styleFrom(
                        backgroundColor: FullTankColors.card,
                        fixedSize: Size.square(40 * _uiScale),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  SizedBox(width: 10 * _uiScale),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: FullTankColors.navy,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -.5,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: FullTankColors.inkMid,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (right != null) right!,
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20 * _uiScale,
                10 * _uiScale,
                20 * _uiScale,
                hasBottomNav ? 24 * _uiScale : 20 * _uiScale,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: hasBottomNav
        ? const FullTankBottomNav(active: 1)
        : null,
  );
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.badge,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final int? badge;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: IconButton(
      onPressed: onPressed,
      tooltip: label,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, size: 19 * _uiScale),
          if (badge != null)
            Positioned(
              right: -7,
              top: -7,
              child: Container(
                width: 15,
                height: 15,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: _red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$badge',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
      style: IconButton.styleFrom(
        backgroundColor: FullTankColors.card,
        fixedSize: Size.square(40 * _uiScale),
        padding: EdgeInsets.zero,
      ),
    ),
  );
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.count,
    required this.status,
  });

  final String label;
  final int count;
  final _TankStatus status;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: 12 * _uiScale,
      vertical: 10 * _uiScale,
    ),
    decoration: BoxDecoration(
      color: _statusSoft(status),
      borderRadius: BorderRadius.circular(8 * _uiScale),
      border: Border.all(color: _statusColor(status).withAlpha(56)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: _statusColor(status),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: .6,
          ),
        ),
        Text(
          count.toString().padLeft(2, '0'),
          style: const TextStyle(
            color: FullTankColors.navy,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -.5,
          ),
        ),
      ],
    ),
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onPressed,
    this.status,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onPressed;
  final _TankStatus? status;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(right: 6 * _uiScale),
    child: Semantics(
      button: true,
      selected: selected,
      label: '$label, $count',
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: 12 * _uiScale,
            vertical: 7 * _uiScale,
          ),
          backgroundColor: selected ? FullTankColors.navy : FullTankColors.card,
          foregroundColor: selected ? Colors.white : FullTankColors.navy,
          shape: const StadiumBorder(),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (status != null) ...[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _statusColor(status!),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 6),
            Text(
              '$count',
              style: TextStyle(
                color: selected ? Colors.white70 : FullTankColors.inkSoft,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _TankRow extends StatelessWidget {
  const _TankRow({required this.tank});

  final TankData tank;

  @override
  Widget build(BuildContext context) {
    final status = _statusFor(tank.level);
    final color = _statusColor(status);
    return Semantics(
      button: true,
      label: '${tank.name}, ${tank.level} percent, ${_statusLabel(status)}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.go('/inventory/tank/${tank.id}'),
        child: Container(
          key: ValueKey('tank-${tank.id}'),
          padding: EdgeInsets.all(14 * _uiScale),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: FullTankColors.line),
            borderRadius: BorderRadius.circular(8 * _uiScale),
          ),
          child: Row(
            children: [
              _TankIcon(status: status),
              SizedBox(width: 12 * _uiScale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tank.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: FullTankColors.navy,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          '${tank.level}%',
                          style: TextStyle(
                            color: color,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2 * _uiScale),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14 * _uiScale,
                          color: FullTankColors.inkMid,
                        ),
                        SizedBox(width: 4 * _uiScale),
                        Expanded(
                          child: Text(
                            '${tank.location} · ${tank.type}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: FullTankColors.inkMid,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8 * _uiScale),
                    Row(
                      children: [
                        Expanded(child: _LevelBar(value: tank.level / 100)),
                        SizedBox(width: 8 * _uiScale),
                        Icon(
                          Icons.wifi_tethering,
                          size: 13 * _uiScale,
                          color: status == _TankStatus.critical
                              ? color
                              : FullTankColors.inkSoft,
                        ),
                        SizedBox(width: 3 * _uiScale),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            color: status == _TankStatus.critical
                                ? color
                                : FullTankColors.inkSoft,
                            fontSize: 10,
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
        ),
      ),
    );
  }
}

class _TankIcon extends StatelessWidget {
  const _TankIcon({required this.status});
  final _TankStatus status;

  @override
  Widget build(BuildContext context) => Container(
    width: 44 * _uiScale,
    height: 44 * _uiScale,
    decoration: BoxDecoration(
      color: _statusSoft(status),
      borderRadius: BorderRadius.circular(12 * _uiScale),
    ),
    alignment: Alignment.center,
    child: Icon(
      Icons.local_gas_station_outlined,
      size: 20 * _uiScale,
      color: _statusColor(status),
    ),
  );
}

class _LevelBar extends StatelessWidget {
  const _LevelBar({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    final status = _statusFor((value * 100).round());
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        minHeight: 6 * _uiScale,
        value: value,
        backgroundColor: FullTankColors.line,
        valueColor: AlwaysStoppedAnimation(_statusColor(status)),
      ),
    );
  }
}

class _LivePill extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: 10 * _uiScale,
      vertical: 5 * _uiScale,
    ),
    decoration: BoxDecoration(
      color: _greenSoft,
      borderRadius: BorderRadius.circular(999),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 6, color: _green),
        SizedBox(width: 5),
        Text(
          'LIVE',
          style: TextStyle(
            color: _green,
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: .4,
          ),
        ),
      ],
    ),
  );
}

class _GaugeCard extends StatelessWidget {
  const _GaugeCard({required this.tank, required this.status});
  final TankData tank;
  final _TankStatus status;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.fromLTRB(
      16 * _uiScale,
      20 * _uiScale,
      16 * _uiScale,
      18 * _uiScale,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: FullTankColors.line),
      borderRadius: BorderRadius.circular(8 * _uiScale),
    ),
    child: Column(
      children: [
        SizedBox.square(
          dimension: 200 * _uiScale,
          child: CustomPaint(
            painter: _GaugePainter(
              value: tank.level / 100,
              color: _statusColor(status),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      text: '${tank.level}',
                      style: const TextStyle(
                        color: FullTankColors.navy,
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.5,
                      ),
                      children: const [
                        TextSpan(
                          text: '%',
                          style: TextStyle(
                            color: FullTankColors.inkSoft,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'CURRENT LEVEL',
                    style: TextStyle(
                      color: FullTankColors.inkMid,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: .8,
                    ),
                  ),
                  SizedBox(height: 6 * _uiScale),
                  _StatusPill(status: status),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16 * _uiScale),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _GaugeMetric(label: 'Current', value: tank.current),
            Container(
              width: 1,
              height: 36 * _uiScale,
              color: FullTankColors.line,
            ),
            _GaugeMetric(label: 'Capacity', value: tank.capacity),
          ],
        ),
      ],
    ),
  );
}

class _GaugeMetric extends StatelessWidget {
  const _GaugeMetric({required this.label, required this.value});
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: FullTankColors.inkMid,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: .5,
        ),
      ),
      Text.rich(
        TextSpan(
          text: _liters(value),
          style: const TextStyle(
            color: FullTankColors.navy,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          children: const [
            TextSpan(
              text: ' L',
              style: TextStyle(
                color: FullTankColors.inkSoft,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter({required this.value, required this.color});
  final double value;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 16 * _uiScale;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final track = Paint()
      ..color = FullTankColors.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12 * _uiScale
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12 * _uiScale
      ..strokeCap = StrokeCap.round;
    const start = 3 * 3.141592653589793 / 4;
    const sweep = 3 * 3.141592653589793 / 2;
    canvas.drawArc(rect, start, sweep, false, track);
    canvas.drawArc(rect, start, sweep * value, false, fill);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.color != color;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    this.unit,
    this.status = _TankStatus.optimal,
    this.trend,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? unit;
  final _TankStatus status;
  final String? trend;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(12 * _uiScale),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: FullTankColors.line),
      borderRadius: BorderRadius.circular(8 * _uiScale),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 30 * _uiScale,
              height: 30 * _uiScale,
              decoration: BoxDecoration(
                color: _statusSoft(status),
                borderRadius: BorderRadius.circular(8 * _uiScale),
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 18 * _uiScale,
                color: _statusColor(status),
              ),
            ),
            if (trend != null)
              Text(
                trend!,
                style: TextStyle(
                  color: _statusColor(status),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        const Spacer(),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: FullTankColors.inkMid,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            letterSpacing: .5,
          ),
        ),
        Text.rich(
          TextSpan(
            text: value,
            style: const TextStyle(
              color: FullTankColors.navy,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -.4,
            ),
            children: [
              if (unit != null)
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(
                    color: FullTankColors.inkSoft,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SensorCard extends StatelessWidget {
  const _SensorCard({required this.tank});
  final TankData tank;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(12 * _uiScale),
    decoration: BoxDecoration(
      color: FullTankColors.card,
      borderRadius: BorderRadius.circular(8 * _uiScale),
    ),
    child: Row(
      children: [
        Container(
          width: 32 * _uiScale,
          height: 32 * _uiScale,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8 * _uiScale),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.wifi_tethering, color: FullTankColors.blue),
        ),
        SizedBox(width: 10 * _uiScale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('SENSOR', style: _metaLabelStyle),
              Text(
                tank.sensor,
                style: const TextStyle(
                  color: FullTankColors.navy,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('LAST UPDATE', style: _metaLabelStyle),
            Text(
              tank.updated,
              style: const TextStyle(
                color: FullTankColors.navy,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

const _metaLabelStyle = TextStyle(
  color: FullTankColors.inkMid,
  fontSize: 10,
  fontWeight: FontWeight.w600,
  letterSpacing: .4,
);

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status, this.compact = false});
  final _TankStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: (compact ? 8 : 10) * (compact ? 1 : _uiScale),
      vertical: (compact ? 3 : 5) * (compact ? 1 : _uiScale),
    ),
    decoration: BoxDecoration(
      color: _statusSoft(status),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.circle,
          size: 6 * (compact ? 1 : _uiScale),
          color: _statusColor(status),
        ),
        SizedBox(width: 5 * (compact ? 1 : _uiScale)),
        Text(
          _statusLabel(status),
          style: TextStyle(
            color: _statusColor(status),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _InventorySectionLabel extends StatelessWidget {
  const _InventorySectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: const TextStyle(
      color: FullTankColors.inkMid,
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: .6,
    ),
  );
}

class _CriticalBanner extends StatelessWidget {
  const _CriticalBanner({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(bottom: 16 * _uiScale),
    padding: EdgeInsets.symmetric(
      horizontal: 14 * _uiScale,
      vertical: 12 * _uiScale,
    ),
    decoration: BoxDecoration(
      color: _redSoft,
      border: Border.all(color: _red.withAlpha(84)),
      borderRadius: BorderRadius.circular(8 * _uiScale),
    ),
    child: Row(
      children: [
        Container(
          width: 36 * _uiScale,
          height: 36 * _uiScale,
          decoration: BoxDecoration(
            color: _red,
            borderRadius: BorderRadius.circular(10 * _uiScale),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.warning_amber_outlined, color: Colors.white),
        ),
        SizedBox(width: 12 * _uiScale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count tanks below 20% capacity',
                style: const TextStyle(
                  color: _red,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                'Immediate restock recommended',
                style: TextStyle(color: FullTankColors.inkMid, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _AlertGroupLabel extends StatelessWidget {
  const _AlertGroupLabel({required this.label, required this.status});
  final String label;
  final _TankStatus status;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 8 * _uiScale),
    child: Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: _statusColor(status),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8 * _uiScale),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: _statusColor(status),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: .6,
          ),
        ),
        SizedBox(width: 8 * _uiScale),
        const Expanded(child: Divider(color: FullTankColors.line, height: 1)),
      ],
    ),
  );
}

class _AlertData {
  const _AlertData({
    required this.tankId,
    required this.tank,
    required this.level,
    required this.status,
    required this.location,
    required this.time,
    required this.eta,
  });
  final String tankId;
  final String tank;
  final int level;
  final _TankStatus status;
  final String location;
  final String time;
  final String eta;
}

class _AlertRow extends StatelessWidget {
  const _AlertRow({required this.alert});
  final _AlertData alert;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(alert.status);
    return Semantics(
      button: true,
      label:
          '${alert.tank}, ${alert.level} percent, ${_statusLabel(alert.status)}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.go('/inventory/tank/${alert.tankId}'),
        child: Container(
          key: ValueKey('alert-${alert.tankId}'),
          padding: EdgeInsets.all(14 * _uiScale),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: FullTankColors.line),
            borderRadius: BorderRadius.circular(8 * _uiScale),
            boxShadow: [
              BoxShadow(
                color: color,
                offset: const Offset(-3, 0),
                blurRadius: 0,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38 * _uiScale,
                height: 38 * _uiScale,
                decoration: BoxDecoration(
                  color: _statusSoft(alert.status),
                  borderRadius: BorderRadius.circular(10 * _uiScale),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.warning_amber_outlined, color: color),
              ),
              SizedBox(width: 12 * _uiScale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            alert.tank,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: FullTankColors.navy,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          '${alert.level}%',
                          style: TextStyle(
                            color: color,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3 * _uiScale),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14 * _uiScale,
                          color: FullTankColors.inkMid,
                        ),
                        SizedBox(width: 5 * _uiScale),
                        Expanded(
                          child: Text(
                            alert.location,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: FullTankColors.inkMid,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8 * _uiScale),
                    Row(
                      children: [
                        MediaQuery(
                          data: MediaQuery.of(
                            context,
                          ).copyWith(textScaler: TextScaler.noScaling),
                          child: _StatusPill(
                            status: alert.status,
                            compact: true,
                          ),
                        ),
                        SizedBox(width: 8 * _uiScale),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 13,
                                color: FullTankColors.inkSoft,
                              ),
                              SizedBox(width: 4 * _uiScale),
                              Expanded(
                                child: MediaQuery(
                                  data: MediaQuery.of(
                                    context,
                                  ).copyWith(textScaler: TextScaler.noScaling),
                                  child: Text(
                                    alert.eta,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: FullTankColors.inkSoft,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        MediaQuery(
                          data: MediaQuery.of(
                            context,
                          ).copyWith(textScaler: TextScaler.noScaling),
                          child: TextButton(
                            onPressed: () => context.go(
                              '/inventory/restock/${alert.tankId}',
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: FullTankColors.navy,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              shape: const StadiumBorder(),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Restock',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6 * _uiScale),
                    Text(
                      alert.time,
                      style: const TextStyle(
                        color: FullTankColors.inkSoft,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TargetTankCard extends StatelessWidget {
  const _TargetTankCard({required this.tank});
  final TankData tank;

  @override
  Widget build(BuildContext context) {
    final status = _statusFor(tank.level);
    return Container(
      padding: EdgeInsets.all(14 * _uiScale),
      decoration: BoxDecoration(
        color: FullTankColors.card,
        borderRadius: BorderRadius.circular(8 * _uiScale),
      ),
      child: Row(
        children: [
          _TankIcon(status: status),
          SizedBox(width: 12 * _uiScale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('TARGET TANK', style: _metaLabelStyle),
                Text(
                  tank.name,
                  style: const TextStyle(
                    color: FullTankColors.navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    _StatusPill(status: status),
                    SizedBox(width: 8 * _uiScale),
                    Text(
                      '${_liters(tank.current)} / ${_liters(tank.capacity)} L',
                      style: const TextStyle(
                        color: FullTankColors.inkMid,
                        fontSize: 11,
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

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({
    required this.id,
    required this.label,
    required this.detail,
    required this.status,
    required this.selected,
    required this.onPressed,
  });

  final String id;
  final String label;
  final String detail;
  final _TankStatus status;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Semantics(
      button: true,
      selected: selected,
      label: '$label, $detail',
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(12 * _uiScale),
          alignment: Alignment.centerLeft,
          backgroundColor: selected ? _statusSoft(status) : FullTankColors.card,
          foregroundColor: selected ? color : FullTankColors.navy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8 * _uiScale),
            side: BorderSide(
              color: selected ? color : Colors.transparent,
              width: 1.5,
            ),
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  detail,
                  style: const TextStyle(
                    color: FullTankColors.inkMid,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
            if (selected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 10),
                ),
              ),
          ],
        ),
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
    padding: EdgeInsets.all(16 * _uiScale),
    decoration: BoxDecoration(
      color: FullTankColors.card,
      borderRadius: BorderRadius.circular(8 * _uiScale),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            SizedBox(
              width: 130 * _uiScale,
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
                  color: FullTankColors.navy,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
            ),
            SizedBox(width: 6 * _uiScale),
            const Text(
              'L',
              style: TextStyle(
                color: FullTankColors.inkSoft,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 10 * _uiScale),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6 * _uiScale,
          runSpacing: 6 * _uiScale,
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
              label: 'Fill up',
              value: maxQuantity,
              onPressed: onQuickPick,
            ),
          ],
        ),
      ],
    ),
  );
}

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
