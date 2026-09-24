import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        title: const Text('FullTank', style: TextStyle(fontSize: 31.9)),
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
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: const StadiumBorder(),
            ),
            child: const Text(
              'Comenzar con FullTank',
              style: TextStyle(fontSize: 20.3),
            ),
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
      color: Color(0xFFF3F4F6),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Color(0xFFE2E8F0)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Color(0xFFEFF4FF),
          foregroundColor: Color(0xFF1E40AF),
          child: Text(item.icon, style: const TextStyle(fontSize: 23.2)),
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
  color: Color(0xFF1A202C),
  fontSize: 40.6,
  fontWeight: FontWeight.w800,
  height: 1.1,
);

const _subtitleStyle = TextStyle(
  color: Color(0xFF4A5568),
  fontSize: 21.75,
  height: 1.4,
);

const _itemTitleStyle = TextStyle(
  color: Color(0xFF1A202C),
  fontSize: 21.75,
  fontWeight: FontWeight.w800,
);

const _itemDescriptionStyle = TextStyle(
  color: Color(0xFF4A5568),
  fontSize: 18.85,
  height: 1.35,
);
