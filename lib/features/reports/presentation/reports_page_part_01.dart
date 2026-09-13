part of 'reports_page.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({required this.variant, super.key});

  final ReportVariant variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(reportsControllerProvider);
    final active =
        variant == ReportVariant.sales || variant == ReportVariant.industry
        ? 2
        : 3;
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: const TextScaler.linear(_uiTextScale)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
            child: switch (variant) {
              ReportVariant.consumption => report.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) =>
                    Text('No se pudo cargar el reporte: $error'),
                data: (summary) => _ConsumptionReport(summary: summary),
              ),
              ReportVariant.sales => report.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) =>
                    Text('No se pudo cargar el reporte: $error'),
                data: (summary) => _SalesReport(summary: summary),
              ),
              ReportVariant.export => report.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) =>
                    Text('No se pudo cargar el reporte: $error'),
                data: (summary) => _ExportReport(summary: summary),
              ),
              ReportVariant.industry => report.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) =>
                    Text('No se pudo cargar el reporte: $error'),
                data: (summary) => _IndustryReport(summary: summary),
              ),
            },
          ),
        ),
        bottomNavigationBar: FullTankBottomNav(active: active),
      ),
    );
  }
}

class _ConsumptionReport extends StatelessWidget {
  const _ConsumptionReport({required this.summary});
  final ReportSummary summary;

  @override
  Widget build(BuildContext context) => _ReportFrame(
    title: 'Consumo',
    subtitle: 'Uso de combustible a lo largo del tiempo',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PeriodCard(
          label: 'VOLUMEN TOTAL',
          value: '${summary.liters.toStringAsFixed(0)} L',
          detail: '${summary.orders} pedidos en total',
        ),
        SizedBox(height: 18),
        _ChartHeading(label: 'VOLUMEN MENSUAL', trailing: ''),
        const SizedBox(height: 8),
        const Text('El backend aún no ofrece litros agrupados por mes.'),
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
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'INGRESOS',
                value: 'S/ ${summary.revenue.toStringAsFixed(2)}',
                detail: 'S/',
              ),
            ),
            SizedBox(width: 6),
            Expanded(
              child: _MetricCard(
                label: 'LITROS VENDIDOS',
                value: summary.liters.toStringAsFixed(0),
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
        SizedBox(height: 18),
        _ChartHeading(label: 'INGRESOS MENSUALES · S/', trailing: ''),
        SizedBox(height: 8),
        _ChartBox(child: _SalesChart(monthly: summary.monthly)),
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
    subtitle: 'Resumen operacional del backend',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SummaryCard(summary: summary),
        SizedBox(height: 12),
        _DownloadButton(summary: summary),
      ],
    ),
  );
}

class _IndustryReport extends StatelessWidget {
  const _IndustryReport({required this.summary});
  final ReportSummary summary;

  @override
  Widget build(BuildContext context) => _ReportFrame(
    title: 'Resumen de actividad',
    subtitle: 'Volumen y pedidos registrados',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PeriodCard(
          label: 'VOLUMEN TOTAL',
          value: '${summary.liters.toStringAsFixed(0)} L',
          detail: '${summary.orders} pedidos registrados',
        ),
        SizedBox(height: 18),
        _ChartHeading(label: 'DISTRIBUCIÓN', trailing: ''),
        SizedBox(height: 8),
        _PeriodCard(
          label: 'INGRESOS',
          value: 'S/ ${summary.revenue.toStringAsFixed(2)}',
          detail: 'Total acumulado',
        ),
      ],
    ),
  );
}

class _ReportFrame extends StatelessWidget {
  const _ReportFrame({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

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
              backgroundColor: FullTankColors.card,
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
                    color: FullTankColors.navy,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.5,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: FullTankColors.inkMid,
                    fontSize: 9.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      child,
    ],
  );
}
