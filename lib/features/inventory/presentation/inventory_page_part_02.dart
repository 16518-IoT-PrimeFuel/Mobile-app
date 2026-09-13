part of 'inventory_page.dart';

_AlertData _alertFromEquipment(TankData tank) => _AlertData(
  tankId: tank.routeId,
  tank: tank.name,
  level: tank.level,
  status: _statusFor(tank.level),
  location: tank.location,
  time: '—',
  eta: '—',
);

class TankDetailPage extends ConsumerWidget {
  const TankDetailPage({required this.tankId, super.key});

  final String tankId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(inventoryEquipmentProvider)
      .when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, _) => Scaffold(
          body: Center(child: Text('No se pudo cargar el equipo: $error')),
        ),
        data: (equipment) {
          TankData? tank;
          for (final item in equipment) {
            if ('${item.id}' == tankId) {
              tank = _tankFromEquipment(item);
              break;
            }
          }
          return _build(context, tank ?? _tankForId(tankId));
        },
      );

  Widget _build(BuildContext context, TankData tank) {
    final status = _statusFor(tank.level);
    return _withInventoryScale(
      context,
      _InventoryShell(
        title: tank.id,
        subtitle: tank.type,
        back: true,
        right: _StatusPill(status: status),
        children: [
          _GaugeCard(tank: tank, status: status),
          _InventorySectionLabel('Inventory level'),
          SizedBox(height: 8 * _uiScale),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8 * _uiScale,
            mainAxisSpacing: 8 * _uiScale,
            childAspectRatio: 1.7,
            children: [
              _MetricCard(
                icon: Icons.water_drop_outlined,
                label: 'Current',
                value: _liters(tank.current),
                unit: 'L',
                status: status,
              ),
              _MetricCard(
                icon: Icons.storage_outlined,
                label: 'Capacity',
                value: _liters(tank.capacity),
                unit: 'L',
              ),
            ],
          ),
          SizedBox(height: 10 * _uiScale),
          _TankInfoCard(tank: tank),
          SizedBox(height: 14 * _uiScale),
          _PrimaryButton(
            label: 'Request Restock',
            onPressed: () =>
                context.go('/orders/new?equipmentId=${tank.routeId}'),
          ),
        ],
      ),
    );
  }
}

class InventoryAlertsPage extends ConsumerStatefulWidget {
  const InventoryAlertsPage({super.key});

  @override
  ConsumerState<InventoryAlertsPage> createState() =>
      _InventoryAlertsPageState();
}

class _InventoryAlertsPageState extends ConsumerState<InventoryAlertsPage> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) => ref
      .watch(inventoryEquipmentProvider)
      .when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, _) => Scaffold(
          body: Center(child: Text('No se pudo cargar el inventario: $error')),
        ),
        data: (items) => _buildAlerts(
          context,
          items
              .map((item) => _alertFromEquipment(_tankFromEquipment(item)))
              .where((alert) => alert.level < 40)
              .toList(),
        ),
      );

  Widget _buildAlerts(BuildContext context, List<_AlertData> alerts) {
    final visible = alerts.where((alert) {
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
        subtitle:
            '${alerts.length} active · ${alerts.where((a) => a.level < 20).length} critical',
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
          _CriticalBanner(count: alerts.where((a) => a.level < 20).length),
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
