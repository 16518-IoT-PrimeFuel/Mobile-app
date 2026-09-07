import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/fulltank_theme.dart';
import '../../home/presentation/home_page.dart';

enum ReportVariant { consumption, sales, export, industry }

const _uiTextScale = 1.3;

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
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: const TextScaler.linear(_uiTextScale)),
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

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.detail,
  });

  final String label;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) => Container(
    height: 86,
    padding: const EdgeInsets.fromLTRB(13, 13, 7, 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: FullTankColors.inkMid,
            fontSize: 6,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: FullTankColors.navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              detail,
              style: const TextStyle(color: FullTankColors.inkMid, fontSize: 6),
            ),
          ],
        ),
      ],
    ),
  );
}

class _CurrentPeriodCard extends StatelessWidget {
  const _CurrentPeriodCard();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      boxShadow: const [
        BoxShadow(
          color: Color(0x10000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PERÍODO ACTUAL',
          style: TextStyle(
            color: FullTankColors.inkMid,
            fontSize: 7,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Text(
              '\$31.200',
              style: TextStyle(
                color: FullTankColors.navy,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              ' K',
              style: TextStyle(color: FullTankColors.inkMid, fontSize: 8),
            ),
            SizedBox(width: 10),
            _DeltaBadge('+16%'),
          ],
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'vs. anterior',
              style: TextStyle(color: FullTankColors.inkMid, fontSize: 7.5),
            ),
            Text(
              '\$27.000K',
              style: TextStyle(
                color: FullTankColors.navyMid,
                fontSize: 7.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _Segmented extends StatelessWidget {
  const _Segmented({required this.items, this.selected = 0});

  final List<String> items;
  final int selected;

  @override
  Widget build(BuildContext context) => Container(
    height: 38,
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: FullTankColors.card,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      children: List.generate(
        items.length,
        (index) => Expanded(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: index == selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(99),
              boxShadow: index == selected
                  ? const [BoxShadow(color: Color(0x10000000), blurRadius: 3)]
                  : null,
            ),
            child: Text(
              items[index],
              style: TextStyle(
                color: FullTankColors.navyMid,
                fontSize: 8,
                fontWeight: index == selected
                    ? FontWeight.w800
                    : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _ChartHeading extends StatelessWidget {
  const _ChartHeading({required this.label, required this.trailing});

  final String label;
  final String trailing;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: FullTankColors.inkMid,
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
      if (trailing.isNotEmpty)
        Row(
          children: [
            const Icon(Icons.remove, color: FullTankColors.blue, size: 13),
            const SizedBox(width: 4),
            Text(
              trailing,
              style: const TextStyle(color: FullTankColors.inkMid, fontSize: 7),
            ),
          ],
        ),
    ],
  );
}

class _ChartBox extends StatelessWidget {
  const _ChartBox({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    height: 255,
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(13, 17, 13, 10),
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
    child: child,
  );
}

class _ConsumptionChart extends StatelessWidget {
  const _ConsumptionChart();
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _LineChartPainter(), child: const SizedBox.expand());
}

class _SalesChart extends StatelessWidget {
  const _SalesChart();
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _BarChartPainter(), child: const SizedBox.expand());
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final left = size.width * .1;
    final right = size.width * .97;
    final top = size.height * .16;
    final bottom = size.height * .76;
    final step = (right - left) / 5;
    final values = [.62, .38, .5, .25, .36, .08];
    final points = [
      for (var i = 0; i < values.length; i++)
        Offset(left + i * step, top + values[i] * (bottom - top)),
    ];
    final grid = Paint()
      ..color = FullTankColors.line
      ..strokeWidth = 1;
    for (final y in [top, (top + bottom) / 2, bottom])
      canvas.drawLine(Offset(left, y), Offset(right, y), grid);
    final area = Path()..moveTo(points.first.dx, bottom);
    for (final point in points) area.lineTo(point.dx, point.dy);
    area.lineTo(points.last.dx, bottom);
    canvas.drawPath(area, Paint()..color = FullTankColors.blueSoft);
    final line = Paint()
      ..color = FullTankColors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) path.lineTo(point.dx, point.dy);
    canvas.drawPath(path, line);
    for (final point in points)
      canvas.drawCircle(point, 2, Paint()..color = Colors.white);
    for (var i = 0; i < 6; i++)
      _drawText(
        canvas,
        ['MAR', 'ABR', 'MAY', 'JUN', 'JUL', 'AGO'][i],
        Offset(left - 5 + i * step, bottom + 10),
        i == 5 ? FullTankColors.navy : FullTankColors.inkSoft,
        6,
      );
    _drawText(
      canvas,
      '74.0k L',
      Offset(points.last.dx - 26, points.last.dy - 17),
      Colors.white,
      6,
      background: FullTankColors.navy,
    );
    _drawText(canvas, '74k', Offset(0, top - 4), FullTankColors.inkSoft, 6);
    _drawText(
      canvas,
      '37k',
      Offset(0, (top + bottom) / 2 - 4),
      FullTankColors.inkSoft,
      6,
    );
    _drawText(
      canvas,
      '0',
      Offset(left - 2, bottom - 8),
      FullTankColors.inkSoft,
      6,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final left = size.width * .1;
    final right = size.width * .97;
    final top = size.height * .15;
    final bottom = size.height * .68;
    final groupWidth = (right - left) / 6;
    final barWidth = groupWidth * .22;
    final grid = Paint()
      ..color = FullTankColors.line
      ..strokeWidth = 1;
    for (final y in [top, (top + bottom) / 2, bottom])
      canvas.drawLine(Offset(left, y), Offset(right, y), grid);
    const current = [22, 30, 17, 42, 53, 65];
    const previous = [18, 24, 20, 33, 43, 52];
    for (var i = 0; i < 6; i++) {
      final x = left + i * groupWidth + groupWidth * .24;
      final currentHeight = (bottom - top) * current[i] / 65;
      final previousHeight = (bottom - top) * previous[i] / 65;
      canvas.drawRect(
        Rect.fromLTWH(x, bottom - currentHeight, barWidth, currentHeight),
        Paint()..color = FullTankColors.blue,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          x + barWidth + 3,
          bottom - previousHeight,
          barWidth,
          previousHeight,
        ),
        Paint()..color = const Color(0xFFB7C2D4),
      );
      _drawText(
        canvas,
        ['MAR', 'ABR', 'MAY', 'JUN', 'JUL', 'AGO'][i],
        Offset(left + i * groupWidth + groupWidth * .13, bottom + 10),
        FullTankColors.inkSoft,
        6,
      );
    }
    _drawText(
      canvas,
      'Anterior',
      Offset(left, size.height - 18),
      FullTankColors.inkMid,
      6,
    );
    _drawText(
      canvas,
      'Actual',
      Offset(left + 42, size.height - 18),
      FullTankColors.inkMid,
      6,
    );
    canvas.drawRect(
      Rect.fromLTWH(left - 9, size.height - 20, 5, 5),
      Paint()..color = const Color(0xFFB7C2D4),
    );
    canvas.drawRect(
      Rect.fromLTWH(left + 33, size.height - 20, 5, 5),
      Paint()..color = FullTankColors.blue,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void _drawText(
  Canvas canvas,
  String text,
  Offset offset,
  Color color,
  double size, {
  Color? background,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: size * _uiTextScale,
        fontWeight: FontWeight.w700,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  if (background != null)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          offset.dx - 4 * _uiTextScale,
          offset.dy - 3 * _uiTextScale,
          painter.width + 8,
          painter.height + 6,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = background,
    );
  painter.paint(canvas, offset);
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: FullTankColors.inkMid,
      fontSize: 7,
      fontWeight: FontWeight.w800,
    ),
  );
}

class _SelectField extends StatelessWidget {
  const _SelectField(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    height: 38,
    margin: const EdgeInsets.only(top: 6),
    padding: const EdgeInsets.symmetric(horizontal: 13),
    decoration: BoxDecoration(
      color: FullTankColors.card,
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: FullTankColors.navyMid,
            fontSize: 8,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Icon(
          Icons.chevron_right,
          size: 13,
          color: FullTankColors.inkSoft,
        ),
      ],
    ),
  );
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 6),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: FullTankColors.blueSoft,
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.description_outlined,
              color: FullTankColors.blue,
              size: 14,
            ),
            SizedBox(width: 6),
            Text(
              'Reporte de ventas · AGO 2026',
              style: TextStyle(
                color: FullTankColors.navy,
                fontSize: 8,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        SizedBox(height: 2),
        Text(
          'PDF · A4 · 2 páginas · 980 KB',
          style: TextStyle(color: FullTankColors.inkMid, fontSize: 7),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _SummaryMetric('INGRESOS', '\$31.200K')),
            Expanded(child: _SummaryMetric('LITROS VENDIDOS', '1.240.000')),
            Expanded(child: _SummaryMetric('TICKET PROM.', '\$98.1K')),
          ],
        ),
      ],
    ),
  );
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: FullTankColors.inkMid,
          fontSize: 5.5,
          fontWeight: FontWeight.w800,
        ),
      ),
      Text(
        value,
        style: const TextStyle(
          color: FullTankColors.navy,
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton();
  @override
  Widget build(BuildContext context) => Container(
    height: 46,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [FullTankColors.ctaFrom, FullTankColors.ctaTo],
      ),
      borderRadius: BorderRadius.circular(99),
      boxShadow: const [
        BoxShadow(
          color: Color(0x44FFA500),
          blurRadius: 14,
          offset: Offset(0, 7),
        ),
      ],
    ),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.download_outlined, size: 14, color: Colors.white),
        SizedBox(width: 6),
        Text(
          'Generar y descargar PDF',
          style: TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _DeltaBadge extends StatelessWidget {
  const _DeltaBadge(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFE9FFF4),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      '↑ $text',
      style: const TextStyle(
        color: Color(0xFF059669),
        fontSize: 6.5,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _IndustryRows extends StatelessWidget {
  const _IndustryRows();
  @override
  Widget build(BuildContext context) => const Column(
    children: [
      _IndustryRow(
        icon: Icons.local_shipping_outlined,
        label: 'Transporte',
        liters: '184.000 L',
        percent: '42%',
        widthFactor: .42,
        color: FullTankColors.blue,
      ),
      _IndustryRow(
        icon: Icons.agriculture_outlined,
        label: 'Agricultura',
        liters: '118.000 L',
        percent: '27%',
        widthFactor: .27,
        color: Color(0xFF0F9B91),
      ),
      _IndustryRow(
        icon: Icons.factory_outlined,
        label: 'Manufactura',
        liters: '81.000 L',
        percent: '18%',
        widthFactor: .18,
        color: Color(0xFFC56B2C),
      ),
      _IndustryRow(
        icon: Icons.construction_outlined,
        label: 'Construcción',
        liters: '57.000 L',
        percent: '13%',
        widthFactor: .13,
        color: Color(0xFF8B5CF6),
      ),
    ],
  );
}

class _IndustryRow extends StatelessWidget {
  const _IndustryRow({
    required this.icon,
    required this.label,
    required this.liters,
    required this.percent,
    required this.widthFactor,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String liters;
  final String percent;
  final double widthFactor;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 7),
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          color: Color(0x10000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            _TinyIcon(icon: icon, color: color),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: FullTankColors.navy,
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    liters,
                    style: const TextStyle(
                      color: FullTankColors.inkSoft,
                      fontSize: 6.5,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              percent,
              style: const TextStyle(
                color: FullTankColors.navy,
                fontSize: 8,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: widthFactor,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _TinyIcon extends StatelessWidget {
  const _TinyIcon({required this.icon, required this.color});
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    width: 22,
    height: 22,
    decoration: BoxDecoration(
      color: color.withAlpha(24),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Icon(icon, size: 12, color: color),
  );
}
