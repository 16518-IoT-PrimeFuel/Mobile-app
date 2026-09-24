part of 'reports_page.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({required this.variant, super.key});

  final ReportVariant variant;

  @override
  Widget build(BuildContext context) {
    const active = 3;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
          child: switch (variant) {
            ReportVariant.consumption => const _ConsumptionReport(),
            ReportVariant.sales => const _SalesReport(),
            ReportVariant.export => const _ExportReport(),
            ReportVariant.industry => const _IndustryReport(),
          },
        ),
      ),
      bottomNavigationBar: FullTankBottomNav(active: active),
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
