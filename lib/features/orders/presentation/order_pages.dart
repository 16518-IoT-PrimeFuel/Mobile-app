import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
part 'order_pages_part_01.dart';
part 'order_pages_part_02.dart';
part 'order_pages_part_03.dart';
part 'order_pages_part_04.dart';
part 'order_pages_part_05.dart';
part 'order_pages_part_06.dart';
part 'order_pages_part_07.dart';
part 'order_pages_part_08.dart';
part 'order_pages_part_09.dart';
part 'order_pages_part_10.dart';
part 'order_pages_part_11.dart';
part 'order_pages_part_12.dart';
part 'order_pages_part_13.dart';
part 'order_pages_part_14.dart';
part 'order_pages_part_15.dart';
part 'order_pages_part_16.dart';

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
