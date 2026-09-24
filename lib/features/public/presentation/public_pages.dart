import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/fulltank_theme.dart';
import '../domain/public_content.dart';

class PublicPage extends StatelessWidget {
  const PublicPage({required this.section, super.key});

  final PublicSection section;

  @override
  Widget build(BuildContext context) {
    final content = publicContent[section]!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('FullTank'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
        children: [
          Text(content.title, style: _titleStyle),
          const SizedBox(height: 8),
          Text(content.subtitle, style: _subtitleStyle),
          const SizedBox(height: 24),
          ...content.items.map((item) => _PublicCard(item: item)),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: () => context.go('/login'),
            child: const Text('Comenzar con FullTank'),
          ),
        ],
      ),
    );
  }
}

class _PublicCard extends StatelessWidget {
  const _PublicCard({required this.item});

  final PublicItem item;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: FullTankColors.card,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: FullTankColors.line),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: FullTankColors.blueSoft,
          foregroundColor: FullTankColors.blue,
          child: Text(item.icon),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title, style: _itemTitleStyle),
              const SizedBox(height: 4),
              Text(item.description, style: _itemDescriptionStyle),
            ],
          ),
        ),
      ],
    ),
  );
}

const _titleStyle = TextStyle(
  color: FullTankColors.navy,
  fontSize: 28,
  fontWeight: FontWeight.w800,
  height: 1.1,
);

const _subtitleStyle = TextStyle(
  color: FullTankColors.inkMid,
  fontSize: 15,
  height: 1.4,
);

const _itemTitleStyle = TextStyle(
  color: FullTankColors.navy,
  fontSize: 15,
  fontWeight: FontWeight.w800,
);

const _itemDescriptionStyle = TextStyle(
  color: FullTankColors.inkMid,
  fontSize: 13,
  height: 1.35,
);
