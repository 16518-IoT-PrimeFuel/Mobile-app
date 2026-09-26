import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/fulltank_bottom_navigation.dart';
import '../application/orders_controller.dart';
import '../application/orders_providers.dart';
import '../domain/order.dart';
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

String orderStatusLabel(OrderStatus status) => switch (status) {
  OrderStatus.pending => 'Pendiente',
  OrderStatus.approved => 'Aprobado',
  OrderStatus.inTransit => 'En tránsito',
  OrderStatus.delivered => 'Entregado',
  OrderStatus.cancelled => 'Cancelado',
  OrderStatus.rejected => 'Rechazado',
};

Color orderStatusColor(OrderStatus status) => switch (status) {
  OrderStatus.approved || OrderStatus.delivered => _blue,
  OrderStatus.pending || OrderStatus.inTransit => _orange,
  OrderStatus.cancelled || OrderStatus.rejected => _red,
};

String orderQuantityLabel(double quantity) =>
    '${quantity.toStringAsFixed(quantity == quantity.roundToDouble() ? 0 : 1)} L';

String orderTotalLabel(double total) => 'S/ ${total.toStringAsFixed(2)}';

Order fallbackOrder(String id, {bool history = false}) => Order(
  id: id,
  fuel: 'Diésel · ULSD B5',
  quantity: history ? 10500 : 6000,
  total: history ? 16170 : 9274.80,
  status: history ? OrderStatus.delivered : OrderStatus.inTransit,
  deliveryAddress: 'Global Fuel Corp',
);
