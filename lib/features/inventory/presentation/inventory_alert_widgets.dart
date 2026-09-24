part of 'inventory_page.dart';

class _InventorySectionLabel extends StatelessWidget {
  const _InventorySectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: const TextStyle(
      color: Color(0xFF4A5568),
      fontSize: 15.95,
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
    margin: EdgeInsets.only(bottom: 23.2),
    padding: EdgeInsets.symmetric(horizontal: 20.3, vertical: 17.4),
    decoration: BoxDecoration(
      color: _redSoft,
      border: Border.all(color: _red.withAlpha(84)),
      borderRadius: BorderRadius.circular(11.6),
    ),
    child: Row(
      children: [
        Container(
          width: 52.2,
          height: 52.2,
          decoration: BoxDecoration(
            color: _red,
            borderRadius: BorderRadius.circular(14.5),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.warning_amber_outlined, color: Colors.white),
        ),
        SizedBox(width: 17.4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count tanques por debajo del 20% de capacidad',
                style: const TextStyle(
                  color: _red,
                  fontSize: 18.85,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                'Se recomienda reponer de inmediato',
                style: TextStyle(color: Color(0xFF4A5568), fontSize: 15.95),
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
    padding: EdgeInsets.only(bottom: 11.6),
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
        SizedBox(width: 11.6),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: _statusColor(status),
            fontSize: 15.95,
            fontWeight: FontWeight.w700,
            letterSpacing: .6,
          ),
        ),
        SizedBox(width: 11.6),
        const Expanded(child: Divider(color: Color(0xFFE2E8F0), height: 1)),
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
          padding: EdgeInsets.all(20.3),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(11.6),
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
                width: 55.1,
                height: 55.1,
                decoration: BoxDecoration(
                  color: _statusSoft(alert.status),
                  borderRadius: BorderRadius.circular(14.5),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.warning_amber_outlined, color: color),
              ),
              SizedBox(width: 17.4),
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
                              color: Color(0xFF1A202C),
                              fontSize: 18.85,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          '${alert.level}%',
                          style: TextStyle(
                            color: color,
                            fontSize: 18.85,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.35),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 20.3,
                          color: Color(0xFF4A5568),
                        ),
                        SizedBox(width: 7.25),
                        Expanded(
                          child: Text(
                            alert.location,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF4A5568),
                              fontSize: 15.95,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 11.6),
                    Row(
                      children: [
                        _StatusPill(status: alert.status, compact: true),
                        SizedBox(width: 11.6),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 13,
                                color: Color(0xFF94A3B8),
                              ),
                              SizedBox(width: 5.8),
                              Expanded(
                                child: Text(
                                  alert.eta,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              context.go('/inventory/restock/${alert.tankId}'),
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF1A202C),
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
                      ],
                    ),
                    SizedBox(height: 8.7),
                    Text(
                      alert.time,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14.5,
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
