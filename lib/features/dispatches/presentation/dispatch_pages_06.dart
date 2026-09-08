part of 'dispatch_pages.dart';

class _SelectableChoice extends StatelessWidget {
  const _SelectableChoice({
    required this.selected,
    required this.title,
    required this.detail,
    required this.icon,
    required this.onTap,
  });
  final bool selected;
  final String title, detail;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: selected ? _blue : _line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: selected ? _green : _muted, size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: const TextStyle(color: _muted, fontSize: 7.5),
                ),
              ],
            ),
          ),
          if (selected) const Icon(Icons.check_circle, color: _blue, size: 16),
        ],
      ),
    ),
  );
}

class _AssignmentSummary extends StatelessWidget {
  const _AssignmentSummary({required this.vehicle, required this.driver});
  final int vehicle, driver;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _ink,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'RESUMEN DE ASIGNACIÓN',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 7,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            _DarkRow(
              icon: Icons.inventory_2_outlined,
              label: 'PEDIDO',
              value: '#ORD-4820 · Cliente B · 8,500 L',
            ),
            const Divider(color: Colors.white24),
            _DarkRow(
              icon: Icons.local_shipping_outlined,
              label: 'VEHÍCULO',
              value:
                  '${_vehicles[vehicle].plate} · ${_vehicles[vehicle].brand} · 20k L',
            ),
            const Divider(color: Colors.white24),
            _DarkRow(
              icon: Icons.person_outline,
              label: 'CONDUCTOR',
              value: _driversData[driver].name,
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Salida estimada',
                  style: TextStyle(color: Colors.white70, fontSize: 7),
                ),
                Text(
                  'Hoy · 14:15',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

class _DarkRow extends StatelessWidget {
  const _DarkRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label, value;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: Colors.white70, size: 14),
      const SizedBox(width: 6),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 6.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 7.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _AssignmentConflict extends StatelessWidget {
  const _AssignmentConflict({required this.onChange});
  final VoidCallback onChange;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: _redSoft,
          border: Border.all(color: const Color(0xFFFFCACA)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: _red, size: 20),
            SizedBox(width: 7),
            Expanded(
              child: Text(
                'Conflicto de recursos detectado\nNo puedes continuar con la asignación actual.',
                style: TextStyle(
                  color: _red,
                  fontSize: 8,
                  height: 1.35,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 9),
      _ConflictResource(
        title: 'Vehículo TK-4421',
        detail: 'Ya asignado a #ORD-4823 · Hoy 14:00–17:00',
        onChange: onChange,
      ),
      const SizedBox(height: 7),
      _ConflictResource(
        title: 'Conductor Juan Ramírez',
        detail: 'Turno finaliza 14:00 · No disponible después',
        onChange: onChange,
      ),
      const SizedBox(height: 14),
      _OrangeButton(label: 'Volver a seleccionar', onPressed: onChange),
    ],
  );
}

class _ConflictResource extends StatelessWidget {
  const _ConflictResource({
    required this.title,
    required this.detail,
    required this.onChange,
  });
  final String title, detail;
  final VoidCallback onChange;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: Colors.white,
      border: const Border(
        left: BorderSide(color: _red, width: 2),
        top: BorderSide(color: _line),
        right: BorderSide(color: _line),
        bottom: BorderSide(color: _line),
      ),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline, color: _red, size: 17),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                detail,
                style: const TextStyle(color: _muted, fontSize: 7.5),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onChange,
          child: const Text(
            'Cambiar',
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    ),
  );
}

class _AssignmentSuccess extends StatelessWidget {
  const _AssignmentSuccess();
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 28),
      Container(
        width: 73,
        height: 73,
        decoration: BoxDecoration(
          color: _greenSoft,
          shape: BoxShape.circle,
          border: Border.all(color: _green.withAlpha(70), width: 2),
        ),
        child: const Icon(Icons.check_circle_outline, color: _green, size: 42),
      ),
      const SizedBox(height: 14),
      const Text(
        'Despacho asignado',
        style: TextStyle(
          color: _ink,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 5),
      const Text(
        '#ORD-4820 está listo para salir. Se notificó al conductor y al cliente.',
        textAlign: TextAlign.center,
        style: TextStyle(color: _muted, fontSize: 9, height: 1.4),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _panel,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          children: [
            _KeyValue(label: 'Pedido', value: '#ORD-4820'),
            _KeyValue(label: 'Vehículo', value: 'TK-4421'),
            _KeyValue(label: 'Conductor', value: 'Juan Ramírez'),
            _KeyValue(label: 'Estado', value: 'DESPACHADO'),
          ],
        ),
      ),
      const SizedBox(height: 17),
      _OrangeButton(
        label: 'Ver seguimiento',
        onPressed: () => context.go('/orders/ORD-4820'),
      ),
      TextButton(
        onPressed: () => context.go('/dispatches/assign'),
        child: const Text(
          'Asignar otro recurso',
          style: TextStyle(
            color: _blue,
            fontSize: 8,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ],
  );
}
