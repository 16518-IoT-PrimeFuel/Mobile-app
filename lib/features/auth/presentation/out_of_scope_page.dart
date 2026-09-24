import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/fulltank_theme.dart';

class OutOfScopePage extends StatelessWidget {
  const OutOfScopePage({required this.title, required this.message, super.key});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: FullTankColors.inkMid,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
