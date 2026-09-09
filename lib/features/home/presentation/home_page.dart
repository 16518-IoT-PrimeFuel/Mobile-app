import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/fulltank_theme.dart';
import '../../auth/application/auth_providers.dart';
part 'home_dashboard.dart';
part 'home_header_and_tank_summary.dart';
part 'home_order_progress.dart';
part 'home_metrics_and_quick_actions.dart';
part 'global_search_page.dart';
part 'quick_actions_and_activity_pages.dart';
part 'empty_home_page.dart';
part 'home_activity_widgets.dart';
part 'home_bottom_navigation.dart';

enum HomeRole { requester, provider }

const _green = Color(0xFF10B981);
const _greenSoft = Color(0xFFECFDF5);
const _amber = Color(0xFFF59E0B);
const _amberSoft = Color(0xFFFFFBEB);
const _red = Color(0xFFEF4444);
const _redSoft = Color(0xFFFEF2F2);
const _purple = Color(0xFF8B5CF6);
const _purpleSoft = Color(0xFFF5F3FF);
const _uiTextScale = fullTankUiScale;

Widget _withHomeUiScale(BuildContext context, Widget child) => MediaQuery(
  data: MediaQuery.of(
    context,
  ).copyWith(textScaler: const TextScaler.linear(_uiTextScale)),
  child: child,
);
