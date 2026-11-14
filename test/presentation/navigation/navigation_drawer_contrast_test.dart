import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/locator.dart';
import 'package:logisto/main.dart';
import 'package:logisto/presentation/navigation/app_routes.dart';
import 'package:logisto/presentation/navigation/navigation_drawer.dart';
import 'package:logisto/presentation/navigation/navigation_shell.dart';
import 'package:logisto/theme/app_colors.dart';
import '../../test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await setupSeededLocator();
  });

  tearDown(() async {
    await resetLocator();
  });

  testWidgets('checks navigation drawer text and icons in light and dark mode', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    // 1. Test Light Mode
    await tester.pumpWidget(
      const LogistoApp(
        locale: Locale('es'),
        themeMode: ThemeMode.light,
        home: NavigationShell(initialRoute: AppRoutes.dashboard),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(AppNavigationDrawer), findsOneWidget);

    // Active item (Dashboard) has white text against primary background
    final drawerFinder = find.byType(AppNavigationDrawer);
    final dashFinder = find.descendant(
      of: drawerFinder,
      matching: find.text('Dashboard'),
    );
    expect(dashFinder, findsOneWidget);
    final dashTextLight = tester.widget<Text>(dashFinder);
    expect(dashTextLight.style?.color, AppColors.backgroundLight);

    // Inactive link in Spanish has dark high-contrast text in light mode
    final posFinder = find.descendant(
      of: drawerFinder,
      matching: find.text('Punto de Venta'),
    );
    expect(posFinder, findsOneWidget);
    final posTextLight = tester.widget<Text>(posFinder);
    expect(posTextLight.style?.color, AppColors.textPrimaryLight);

    // Section header has high-contrast muted text
    final headerFinder = find.descendant(
      of: drawerFinder,
      matching: find.text('OPERACIONES PRINCIPALES'),
    );
    expect(headerFinder, findsOneWidget);
    final headerLight = tester.widget<Text>(headerFinder);
    expect(headerLight.style?.color, AppColors.textMutedLight);

    // 2. Test Dark Mode
    await tester.pumpWidget(
      const LogistoApp(
        locale: Locale('es'),
        themeMode: ThemeMode.dark,
        home: NavigationShell(initialRoute: AppRoutes.dashboard),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(AppNavigationDrawer), findsOneWidget);

    // Active item still has white text against primary background
    final dashTextDark = tester.widget<Text>(dashFinder);
    expect(dashTextDark.style?.color, AppColors.backgroundLight);

    // Inactive link has light high-contrast text in dark mode
    final posTextDark = tester.widget<Text>(posFinder);
    expect(posTextDark.style?.color, AppColors.textPrimaryDark);

    // Section header has brightened header text in dark mode
    final headerDark = tester.widget<Text>(headerFinder);
    expect(headerDark.style?.color, AppColors.textMutedDark);
  });
}
