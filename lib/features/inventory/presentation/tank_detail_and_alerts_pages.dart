part of 'inventory_page.dart';

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
          _InventorySectionLabel('Telemetría en tiempo real'),
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
                label: 'Temperatura',
                value: '24.3',
                unit: '°C',
              ),
              _MetricCard(
                icon: Icons.speed_outlined,
                label: 'Presión',
                value: '1.02',
                unit: 'atm',
                trend: '+0.4%',
              ),
              _MetricCard(
                icon: Icons.water_drop_outlined,
                label: 'Flujo',
                value: '0.8',
                unit: 'L/h salida',
                status: _TankStatus.warning,
              ),
              _MetricCard(
                icon: Icons.access_time,
                label: 'Tiempo al vacío',
                value: '~4h',
                status: _TankStatus.critical,
              ),
            ],
          ),
          SizedBox(height: 14 * _uiScale),
          _SensorCard(tank: tank),
          SizedBox(height: 14 * _uiScale),
          _PrimaryButton(
            label: 'Solicitar reposición',
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
      tank: 'Tanque diésel A-102',
      level: 12,
      status: _TankStatus.critical,
      location: 'Patio norte · Sector 4',
      time: 'hace 2 min',
      eta: '~4 h hasta agotarse',
    ),
    _AlertData(
      tankId: 'G-11',
      tank: 'Propano G-11',
      level: 18,
      status: _TankStatus.critical,
      location: 'Sector 6',
      time: 'hace 5 min',
      eta: '~7 h hasta agotarse',
    ),
    _AlertData(
      tankId: 'C-12',
      tank: 'Tanque de lubricante C-12',
      level: 35,
      status: _TankStatus.warning,
      location: 'Sector 9',
      time: 'hace 12 min',
      eta: '~2 días',
    ),
    _AlertData(
      tankId: 'B-07',
      tank: 'Refrigerante B-07',
      level: 28,
      status: _TankStatus.warning,
      location: 'Sector 1',
      time: 'hace 18 min',
      eta: '~1.5 días',
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
        title: 'Alertas',
        subtitle: '4 activas · 2 críticas',
        back: true,
        right: _HeaderIconButton(
          icon: Icons.filter_alt_outlined,
          label: 'Filtrar alertas',
          onPressed: () async {
            final selected = await showModalBottomSheet<String>(
              context: context,
              builder: (context) => SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ListTile(
                      title: Text(
                        'Filtrar alertas',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    for (final option in const [
                      ('all', 'Todas las alertas'),
                      ('critical', 'Solo críticas'),
                      ('warning', 'Solo advertencias'),
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
            _AlertGroupLabel(label: 'Críticas', status: _TankStatus.critical),
            ...critical.map(
              (alert) => Padding(
                padding: EdgeInsets.only(bottom: 8 * _uiScale),
                child: _AlertRow(alert: alert),
              ),
            ),
            SizedBox(height: 8 * _uiScale),
          ],
          if (warning.isNotEmpty) ...[
            _AlertGroupLabel(
              label: 'Advertencias',
              status: _TankStatus.warning,
            ),
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
