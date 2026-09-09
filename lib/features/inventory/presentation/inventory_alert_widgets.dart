part of 'inventory_page.dart';

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
                '$count tanques por debajo del 20% de capacidad',
                style: const TextStyle(
                  color: _red,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                'Se recomienda reponer de inmediato',
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
          '${alert.tank}, ${alert.level} por ciento, ${_statusLabel(alert.status)}',
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
                              'Solicitar reposición',
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
