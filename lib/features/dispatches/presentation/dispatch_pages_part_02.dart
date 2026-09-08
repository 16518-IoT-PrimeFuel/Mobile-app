part of 'dispatch_pages.dart';

class _AvailabilityConflict extends StatelessWidget {
  const _AvailabilityConflict({required this.onRefresh});
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 17),
      const Icon(Icons.warning_amber_rounded, color: _red, size: 42),
      const SizedBox(height: 10),
      const Text(
        'Conflicto de disponibilidad',
        style: TextStyle(
          color: _ink,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 5),
      const Text(
        'TK-4421 acaba de ser asignada a otro pedido. Actualiza para ver recursos en tiempo real.',
        textAlign: TextAlign.center,
        style: TextStyle(color: _muted, fontSize: 9, height: 1.4),
      ),
      const SizedBox(height: 18),
      _OrangeButton(label: 'Actualizar disponibilidad', onPressed: onRefresh),
    ],
  );
}

class _LiveConflictBanner extends StatelessWidget {
  const _LiveConflictBanner({required this.onRefresh});
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: _amberSoft,
      border: Border.all(color: const Color(0xFFFDE4A7)),
    ),
    child: Row(
      children: [
        const Icon(Icons.warning_amber_rounded, color: _amber, size: 20),
        const SizedBox(width: 7),
        const Expanded(
          child: Text(
            'TK-3812 acaba de ser asignada a otro pedido. Actualiza disponibilidad.',
            style: TextStyle(
              color: _ink,
              fontSize: 8,
              height: 1.25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: onRefresh,
          child: const Text(
            'Actualizar',
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    ),
  );
}

class _FilterSummary extends StatelessWidget {
  const _FilterSummary({
    required this.capacity,
    required this.availableOnly,
    required this.onTap,
  });
  final int capacity;
  final bool availableOnly;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Expanded(
            child: _Info(
              label: 'FECHA',
              value: 'Hoy · 05 sep',
              icon: Icons.calendar_today_outlined,
            ),
          ),
          const Expanded(
            child: _Info(
              label: 'HORA',
              value: '14:00–18:00',
              icon: Icons.schedule_outlined,
            ),
          ),
          Expanded(
            child: _Info(
              label: 'CAPACIDAD',
              value: '≥ ${capacity.toStringAsFixed(0)} L',
              icon: Icons.water_drop_outlined,
            ),
          ),
          if (availableOnly)
            const Icon(Icons.filter_alt, color: _blue, size: 14),
        ],
      ),
    ),
  );
}

class _Info extends StatelessWidget {
  const _Info({required this.label, required this.value, required this.icon});
  final String label, value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, size: 10, color: _muted),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              color: _muted,
              fontSize: 6.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      const SizedBox(height: 3),
      Text(
        value,
        style: const TextStyle(
          color: _ink,
          fontSize: 8,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.selected = false, this.color});
  final String label;
  final bool selected;
  final Color? color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: selected ? _ink : _panel,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!selected)
          Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: color ?? _muted,
              shape: BoxShape.circle,
            ),
          ),
        Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : _muted,
            fontSize: 7.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}
