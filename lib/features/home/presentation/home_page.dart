import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/application/auth_providers.dart';
import '../../../core/theme/fulltank_theme.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider).session;
    return Scaffold(
      appBar: AppBar(
        title: const Text('FullTank'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.verified_user_outlined,
                size: 48,
                color: FullTankColors.blue,
              ),
              const SizedBox(height: 16),
              const Text(
                'Sesión iniciada',
                style: TextStyle(
                  color: FullTankColors.navy,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                session?.username ?? '',
                style: const TextStyle(color: FullTankColors.inkMid),
              ),
              const SizedBox(height: 16),
              const Text(
                'Dashboard pendiente de la siguiente historia de usuario.',
                textAlign: TextAlign.center,
                style: TextStyle(color: FullTankColors.inkMid),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
