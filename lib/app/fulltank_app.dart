import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/fulltank_theme.dart';
import '../features/auth/application/auth_providers.dart';
import 'app_router.dart';

class FullTankApp extends ConsumerStatefulWidget {
  const FullTankApp({super.key});

  @override
  ConsumerState<FullTankApp> createState() => _FullTankAppState();
}

class _FullTankAppState extends ConsumerState<FullTankApp> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(authControllerProvider.notifier).restoreSession(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'FullTank',
      theme: FullTankTheme.light(),
      routerConfig: router,
      builder: (context, child) =>
          withFullTankUiScale(context, child ?? const SizedBox.shrink()),
    );
  }
}
