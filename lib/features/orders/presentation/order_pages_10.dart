part of 'order_pages.dart';

class _SalesEmpty extends StatelessWidget {
  const _SalesEmpty();
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 35),
      const _EmptyIllustration(icon: Icons.bar_chart_outlined, color: _blue),
      const SizedBox(height: 14),
      const Text(
        'No existen ventas\nen este período',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _ink,
          fontSize: 16,
          height: 1.1,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        'Ajusta el rango de fechas o los filtros para\nver datos históricos. También puedes\niniciar operaciones nuevas para poblar el\nreporte.',
        textAlign: TextAlign.center,
        style: TextStyle(color: _muted, fontSize: 9, height: 1.45),
      ),
      const SizedBox(height: 15),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: _panel,
          borderRadius: BorderRadius.circular(9),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RANGO',
                  style: TextStyle(
                    color: _subtle,
                    fontSize: 6,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Ago 01',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'HASTA',
                  style: TextStyle(
                    color: _subtle,
                    fontSize: 6,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Ago 07',
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
      ),
    ],
  );
}

class _SalesAction extends StatelessWidget {
  const _SalesAction({
    required this.state,
    required this.onGenerate,
    required this.onReset,
  });
  final SalesReportState state;
  final VoidCallback onGenerate;
  final VoidCallback onReset;
  @override
  Widget build(BuildContext context) {
    if (state == SalesReportState.ready)
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: _OrangeButton(
              label: '⌄  Download PDF',
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reporte listo para descargar')),
              ),
            ),
          ),
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Compartir por email estará disponible al conectar el correo',
                ),
              ),
            ),
            child: const Text(
              'Compartir por email',
              style: TextStyle(color: _muted, fontSize: 8),
            ),
          ),
        ],
      );
    if (state == SalesReportState.empty)
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: _OrangeButton(
              label: '◷  Cambiar rango de fechas',
              onPressed: onReset,
            ),
          ),
          TextButton(
            onPressed: onReset,
            child: const Text(
              'Restablecer filtros',
              style: TextStyle(color: _muted, fontSize: 8),
            ),
          ),
        ],
      );
    return SizedBox(
      width: double.infinity,
      child: _OrangeButton(
        label: state == SalesReportState.generating
            ? '◷  Generando reporte...'
            : '▥  Generate Report  →',
        onPressed: state == SalesReportState.generating ? null : onGenerate,
      ),
    );
  }
}

class _OrangeButton extends StatelessWidget {
  const _OrangeButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: _orange,
      disabledBackgroundColor: const Color(0xFFFFD0A7),
      foregroundColor: _ink,
      disabledForegroundColor: Colors.white,
      minimumSize: const Size.fromHeight(34),
      shape: const StadiumBorder(),
      elevation: 2,
      textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
    ),
    child: Text(label),
  );
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 11),
    label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    style: OutlinedButton.styleFrom(
      foregroundColor: _ink,
      side: const BorderSide(color: _line),
      padding: const EdgeInsets.symmetric(vertical: 8),
      textStyle: const TextStyle(fontSize: 7, fontWeight: FontWeight.w700),
    ),
  );
}

class _DarkButton extends StatelessWidget {
  const _DarkButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: _ink,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      textStyle: const TextStyle(fontSize: 7, fontWeight: FontWeight.w700),
    ),
    child: Text(label),
  );
}

class _LightButton extends StatelessWidget {
  const _LightButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onTap,
    child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    style: OutlinedButton.styleFrom(
      foregroundColor: _blue,
      side: const BorderSide(color: Color(0xFFBCD4FF)),
      padding: const EdgeInsets.symmetric(vertical: 11),
      textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
    ),
  );
}
