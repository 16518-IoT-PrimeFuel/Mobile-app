import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/fulltank_theme.dart';
import 'widgets/auth_buttons.dart';
import 'widgets/auth_text_field.dart';
part 'recover_page_part_01.dart';
part 'recover_page_part_02.dart';
part 'recover_page_part_03.dart';
part 'recover_page_part_04.dart';

enum _RecoverStage { form, sent, notFound }
