import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../home/presentation/home_page.dart';
part 'dispatch_pages_01.dart';
part 'dispatch_pages_02.dart';
part 'dispatch_pages_03.dart';
part 'dispatch_pages_04.dart';
part 'dispatch_pages_05.dart';
part 'dispatch_pages_06.dart';
part 'dispatch_pages_07.dart';
part 'dispatch_pages_08.dart';

const _ink = Color(0xFF202735);
const _muted = Color(0xFF718096);
const _subtle = Color(0xFF94A3B8);
const _line = Color(0xFFE2E8F0);
const _panel = Color(0xFFF5F7FA);
const _orange = Color(0xFFFFAD0A);
const _blue = Color(0xFF3157C9);
const _blueSoft = Color(0xFFEEF3FF);
const _green = Color(0xFF10B981);
const _greenSoft = Color(0xFFEAFBF3);
const _amber = Color(0xFFF59E0B);
const _amberSoft = Color(0xFFFFF8E7);
const _red = Color(0xFFEF4444);
const _redSoft = Color(0xFFFFF0F0);

enum TransportAvailabilityState { content, loading, empty, conflict }

TransportAvailabilityState dispatchAvailabilityStateFromQuery(String? value) =>
    switch (value) {
      'loading' => TransportAvailabilityState.loading,
      'empty' => TransportAvailabilityState.empty,
      'conflict' => TransportAvailabilityState.conflict,
      _ => TransportAvailabilityState.content,
    };

enum AssignmentState { order, vehicle, driver, confirm, conflict, success }

AssignmentState dispatchAssignmentStateFromQuery(String? value) =>
    switch (value) {
      'vehicle' => AssignmentState.vehicle,
      'driver' => AssignmentState.driver,
      'confirm' => AssignmentState.confirm,
      'conflict' => AssignmentState.conflict,
      'success' => AssignmentState.success,
      _ => AssignmentState.order,
    };
