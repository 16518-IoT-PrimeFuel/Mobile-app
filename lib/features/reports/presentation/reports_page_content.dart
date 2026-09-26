part of 'reports_page.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({required this.variant, super.key});

  final ReportVariant variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const active = 3;
    final summary = ref.watch(reportsControllerProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
          child: summary.when(
            loading: () =>
                _ReportState(variant: variant, state: _ReportStateType.loading),
            error: (_, __) =>
                _ReportState(variant: variant, state: _ReportStateType.error),
            data: (data) =>
                data.revenue == 0 && data.liters == 0 && data.orders == 0
                ? _ReportState(variant: variant, state: _ReportStateType.empty)
                : _ReportContent(variant: variant, summary: data),
          ),
        ),
      ),
      bottomNavigationBar: FullTankBottomNav(active: active),
    );
  }
}

enum _ReportStateType { loading, empty, error }

class _ReportContent extends StatelessWidget {
  const _ReportContent({required this.variant, required this.summary});

  final ReportVariant variant;
  final ReportSummary summary;

  @override
  Widget build(BuildContext context) => switch (variant) {
    ReportVariant.consumption => _ConsumptionReport(summary: summary),
    ReportVariant.sales => _SalesReport(summary: summary),
    ReportVariant.export => _ExportReport(summary: summary),
    ReportVariant.industry => _IndustryReport(summary: summary),
  };
}

class _ReportState extends StatelessWidget {
  const _ReportState({required this.variant, required this.state});

  final ReportVariant variant;
  final _ReportStateType state;

  @override
  Widget build(BuildContext context) => _ReportFrame(
    title: switch (variant) {
      ReportVariant.consumption => 'Consumo',
      ReportVariant.sales => 'Ventas',
      ReportVariant.export => 'Exportar reporte',
      ReportVariant.industry => 'Ventas por industria',
    },
    subtitle: switch (state) {
      _ReportStateType.loading => 'Cargando información…',
      _ReportStateType.empty => 'Aún no hay datos para mostrar',
      _ReportStateType.error => 'No pudimos cargar este reporte',
    },
    child: SizedBox(
      width: double.infinity,
      height: 180,
      child: Center(
        child: state == _ReportStateType.loading
            ? const CircularProgressIndicator()
            : Text(
                state == _ReportStateType.empty
                    ? 'Completa operaciones para generar métricas.'
                    : 'Intenta nuevamente más tarde.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF4A5568)),
              ),
      ),
    ),
  );
}

class _ConsumptionReport extends StatelessWidget {
  const _ConsumptionReport({required this.summary});

  final ReportSummary summary;

  @override
  Widget build(BuildContext context) => _ReportFrame(
    title: 'Consumo',
    subtitle: 'Uso de combustible a lo largo del tiempo',
    trailing: Icons.filter_alt_outlined,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PeriodCard(
          label: 'ÚLTIMO PERÍODO · AGO',
          value: _liters(summary.liters),
          detail: 'Volumen acumulado en el período seleccionado',
        ),
        SizedBox(height: 8),
        _Segmented(items: ['Mensual', 'Trimestral']),
        SizedBox(height: 18),
        _ChartHeading(label: 'VOLUMEN · LITROS', trailing: 'Últimos 6 meses'),
        SizedBox(height: 8),
        _ChartBox(child: _ConsumptionChart()),
      ],
    ),
  );
}

class _SalesReport extends StatelessWidget {
  const _SalesReport({required this.summary});

  final ReportSummary summary;

  @override
  Widget build(BuildContext context) => _ReportFrame(
    title: 'Ventas',
    subtitle: 'Rendimiento vs. período anterior',
    trailing: Icons.calendar_today_outlined,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'INGRESOS',
                value: _currency(summary.revenue),
                detail: 'K MXN',
              ),
            ),
            SizedBox(width: 6),
            Expanded(
              child: _MetricCard(
                label: 'LITROS VENDIDOS',
                value: _liters(summary.liters),
                detail: 'L',
              ),
            ),
            SizedBox(width: 6),
            Expanded(
              child: _MetricCard(
                label: 'PEDIDOS',
                value: '${summary.orders}',
                detail: '',
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        _CurrentPeriodCard(revenue: summary.revenue),
        SizedBox(height: 18),
        _ChartHeading(label: 'INGRESOS MENSUALES · K MXN', trailing: ''),
        SizedBox(height: 8),
        _ChartBox(child: _SalesChart()),
      ],
    ),
  );
}

class _ExportReport extends StatelessWidget {
  const _ExportReport({required this.summary});

  final ReportSummary summary;

  @override
  Widget build(BuildContext context) => _ReportFrame(
    title: 'Exportar reporte',
    subtitle: 'Resumen operacional como PDF',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel('PERÍODO'),
        _SelectField('AGO 2026'),
        SizedBox(height: 12),
        _FieldLabel('TIPO DE REPORTE'),
        _Segmented(items: ['Pedidos', 'Ventas', 'Consumo'], selected: 1),
        SizedBox(height: 12),
        _FieldLabel('RESUMEN GENERADO'),
        _SummaryCard(summary: summary),
        SizedBox(height: 12),
        _DownloadButton(),
      ],
    ),
  );
}

class _IndustryReport extends StatelessWidget {
  const _IndustryReport({required this.summary});

  final ReportSummary summary;

  @override
  Widget build(BuildContext context) => _ReportFrame(
    title: 'Ventas por industria',
    subtitle: 'De dónde proviene tu volumen',
    trailing: Icons.calendar_today_outlined,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PeriodCard(
          label: 'VOLUMEN TOTAL · AGO 2026',
          value: _liters(summary.liters),
          detail: 'Distribuido entre 4 sectores',
        ),
        SizedBox(height: 18),
        _ChartHeading(label: 'DISTRIBUCIÓN', trailing: ''),
        SizedBox(height: 8),
        _IndustryRows(),
      ],
    ),
  );
}

String _currency(double value) => '\$${value.toStringAsFixed(0)}';

String _liters(double value) => value >= 1000000
    ? '${(value / 1000000).toStringAsFixed(2)}M L'
    : '${value.toStringAsFixed(0)} L';

class _ReportFrame extends StatelessWidget {
  const _ReportFrame({
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final IconData? trailing;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, size: 18),
            style: IconButton.styleFrom(
              backgroundColor: Color(0xFFF3F4F6),
              fixedSize: const Size(47, 47),
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1A202C),
                    fontSize: 27.55,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.5,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF4A5568),
                    fontSize: 13.775,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null)
            IconButton(
              onPressed: () {},
              icon: Icon(trailing, size: 16),
              style: IconButton.styleFrom(
                backgroundColor: Color(0xFFF3F4F6),
                fixedSize: const Size(42, 42),
                padding: EdgeInsets.zero,
              ),
            ),
        ],
      ),
      const SizedBox(height: 20),
      child,
    ],
  );
}
