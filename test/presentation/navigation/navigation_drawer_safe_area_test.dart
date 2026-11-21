import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/locator.dart';
import 'package:logisto/main.dart';
import 'package:logisto/presentation/navigation/app_routes.dart';
import 'package:logisto/presentation/navigation/navigation_drawer.dart';
import 'package:logisto/presentation/navigation/navigation_provider.dart';
import 'package:logisto/presentation/navigation/navigation_shell.dart';
import '../../test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await setupSeededLocator();
  });

  tearDown(() async {
    await resetLocator();
  });

  testWidgets(
    'drawer incorporates top safe area notch padding and bottom home indicator padding',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      tester.view.padding = const FakeViewPadding(
        top: 48.0,
        bottom: 34.0,
        left: 0.0,
        right: 0.0,
      );
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetPadding();
      });

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('es'),
          home: NavigationShell(initialRoute: AppRoutes.dashboard),
        ),
      );
      await tester.pumpAndSettle();

      // Open drawer from mobile menu icon
      final menuBtn = find.byIcon(Icons.menu_rounded);
      expect(menuBtn, findsOneWidget);
      await tester.tap(menuBtn);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(AppNavigationDrawer), findsOneWidget);

      // Verify header container has top padding: 48.0 + 16.0 = 64.0
      final headerFinder = find.descendant(
        of: find.byType(AppNavigationDrawer),
        matching: find.byType(Container),
      );
      expect(headerFinder, findsWidgets);

      bool foundHeaderWithSafeArea = false;
      bool foundFooterWithSafeArea = false;

      for (final element in headerFinder.evaluate()) {
        final container = element.widget as Container;
        final padding = container.padding;
        if (padding is EdgeInsets) {
          if (padding.top == 64.0 && padding.left == 16.0) {
            foundHeaderWithSafeArea = true;
          }
          if (padding.bottom == 42.0 && padding.left == 12.0) {
            foundFooterWithSafeArea = true;
          }
        }
      }

      expect(foundHeaderWithSafeArea, isTrue);
      expect(foundFooterWithSafeArea, isTrue);
    },
  );

  testWidgets(
    'drawer auto-scrolls to active item when route is at bottom of menu',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      tester.view.padding = const FakeViewPadding(top: 48.0, bottom: 34.0);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetPadding();
      });

      // Set initial route to Settings (at bottom of menu)
      locator<NavigationProvider>().navigateTo(AppRoutes.settings);

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('es'),
          home: NavigationShell(initialRoute: AppRoutes.settings),
        ),
      );
      await tester.pumpAndSettle();

      // Open drawer
      final menuBtn = find.byIcon(Icons.menu_rounded);
      expect(menuBtn, findsOneWidget);
      await tester.tap(menuBtn);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      // Active Settings destination should be rendered in viewport
      final settingsFinder = find.text('Ajustes');
      expect(settingsFinder, findsOneWidget);

      // Ensure that Settings text widget is on-screen
      final settingsRect = tester.getRect(settingsFinder);
      expect(settingsRect.bottom, greaterThan(0.0));
      expect(settingsRect.top, lessThan(844.0));
    },
  );
}
