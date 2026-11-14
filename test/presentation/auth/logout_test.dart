import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/data/firestore/database_seeder.dart';
import 'package:logisto/data/preferences/app_preferences.dart';
import 'package:logisto/data/repositories/business_unit_repository.dart';
import 'package:logisto/data/repositories/organization_repository.dart';
import 'package:logisto/locator.dart';
import 'package:logisto/main.dart';
import 'package:logisto/presentation/auth/login_provider.dart';
import 'package:logisto/presentation/auth/login_screen.dart';
import 'package:logisto/presentation/auth/logout_dialog.dart';
import 'package:logisto/presentation/business_units/business_unit_selector_screen.dart';
import 'package:logisto/presentation/context/business_context_provider.dart';
import 'package:logisto/presentation/dashboard/dashboard_screen.dart';
import 'package:logisto/presentation/navigation/app_flow_coordinator.dart';
import 'package:logisto/presentation/navigation/app_routes.dart';
import 'package:logisto/presentation/navigation/navigation_drawer.dart';
import 'package:logisto/presentation/navigation/navigation_provider.dart';
import 'package:logisto/presentation/navigation/navigation_shell.dart';
import 'package:logisto/presentation/onboarding/onboarding_wizard_screen.dart';
import 'package:logisto/presentation/settings/settings_screen.dart';
import '../../test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await setupSeededLocator();
    final login = locator<LoginProvider>();
    await login.signInWithEmailPassword('admin@logisto.com', 'admin123');
  });

  tearDown(() async {
    await resetLocator();
  });

  group('Logout Dialog Unit & Widget Tests', () {
    testWidgets('canceling logout dialog preserves active session', (tester) async {
      final login = locator<LoginProvider>();
      expect(login.isAuthenticated, isTrue);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => showLogoutDialog(ctx),
              child: const Text('Open Logout'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Logout'));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Cerrar Sesión'), findsOneWidget);
      expect(
        find.text('¿Está seguro de que desea cerrar la sesión actual?'),
        findsOneWidget,
      );

      // Tap Cancel
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      // Dialog is dismissed and user is still authenticated
      expect(find.byType(AlertDialog), findsNothing);
      expect(login.isAuthenticated, isTrue);
    });

    testWidgets('confirming logout dialog wipes session and routes to login', (
      tester,
    ) async {
      final login = locator<LoginProvider>();
      final contextProvider = locator<BusinessContextProvider>();
      final nav = locator<NavigationProvider>();

      expect(login.isAuthenticated, isTrue);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => showLogoutDialog(ctx),
              child: const Text('Open Logout'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Logout'));
      await tester.pumpAndSettle();

      // Tap Confirm
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();

      // Session wiped, context cleared, routed to login
      expect(find.byType(AlertDialog), findsNothing);
      expect(login.isAuthenticated, isFalse);
      expect(contextProvider.activeBusinessUnit, isNull);
      expect(nav.currentRoute, equals(AppRoutes.login));
    });
  });

  group('NavigationShell Desktop Logout Integration', () {
    testWidgets('renders logout button in desktop navbar and triggers logout', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('es'),
          home: NavigationShell(initialRoute: AppRoutes.dashboard),
        ),
      );
      await tester.pumpAndSettle();

      final logoutBtnFinder = find.widgetWithText(OutlinedButton, 'Cerrar Sesión');
      expect(logoutBtnFinder, findsOneWidget);

      await tester.tap(logoutBtnFinder);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Confirmar'), findsOneWidget);

      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();

      final login = locator<LoginProvider>();
      expect(login.isAuthenticated, isFalse);
      expect(locator<NavigationProvider>().currentRoute, equals(AppRoutes.login));
    });
  });

  group('NavigationShell Mobile Logout Integration', () {
    testWidgets('renders logout icon button in mobile navbar and triggers dialog', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('es'),
          home: NavigationShell(initialRoute: AppRoutes.dashboard),
        ),
      );
      await tester.pumpAndSettle();

      // Find logout icon button with tooltip
      final logoutIconFinder = find.byTooltip('Cerrar Sesión');
      expect(logoutIconFinder, findsOneWidget);

      await tester.tap(logoutIconFinder);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });

  group('Sidebar / Drawer Menu Item Logout Integration', () {
    testWidgets('sidebar menu item triggers logout confirmation', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('es'),
          home: NavigationShell(initialRoute: AppRoutes.dashboard),
        ),
      );
      await tester.pumpAndSettle();

      // Find "Cerrar Sesión" inside the navigation drawer menu list
      final drawerFinder = find.byType(AppNavigationDrawer);
      expect(drawerFinder, findsOneWidget);

      final navItemFinder = find.descendant(
        of: drawerFinder,
        matching: find.text('Cerrar Sesión'),
      );
      expect(navItemFinder, findsOneWidget);

      await tester.ensureVisible(navItemFinder);
      await tester.pumpAndSettle();
      await tester.tap(navItemFinder);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });

  group('Settings Screen Logout Integration', () {
    testWidgets('header and appearance card contain logout options', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('es'),
          home: SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // In Settings header
      expect(find.widgetWithText(OutlinedButton, 'Cerrar Sesión'), findsWidgets);

      // Tap header logout
      await tester.tap(find.widgetWithText(OutlinedButton, 'Cerrar Sesión').first);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });

  group('Business Unit Selector Screen Logout Integration', () {
    testWidgets('header contains logout action button', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('es'),
          home: BusinessUnitSelectorScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final logoutBtn = find.byTooltip('Cerrar Sesión');
      expect(logoutBtn, findsOneWidget);

      await tester.tap(logoutBtn);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });

  group('Rapid Double-Tap and Concurrency Resilience', () {
    testWidgets('rapid double tap on confirm does not throw or double-pop', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => showLogoutDialog(ctx),
              child: const Text('Open Logout'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Logout'));
      await tester.pumpAndSettle();

      final confirmBtn = find.text('Confirmar');
      expect(confirmBtn, findsOneWidget);

      // Perform rapid taps
      await tester.tap(confirmBtn);
      await tester.tap(confirmBtn, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(AlertDialog), findsNothing);
      expect(locator<LoginProvider>().isAuthenticated, isFalse);
    });
  });

  group('English Localization Logout Verification', () {
    testWidgets('renders dialog in English with correct strings', (tester) async {
      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('en'),
          home: NavigationShell(initialRoute: AppRoutes.dashboard),
        ),
      );
      await tester.pumpAndSettle();

      final logoutBtnFinder = find.widgetWithText(OutlinedButton, 'Log Out');
      expect(logoutBtnFinder, findsOneWidget);

      await tester.tap(logoutBtnFinder);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Log Out'), findsWidgets);
      expect(
        find.text('Are you sure you want to log out of your current session?'),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(locator<LoginProvider>().isAuthenticated, isTrue);
    });
  });

  group('Onboarding Wizard Screen Logout Integration', () {
    testWidgets('header contains logout action button and triggers dialog', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('es'),
          home: OnboardingWizardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final logoutBtn = find.byTooltip('Cerrar Sesión');
      expect(logoutBtn, findsOneWidget);

      await tester.tap(logoutBtn);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });

  group('End-to-End AppFlowCoordinator Logout & Re-login Flow', () {
    testWidgets('logs out from dashboard and allows re-login returning to dashboard', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final prefs = locator<AppPreferences>();
      await prefs.setOnboardingCompleted(true);
      final org = await locator<OrganizationRepository>()
          .getOrganization(DatabaseSeeder.defaultOrgId);
      final units = await locator<BusinessUnitRepository>()
          .getBusinessUnits(DatabaseSeeder.defaultOrgId);
      await locator<BusinessContextProvider>().initializeContext(
        organization: org!,
        units: units,
      );
      await locator<BusinessContextProvider>().switchBusinessUnit(units.first);

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('es'),
          home: AppFlowCoordinator(),
        ),
      );
      await tester.pumpAndSettle();

      // Initially on NavigationShell (since setUp authenticated admin)
      expect(find.byType(NavigationShell), findsOneWidget);

      // Trigger logout from top navbar
      final logoutBtnFinder = find.widgetWithText(OutlinedButton, 'Cerrar Sesión');
      expect(logoutBtnFinder, findsOneWidget);
      await tester.tap(logoutBtnFinder);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();

      // Flow coordinator displays LoginScreen
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(locator<LoginProvider>().isAuthenticated, isFalse);

      // Re-login using form fields
      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);
      await tester.enterText(textFields.first, 'admin@logisto.com');
      await tester.enterText(textFields.at(1), 'admin123');
      await tester.tap(find.widgetWithText(FilledButton, 'Iniciar Sesión'));
      await tester.pumpAndSettle();

      // Select business unit if prompted
      if (find.byType(BusinessUnitSelectorScreen).evaluate().isNotEmpty) {
        final selectBranchBtn = find.widgetWithText(FilledButton, 'Seleccionar Sucursal');
        expect(selectBranchBtn, findsWidgets);
        await tester.tap(selectBranchBtn.first);
        await tester.pumpAndSettle();
      }

      // Must be back in NavigationShell showing Dashboard, NOT LoginScreen inside shell
      expect(find.byType(NavigationShell), findsOneWidget);
      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(NavigationShell),
          matching: find.byType(LoginScreen),
        ),
        findsNothing,
      );
    });
  });

  group('Responsive Logout Button Audit Across 6 Breakpoints', () {
    const breakpoints = <String, Size>{
      'xs_mobile_360': Size(360, 800),
      'sm_landscape_576': Size(576, 800),
      'md_tablet_768': Size(768, 1024),
      'lg_desktop_992': Size(992, 800),
      'xl_desktop_1200': Size(1200, 800),
      'xxl_workstation_1400': Size(1400, 900),
    };

    for (final entry in breakpoints.entries) {
      testWidgets('renders logout action without overflow on ${entry.key}', (
        tester,
      ) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          const LogistoApp(
            locale: Locale('es'),
            home: NavigationShell(initialRoute: AppRoutes.dashboard),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);

        final isDesktop = entry.value.width >= BsBreakpoints.lg;
        if (isDesktop) {
          expect(
            find.widgetWithText(OutlinedButton, 'Cerrar Sesión'),
            findsOneWidget,
          );
        } else {
          expect(find.byTooltip('Cerrar Sesión'), findsWidgets);
        }
      });
    }
  });
}
