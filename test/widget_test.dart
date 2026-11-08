import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/main.dart';

void main() {
  testWidgets(
    'Bootstrap UI operational counter and modal smoke test on laptop viewport',
    (WidgetTester tester) async {
      // Configure virtual surface to primary laptop resolution (1280x720)
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const LogistoApp());
      await tester.pumpAndSettle();

      // Verify initial telemetry counter displays 0
      expect(find.text('0'), findsOneWidget);

      // Tap the Bootstrap increment action button
      await tester.tap(find.text('Increment'));
      await tester.pumpAndSettle();

      // Verify counter incremented to 1
      expect(find.text('1'), findsOneWidget);
      expect(find.text('0'), findsNothing);

      // Tap System Info in the expanded desktop navbar
      await tester.tap(find.text('System Info'));
      await tester.pumpAndSettle();

      // Verify the Bootstrap modal header and content rendered
      expect(find.text('System Information'), findsOneWidget);
      expect(find.text('Active telemetry tasks processed: 1'), findsOneWidget);

      // Dismiss the modal
      await tester.tap(find.text('Dismiss'));
      await tester.pumpAndSettle();

      // Verify modal is closed
      expect(find.text('System Information'), findsNothing);

      // Reset counter
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      // Verify counter is back to 0
      expect(find.text('0'), findsOneWidget);
    },
  );
}
