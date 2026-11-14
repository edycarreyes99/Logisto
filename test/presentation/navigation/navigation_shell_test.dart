import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/user_role_enum.dart';
import 'package:logisto/locator.dart';
import 'package:logisto/main.dart';
import 'package:logisto/presentation/audit/audit_log_screen.dart';
import 'package:logisto/presentation/auth/widgets/pin_switch_modal.dart';
import 'package:logisto/presentation/navigation/app_routes.dart';
import 'package:logisto/presentation/navigation/navigation_drawer.dart';
import 'package:logisto/presentation/navigation/navigation_provider.dart';
import 'package:logisto/presentation/navigation/navigation_shell.dart';
import 'package:logisto/presentation/pos/pos_checkout_screen.dart';
import 'package:logisto/presentation/products/product_catalog_screen.dart';
import 'package:logisto/presentation/reports/reports_screen.dart';
import 'package:logisto/presentation/settings/settings_screen.dart';
import 'package:logisto/presentation/users/user_management_screen.dart';
import '../../test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await setupSeededLocator();
  });

  tearDown(() async {
    await resetLocator();
  });

  group('NavigationProvider Unit Tests', () {
    test('initializes with dashboard and superAdminOrg role', () {
      final nav = locator<NavigationProvider>();
      expect(nav.currentRoute, equals(AppRoutes.dashboard));
      expect(nav.currentUserRole, equals(UserRoleEnum.superAdminOrg));
      expect(nav.isDrawerOpen, isFalse);
    });

    test('navigateTo changes route and closes drawer', () {
      final nav = locator<NavigationProvider>();
      nav.toggleDrawer();
      expect(nav.isDrawerOpen, isTrue);

      nav.navigateTo(AppRoutes.pos);
      expect(nav.currentRoute, equals(AppRoutes.pos));
      expect(nav.isDrawerOpen, isFalse);
    });

    test('setUserRole updates role and notifies listeners', () {
      final nav = locator<NavigationProvider>();
      nav.setUserRole(UserRoleEnum.cashier);
      expect(nav.currentUserRole, equals(UserRoleEnum.cashier));
    });

    test('toggleDrawer and closeDrawer update state', () {
      final nav = locator<NavigationProvider>();
      expect(nav.isDrawerOpen, isFalse);

      nav.toggleDrawer();
      expect(nav.isDrawerOpen, isTrue);

      nav.closeDrawer();
      expect(nav.isDrawerOpen, isFalse);
    });
  });

  group('NavigationShell Widget Tests', () {
    testWidgets(
      'renders desktop sidebar, top navbar, and navigates between screens',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          const LogistoApp(
            locale: Locale('en'),
            home: NavigationShell(initialRoute: AppRoutes.dashboard),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Logisto'), findsOneWidget);
        expect(find.byType(AppNavigationDrawer), findsOneWidget);

        // Navigate to POS Checkout via sidebar
        await tester.tap(find.text('POS Checkout'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(PosCheckoutScreen), findsOneWidget);

        // Navigate to Products via sidebar
        await tester.tap(find.text('Products'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(ProductCatalogScreen), findsOneWidget);

        // Navigate to Reports & BI via sidebar
        await tester.tap(find.text('Reports & BI'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(ReportsScreen), findsOneWidget);

        // Navigate to Users & Staff via sidebar
        await tester.ensureVisible(find.text('Users & Staff'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Users & Staff'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(UserManagementScreen), findsOneWidget);

        // Navigate to Settings via sidebar
        await tester.ensureVisible(find.text('Settings'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Settings'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(SettingsScreen), findsOneWidget);

        // Navigate to Audit Trail via sidebar
        await tester.ensureVisible(find.text('Audit Trail'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Audit Trail'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(AuditLogScreen), findsOneWidget);

        // Open Fast PIN switch modal from navbar
        await tester.tap(find.text('Fast PIN'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(PinSwitchModal), findsOneWidget);
        expect(find.text('Fast PIN Switch'), findsOneWidget);

        // Close modal
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.byType(PinSwitchModal), findsNothing);
      },
    );

    testWidgets('renders mobile layout with menu toggle button', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('en'),
          home: NavigationShell(initialRoute: AppRoutes.dashboard),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Logisto'), findsOneWidget);

      // On mobile, desktop sidebar is hidden
      expect(find.byType(AppNavigationDrawer), findsNothing);

      // Menu button exists on mobile
      expect(find.text('Menu'), findsOneWidget);

      // Open offcanvas drawer
      await tester.tap(find.text('Menu'));
      await tester.pumpAndSettle();

      expect(find.text('Logisto ERP Modules'), findsOneWidget);
      expect(find.byType(AppNavigationDrawer), findsOneWidget);

      // Tap POS Checkout in mobile drawer
      await tester.tap(find.text('POS Checkout'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(PosCheckoutScreen), findsOneWidget);
    });
  });
}
