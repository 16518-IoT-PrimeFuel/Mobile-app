import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/auth/presentation/widgets/auth_buttons.dart';
import 'package:mobile_app/shared/widgets/fulltank_bottom_navigation.dart';
import 'package:mobile_app/shared/theme/fulltank_theme.dart';

void main() {
  testWidgets('corporate theme supplies shared typography and surfaces', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: fullTankTheme,
        home: const Scaffold(body: Text('FullTank')),
      ),
    );
    final context = tester.element(find.text('FullTank'));
    expect(Theme.of(context).colorScheme.primary, FullTankColors.primary);
    expect(
      Theme.of(context).scaffoldBackgroundColor,
      FullTankColors.background,
    );
    expect(DefaultTextStyle.of(context).style.fontFamily, 'Roboto');
    for (final weight in ['Regular', 'Medium', 'Bold', 'Black']) {
      expect(
        (await rootBundle.load(
          'assets/fonts/Roboto-$weight.ttf',
        )).lengthInBytes,
        greaterThan(0),
      );
    }
  });

  testWidgets('active mobile navigation uses the corporate primary', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(bottomNavigationBar: FullTankBottomNav(active: 0)),
      ),
    );
    expect(
      tester.widget<Icon>(find.byIcon(Icons.home_outlined)).color,
      const Color(0xFF1E3A8A),
    );
  });

  testWidgets('primary authentication action uses a solid corporate color', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryAuthButton(label: 'Sign in', onPressed: () {}),
        ),
      ),
    );
    final decoration =
        tester
                .widget<DecoratedBox>(
                  find
                      .descendant(
                        of: find.byType(PrimaryAuthButton),
                        matching: find.byType(DecoratedBox),
                      )
                      .first,
                )
                .decoration
            as BoxDecoration;
    expect(decoration.color, const Color(0xFF1E3A8A));
    expect(decoration.gradient, isNull);
  });

  test('presentation no longer embeds the previous corporate palette', () {
    final oldPalette = RegExp(r'Color\(0xFF(?:1E40AF|1A202C|4A5568|C56B2C)\)');
    final leftovers = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .where((file) => oldPalette.hasMatch(file.readAsStringSync()))
        .map((file) => file.path)
        .toList();
    expect(leftovers, isEmpty);
  });
}
