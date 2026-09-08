import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/fulltank_theme.dart';
import '../../auth/application/auth_providers.dart';
part 'home_page_part_01.dart';
part 'home_page_part_02.dart';
part 'home_page_part_03.dart';
part 'home_page_part_04.dart';
part 'home_page_part_05.dart';
part 'home_page_part_06.dart';
part 'home_page_part_07.dart';
part 'home_page_part_08.dart';
part 'home_page_part_09.dart';

enum HomeRole { requester, provider }

const _green = Color(0xFF10B981);
const _greenSoft = Color(0xFFECFDF5);
const _amber = Color(0xFFF59E0B);
const _amberSoft = Color(0xFFFFFBEB);
const _red = Color(0xFFEF4444);
const _redSoft = Color(0xFFFEF2F2);
const _purple = Color(0xFF8B5CF6);
const _purpleSoft = Color(0xFFF5F3FF);
const _uiTextScale = 1.3;

Widget _withHomeUiScale(BuildContext context, Widget child) => MediaQuery(
  data: MediaQuery.of(
    context,
  ).copyWith(textScaler: const TextScaler.linear(_uiTextScale)),
  child: child,
);
