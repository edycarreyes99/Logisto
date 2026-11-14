import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/main.dart';
import 'package:logisto/presentation/home/home_screen.dart';
import 'package:logisto/theme/app_colors.dart';

void main() {
  const viewportMatrix = <String, Size>{
    'compact_phone_portrait_320': Size(320, 568),
    'xs_mobile_portrait': Size(360, 800),
    'sm_mobile_landscape': Size(800, 360),
    'md_tablet_portrait': Size(768, 1024),
    'lg_tablet_landscape': Size(1024, 768),
    'xl_laptop_primary_720': Size(
      1280,
      720,
    ), // Primary target: benchmark laptop
    'xl_laptop_standard_800': Size(1280, 800),
    'xl_laptop_hd_768': Size(1366, 768),
    'xl_laptop_macbook_900': Size(1440, 900),
    'xxl_desktop_workstation': Size(1920, 1080),
  };

  for (final entry in viewportMatrix.entries) {
    testWidgets(
      'HomeScreen adapts flawlessly on ${entry.key} (${entry.value.width.toInt()}x${entry.value.height.toInt()})',
      (WidgetTester tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(const LogistoApp(locale: Locale('en')));
        await tester.pumpAndSettle();

        // INVARIANT: Zero uncaught exceptions and zero RenderFlex overflow
        expect(tester.takeException(), isNull);

        // Verify key Bootstrap elements are rendered
        expect(find.text('Logisto'), findsOneWidget);
        expect(find.text('Operational Controls'), findsOneWidget);
        expect(find.text('Telemetry & Status'), findsOneWidget);
        expect(find.text('Live Event Stream'), findsOneWidget);

        // Verify adaptive view representation (RULE-UI-007):
        // Desktop (width >= 992px) renders DataTable; mobile/compact renders ListTile
        final isDesktop = entry.value.width >= BsBreakpoints.lg;
        if (isDesktop) {
          expect(find.byType(DataTable), findsOneWidget);
        } else {
          expect(find.byType(ListTile), findsWidgets);
        }
      },
    );
  }

  testWidgets(
    'HomeScreen renders flawlessly in Dark Theme mode without exception',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(
          themeMode: ThemeMode.dark,
          locale: Locale('en'),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Logisto'), findsOneWidget);
      expect(find.text('Operational Controls'), findsOneWidget);
      expect(find.text('Telemetry & Status'), findsOneWidget);
      expect(find.text('Live Event Stream'), findsOneWidget);

      // Deep assertion: verify Dark Theme is actively resolved and applied to root Material
      final context = tester.element(find.byType(HomeScreen));
      expect(Theme.of(context).brightness, Brightness.dark);
      expect(Theme.of(context).scaffoldBackgroundColor, AppColors.backgroundDark);

      final material = tester.widget<Material>(
        find.ancestor(
          of: find.byType(HomeScreen),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, AppColors.backgroundDark);
    },
  );

  testWidgets(
    'LogistoApp dynamically switches between Light and Dark theme modes at runtime',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // 1. Initial pump in Light Mode
      await tester.pumpWidget(const LogistoApp(themeMode: ThemeMode.light));
      await tester.pumpAndSettle();

      BuildContext context = tester.element(find.byType(HomeScreen));
      expect(Theme.of(context).brightness, Brightness.light);
      expect(Theme.of(context).scaffoldBackgroundColor, AppColors.backgroundLight);

      Material material = tester.widget<Material>(
        find.ancestor(
          of: find.byType(HomeScreen),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, AppColors.backgroundLight);

      // 2. Dynamic switch to Dark Mode without restarting the app
      await tester.pumpWidget(
        const LogistoApp(
          themeMode: ThemeMode.dark,
          locale: Locale('en'),
        ),
      );
      await tester.pumpAndSettle();

      context = tester.element(find.byType(HomeScreen));
      expect(Theme.of(context).brightness, Brightness.dark);
      expect(Theme.of(context).scaffoldBackgroundColor, AppColors.backgroundDark);

      material = tester.widget<Material>(
        find.ancestor(
          of: find.byType(HomeScreen),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, AppColors.backgroundDark);

      // 3. Switch to System Mode reacting to platform brightness
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      await tester.pumpWidget(const LogistoApp(themeMode: ThemeMode.system));
      await tester.pumpAndSettle();

      context = tester.element(find.byType(HomeScreen));
      expect(Theme.of(context).brightness, Brightness.dark);
      expect(Theme.of(context).scaffoldBackgroundColor, AppColors.backgroundDark);

      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      await tester.pumpWidget(const LogistoApp(themeMode: ThemeMode.system));
      await tester.pumpAndSettle();

      context = tester.element(find.byType(HomeScreen));
      expect(Theme.of(context).brightness, Brightness.light);
      expect(Theme.of(context).scaffoldBackgroundColor, AppColors.backgroundLight);
    },
  );
}
