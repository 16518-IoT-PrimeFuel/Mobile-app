import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/fulltank_theme.dart';
import '../../home/presentation/home_page.dart';
part 'orders_list_page.dart';
part 'order_detail_and_creation_pages.dart';
part 'new_order_fuel_fields.dart';
part 'new_order_delivery_fields.dart';
part 'new_order_status_views.dart';
part 'sales_report_page.dart';
part 'order_metrics_and_charts.dart';
part 'order_history.dart';
part 'active_orders.dart';
part 'order_loading_and_empty_states.dart';
part 'order_error_and_delivery_widgets.dart';
part 'order_detail_widgets.dart';
part 'sales_dashboard.dart';
part 'sales_report_progress_and_ready.dart';
part 'sales_report_empty_and_actions.dart';
part 'order_action_buttons.dart';

const _ink = Color(0xFF172033);
const _muted = Color(0xFF64748B);
const _subtle = Color(0xFF94A3B8);
const _line = Color(0xFFE7ECF2);
const _panel = Color(0xFFF8FAFC);
const _blue = Color(0xFF2563EB);
const _blueSoft = Color(0xFFEFF4FF);
const _orange = Color(0xFFFF8A0A);
const _green = Color(0xFF10B981);
const _greenSoft = Color(0xFFE9FBF4);
const _red = Color(0xFFEF4444);
const _uiScale = fullTankUiScale;

enum OrderPageState { content, loading, empty, error }

OrderPageState orderPageStateFromQuery(String? value) => switch (value) {
  'loading' => OrderPageState.loading,
  'empty' => OrderPageState.empty,
  'error' => OrderPageState.error,
  _ => OrderPageState.content,
};

enum SalesReportState { dashboard, generating, ready, empty }

enum NewOrderState { defaultState, loading, success, error }

NewOrderState newOrderStateFromQuery(String? value) => switch (value) {
  'loading' => NewOrderState.loading,
  'success' => NewOrderState.success,
  'error' => NewOrderState.error,
  _ => NewOrderState.defaultState,
};
