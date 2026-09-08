import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/fulltank_theme.dart';
import '../../home/presentation/home_page.dart';
part 'inventory_page_part_01.dart';
part 'inventory_page_part_02.dart';
part 'inventory_page_part_03.dart';
part 'inventory_page_part_04.dart';
part 'inventory_page_part_05.dart';
part 'inventory_page_part_06.dart';
part 'inventory_page_part_07.dart';
part 'inventory_page_part_08.dart';
part 'inventory_page_part_09.dart';
part 'inventory_page_part_10.dart';
part 'inventory_page_part_11.dart';


const _uiScale = 1.3;
const _green = Color(0xFF10B981);
const _greenSoft = Color(0xFFECFDF5);
const _amber = Color(0xFFF59E0B);
const _amberSoft = Color(0xFFFFFBEB);
const _red = Color(0xFFEF4444);
const _redSoft = Color(0xFFFEF2F2);

Widget _withInventoryScale(BuildContext context, Widget child) => MediaQuery(
  data: MediaQuery.of(
    context,
  ).copyWith(textScaler: const TextScaler.linear(_uiScale)),
  child: child,
);

enum _TankStatus { critical, warning, optimal }
