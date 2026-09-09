import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/fulltank_theme.dart';
import '../../home/presentation/home_page.dart';
part 'reports_page_content.dart';
part 'report_metric_cards.dart';
part 'report_charts.dart';
part 'report_form_and_summary.dart';
part 'report_summary_and_industry_widgets.dart';
part 'report_tiny_icon.dart';

enum ReportVariant { consumption, sales, export, industry }

const _uiTextScale = fullTankUiScale;
