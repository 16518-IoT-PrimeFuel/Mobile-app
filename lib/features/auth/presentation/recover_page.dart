import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/fulltank_theme.dart';
import 'widgets/auth_buttons.dart';
import 'widgets/auth_text_field.dart';
part 'recover_page_content.dart';
part 'recovery_form_widgets.dart';
part 'recovery_sent_widgets.dart';
part 'recovery_illustration_painter.dart';

enum _RecoverStage { form, sent, notFound }
