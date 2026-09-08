part of 'reports_page.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({required this.variant, super.key});

  final ReportVariant variant;

  @override
  Widget build(BuildContext context) {
    final active =
        variant == ReportVariant.sales || variant == ReportVariant.industry
        ? 2
        : 3;
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(_uiTextScale)),
      child: Scaffold(
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
      ),
    );
  }
}

class _ConsumptionReport extends StatelessWidget {
  const _ConsumptionReport();

  @override
  Widget build(BuildContext context) => const _ReportFrame(
    title: 'Consumo',
    subtitle: 'Uso de combustible a lo largo del tiempo',
    trailing: Icons.filter_alt_outlined,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PeriodCard(
          label: 'ÚLTIMO PERÍODO · AGO',
          value: '74.0k L',
          detail: 'Acumulado 335.000 L en el período seleccionado',
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
  const _SalesReport();

  @override
  Widget build(BuildContext context) => const _ReportFrame(
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
                value: '\$31.200',
                detail: 'K MXN',
              ),
            ),
            SizedBox(width: 6),
            Expanded(
              child: _MetricCard(
                label: 'LITROS VENDIDOS',
                value: '1,24M',
                detail: 'L',
              ),
            ),
            SizedBox(width: 6),
            Expanded(
              child: _MetricCard(label: 'PEDIDOS', value: '318', detail: ''),
            ),
          ],
        ),
        SizedBox(height: 8),
        _CurrentPeriodCard(),
        SizedBox(height: 18),
        _ChartHeading(label: 'INGRESOS MENSUALES · K MXN', trailing: ''),
        SizedBox(height: 8),
        _ChartBox(child: _SalesChart()),
      ],
    ),
  );
}

class _ExportReport extends StatelessWidget {
  const _ExportReport();

  @override
  Widget build(BuildContext context) => const _ReportFrame(
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
        _SummaryCard(),
        SizedBox(height: 12),
        _DownloadButton(),
      ],
    ),
  );
}

class _IndustryReport extends StatelessWidget {
  const _IndustryReport();

  @override
  Widget build(BuildContext context) => const _ReportFrame(
    title: 'Ventas por industria',
    subtitle: 'De dónde proviene tu volumen',
    trailing: Icons.calendar_today_outlined,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PeriodCard(
          label: 'VOLUMEN TOTAL · AGO 2026',
          value: '440.000 L',
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
          if (trailing != null)
            IconButton(
              onPressed: () {},
              icon: Icon(trailing, size: 16),
              style: IconButton.styleFrom(
                backgroundColor: FullTankColors.card,
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

class _PeriodCard extends StatelessWidget {
  const _PeriodCard({
    required this.label,
    required this.value,
    required this.detail,
  });

  final String label;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(17, 17, 17, 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Color(0x10000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: FullTankColors.inkMid,
            fontSize: 7,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: FullTankColors.navy,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          detail,
          style: const TextStyle(color: FullTankColors.inkMid, fontSize: 7.5),
        ),
      ],
    ),
  );
}
