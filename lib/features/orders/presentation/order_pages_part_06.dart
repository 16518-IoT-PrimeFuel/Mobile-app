part of 'order_pages.dart';

class _NewOrderAction extends StatelessWidget {
  const _NewOrderAction({required this.state, required this.onCreate});
  final NewOrderState state;
  final VoidCallback onCreate;
  @override
  Widget build(BuildContext context) {
    if (state == NewOrderState.success) return const SizedBox.shrink();
    final loading = state == NewOrderState.loading;
    final error = state == NewOrderState.error;
    return _OrangeButton(
      label: loading
          ? '◷  Processing...'
          : error
          ? 'Fix errors to continue  →'
          : 'Create Order  →',
      onPressed: loading
          ? null
          : error
          ? null
          : onCreate,
    );
  }
}

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({
    this.initialState = SalesReportState.dashboard,
    super.key,
  });
  final SalesReportState initialState;
  @override
  State<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  late SalesReportState _state = widget.initialState;
  @override
  Widget build(BuildContext context) {
    final dashboard = _state == SalesReportState.dashboard;
    final generating = _state == SalesReportState.generating;
    final ready = _state == SalesReportState.ready;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ready)
                Align(
                  alignment: Alignment.topRight,
                  child: _HeaderIcon(
                    icon: Icons.close,
                    label: 'Cerrar reporte',
                    onTap: () =>
                        setState(() => _state = SalesReportState.dashboard),
                  ),
                )
              else
                _Header(
                  title: generating
                      ? 'Generando reporte'
                      : 'Reportes de ventas',
                  subtitle: generating
                      ? 'Compilando 30 días...'
                      : _state == SalesReportState.empty
                      ? 'Sin datos en el rango'
                      : 'Análisis de operaciones',
                  actions: [
                    _HeaderIcon(
                      icon: dashboard
                          ? Icons.download_outlined
                          : Icons.more_horiz,
                      label: dashboard ? 'Exportar' : 'Opciones',
                      onTap: () {},
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              if (dashboard)
                const _SalesDashboard()
              else if (generating)
                const _SalesGenerating()
              else if (ready)
                const _SalesReady()
              else
                const _SalesEmpty(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: _SalesAction(
            state: _state,
            onGenerate: _generate,
            onReset: () => setState(() => _state = SalesReportState.dashboard),
          ),
        ),
      ),
    );
  }

  void _generate() {
    setState(() => _state = SalesReportState.generating);
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _state = SalesReportState.ready);
    });
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.subtitle,
    required this.actions,
  });
  final String title, subtitle;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Semantics(
        button: true,
        label: 'Volver',
        child: IconButton(
          onPressed: () {
            final navigator = Navigator.maybeOf(context);
            if (navigator?.canPop() ?? false) {
              navigator!.pop();
            } else {
              context.go('/home');
            }
          },
          tooltip: 'Volver',
          icon: const Icon(Icons.arrow_back, size: 17),
          style: IconButton.styleFrom(
            backgroundColor: _panel,
            fixedSize: const Size(32, 32),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _ink,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: -.2,
              ),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _muted, fontSize: 9),
              ),
          ],
        ),
      ),
      const SizedBox(width: 5),
      ...actions,
    ],
  );
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4),
    child: Semantics(
      button: true,
      label: label,
      child: IconButton(
        onPressed: onTap,
        tooltip: label,
        icon: Icon(icon, size: 14, color: _muted),
        style: IconButton.styleFrom(
          backgroundColor: _panel,
          fixedSize: const Size(32, 32),
          padding: EdgeInsets.zero,
        ),
      ),
    ),
  );
}

