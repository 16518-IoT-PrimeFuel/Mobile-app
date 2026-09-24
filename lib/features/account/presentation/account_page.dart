import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/fulltank_theme.dart';
import '../../auth/application/auth_providers.dart';
import '../../home/presentation/home_page.dart';
part 'account_page_part_01.dart';
part 'account_page_part_02.dart';
part 'account_page_part_03.dart';
part 'account_page_part_04.dart';
part 'account_page_part_05.dart';
part 'account_page_part_06.dart';



enum AccountVariant { overview, profile, security, notifications, help }

const _uiTextScale = 1.45;
const _teal = Color(0xFF0F9B91);
const _tealSoft = Color(0xFFEAFBF8);
