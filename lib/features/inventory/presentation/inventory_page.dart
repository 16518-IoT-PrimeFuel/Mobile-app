import '../../../shared/theme/fulltank_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/application/auth_providers.dart';
import '../../orders/application/orders_controller.dart';
import '../../orders/application/orders_providers.dart';
import '../../orders/data/replenishment_options_repository.dart';
import '../application/inventory_controller.dart';
import '../application/inventory_providers.dart';
import '../domain/fuel_product.dart';
import '../domain/tank.dart';
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

const _green = FullTankColors.success;
const _greenSoft = FullTankColors.successSoft;
const _amber = FullTankColors.accent;
const _amberSoft = FullTankColors.warningSoft;
const _red = FullTankColors.error;
const _redSoft = FullTankColors.errorSoft;

enum _TankStatus { critical, warning, optimal }
