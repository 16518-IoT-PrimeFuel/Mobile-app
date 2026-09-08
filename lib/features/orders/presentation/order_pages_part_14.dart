part of 'order_pages.dart';

class _SalesGenerating extends StatelessWidget {
  const _SalesGenerating();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: _blueSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.analytics_outlined,
                    color: _blue,
                    size: 15,
                  ),
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Compilando datos',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '24 pedidos · 18 clientes · 42.8k L',
                      style: TextStyle(color: _muted, fontSize: 7),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: const LinearProgressIndicator(
                value: .68,
                minHeight: 4,
                color: _orange,
                backgroundColor: _line,
              ),
            ),
            const SizedBox(height: 5),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '68% completado',
                  style: TextStyle(color: _muted, fontSize: 7),
                ),
                Text(
                  '~12s restantes',
                  style: TextStyle(color: _muted, fontSize: 7),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PROGRESO',
              style: TextStyle(
                color: _subtle,
                fontSize: 7,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            const _CheckRow(label: 'Consultando ventas', done: true),
            const _CheckRow(label: 'Agrupando por cliente', done: true),
            const _CheckRow(
              label: 'Calculando totales y márgenes',
              active: true,
            ),
            const _CheckRow(label: 'Generando gráficos'),
            const _CheckRow(label: 'Compilando PDF final'),
          ],
        ),
      ),
    ],
  );
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.label,
    this.done = false,
    this.active = false,
  });
  final String label;
  final bool done, active;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: done
                ? _greenSoft
                : active
                ? _blueSoft
                : _panel,
            shape: BoxShape.circle,
          ),
          child: Icon(
            done ? Icons.check : Icons.circle,
            size: done ? 9 : 5,
            color: done
                ? _green
                : active
                ? _blue
                : _subtle,
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: TextStyle(
            color: active ? _ink : _muted,
            fontSize: 8,
            fontWeight: active ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

class _SalesReady extends StatelessWidget {
  const _SalesReady();
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 20),
      Container(
        width: 67,
        height: 67,
        decoration: const BoxDecoration(
          color: _greenSoft,
          shape: BoxShape.circle,
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: _green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 28),
        ),
      ),
      const SizedBox(height: 14),
      const Text(
        'Reporte listo',
        style: TextStyle(
          color: _ink,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 5),
      const Text(
        'Generamos el reporte completo con\nmétricas, gráficos y desglose por cliente.',
        textAlign: TextAlign.center,
        style: TextStyle(color: _muted, fontSize: 9, height: 1.4),
      ),
      const SizedBox(height: 15),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.picture_as_pdf_outlined,
                  color: _red,
                  size: 18,
                ),
                const SizedBox(width: 7),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reporte_Ventas_Ago_Sep_202...',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _ink,
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '2.4 MB · 24 páginas · Generado hoy',
                        style: TextStyle(color: _muted, fontSize: 7),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz, size: 13, color: _muted),
              ],
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const _StatusTag('Listo', color: _green),
                const SizedBox(width: 5),
                const _StatusTag('Encriptado', color: _blue),
              ],
            ),
            const Divider(height: 14, color: _line),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'VENTAS',
                      style: TextStyle(color: _subtle, fontSize: 6),
                    ),
                    Text(
                      'S/148.3k',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'PEDIDOS',
                      style: TextStyle(color: _subtle, fontSize: 6),
                    ),
                    Text(
                      '24',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'CLIENTES',
                      style: TextStyle(color: _subtle, fontSize: 6),
                    ),
                    Text(
                      '18',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

