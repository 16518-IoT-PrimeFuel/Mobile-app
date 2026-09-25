import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/fulltank_bottom_navigation.dart';
part 'inventory_list_page.dart';
part 'tank_detail_and_alerts_pages.dart';
part 'restock_page.dart';
part 'inventory_shell_and_summary.dart';
part 'inventory_tank_list_widgets.dart';
part 'tank_gauge_widgets.dart';
part 'inventory_metric_and_sensor_widgets.dart';
part 'inventory_alert_widgets.dart';
part 'restock_tank_and_quantity_widgets.dart';
part 'restock_summary_widgets.dart';
part 'inventory_actions_and_search.dart';

const _green = Color(0xFF10B981);
const _greenSoft = Color(0xFFECFDF5);
const _amber = Color(0xFFF59E0B);
const _amberSoft = Color(0xFFFFFBEB);
const _red = Color(0xFFEF4444);
const _redSoft = Color(0xFFFEF2F2);

enum _TankStatus { critical, warning, optimal }
