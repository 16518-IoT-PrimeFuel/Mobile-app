import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/fulltank_theme.dart';
import '../../auth/application/auth_providers.dart';
import '../../home/presentation/home_page.dart';
part 'account_overview.dart';
part 'profile_editing.dart';
part 'security_and_notifications.dart';
part 'help_and_settings.dart';
part 'account_setting_rows.dart';
part 'account_shared_widgets.dart';

enum AccountVariant { overview, profile, security, notifications, help }

const _uiTextScale = 1.45;
const _teal = Color(0xFF0F9B91);
const _tealSoft = Color(0xFFEAFBF8);
