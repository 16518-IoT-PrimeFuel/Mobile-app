import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/public/domain/public_content.dart';
import 'package:mobile_app/features/public/presentation/public_pages.dart';

void main() {
  testWidgets('renders every public story section', (tester) async {
    for (final section in PublicSection.values) {
      await tester.pumpWidget(MaterialApp(home: PublicPage(section: section)));
      await tester.pump();
      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pump();
      expect(find.text('Comenzar con FullTank'), findsOneWidget);
    }
  });
}
