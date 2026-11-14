import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/locator.dart';
import 'package:logisto/main.dart';
import 'package:logisto/presentation/audit/audit_log_screen.dart';
import 'package:logisto/presentation/audit/widgets/audit_log_list_mobile.dart';
import 'package:logisto/presentation/audit/widgets/audit_log_table_desktop.dart';
import 'package:logisto/presentation/reports/reports_screen.dart';
import 'package:logisto/presentation/reports/widgets/reports_list_mobile.dart';
import 'package:logisto/presentation/reports/widgets/reports_table_desktop.dart';
import 'package:logisto/presentation/settings/settings_screen.dart';
import 'package:logisto/presentation/settings/widgets/org_settings_card.dart';
import 'package:logisto/presentation/settings/widgets/rbac_matrix_card.dart';
import 'package:logisto/presentation/settings/widgets/supervisor_pin_modal.dart';
import 'package:logisto/presentation/users/user_management_screen.dart';
import 'package:logisto/presentation/users/widgets/invite_user_modal.dart';
import 'package:logisto/presentation/users/widgets/user_list_mobile.dart';
import 'package:logisto/presentation/users/widgets/user_table_desktop.dart';
import '../test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await setupSeededLocator();
  });

  tearDown(() async {
    await resetLocator();
  });

  group('UserManagementScreen Widget Tests', () {
    testWidgets(
      'renders desktop table, filters staff, and opens invite modal',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          const LogistoApp(locale: Locale('en'), home: UserManagementScreen()),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Users & Staff'), findsOneWidget);
        expect(find.byType(UserTableDesktop), findsOneWidget);
        expect(find.text('Carlos Machado (Owner)'), findsOneWidget);
        expect(find.text('Juan Pérez'), findsOneWidget);

        // Search filter
        await tester.enterText(find.byType(EditableText).first, 'María');
        await tester.pumpAndSettle();

        expect(find.text('María López'), findsOneWidget);
        expect(find.text('Carlos Machado (Owner)'), findsNothing);

        // Clear search
        await tester.enterText(find.byType(EditableText).first, '');
        await tester.pumpAndSettle();

        // Open invite modal
        await tester.tap(find.text('Invite Employee'));
        await tester.pumpAndSettle();

        expect(find.byType(InviteUserModal), findsOneWidget);
        expect(find.text('Invite New Employee'), findsOneWidget);

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(find.byType(InviteUserModal), findsNothing);
      },
    );

    testWidgets('renders mobile list and opens roles modal', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: UserManagementScreen()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(UserListMobile), findsOneWidget);

      // Open roles modal
      final roleButtons = find.text('Roles');
      expect(roleButtons, findsWidgets);
      await tester.tap(roleButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Close'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
    });
  });

  group('SettingsScreen Widget Tests', () {
    testWidgets('renders corporate configuration and toggles RBAC matrix', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Settings & RBAC'), findsOneWidget);
      expect(find.byType(OrgSettingsCard), findsOneWidget);
      expect(find.text('Corporate & Tax Configuration'), findsOneWidget);

      // Switch to RBAC security matrix
      await tester.tap(find.text('RBAC Security'));
      await tester.pumpAndSettle();

      expect(find.byType(RbacMatrixCard), findsOneWidget);
      expect(find.text('RBAC Security & Permission Matrix'), findsOneWidget);
      expect(find.text('SUPER_ADMIN_ORG'), findsOneWidget);
      expect(find.text('CASHIER'), findsOneWidget);

      // Switch back to corporate settings
      await tester.tap(find.text('Corporate & Fiscal'));
      await tester.pumpAndSettle();
      expect(find.byType(OrgSettingsCard), findsOneWidget);
    });

    testWidgets('SupervisorPinModal validates authorization PIN', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      bool approved = false;
      await tester.pumpWidget(
        LogistoApp(
          locale: const Locale('en'),
          home: BsContainer.fluid(
            child: Center(
              child: SupervisorPinModal(
                actionTitle: 'Apply 15% Courtesy Discount',
                onApproved: () => approved = true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Authorize: Apply 15% Courtesy Discount'),
        findsOneWidget,
      );

      // Enter wrong PIN
      await tester.enterText(find.byType(EditableText), '0000');
      await tester.tap(find.text('Authorize Action'));
      await tester.pumpAndSettle();

      expect(approved, isFalse);
      expect(
        find.text('Invalid supervisor authorization PIN.'),
        findsOneWidget,
      );

      // Enter valid supervisor PIN
      await tester.enterText(find.byType(EditableText), '9999');
      await tester.tap(find.text('Authorize Action'));
      await tester.pumpAndSettle();

      expect(approved, isTrue);
    });
  });

  group('ReportsScreen Widget Tests', () {
    testWidgets(
      'renders desktop table, switches categories, and triggers CSV export',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          const LogistoApp(locale: Locale('en'), home: ReportsScreen()),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Reports & BI'), findsOneWidget);
        expect(find.byType(ReportsTableDesktop), findsOneWidget);
        expect(
          find.text('Sales & Pareto Contribution (80/20)'),
          findsOneWidget,
        );

        // Switch to Inventory
        await tester.tap(find.text('Inventory'));
        await tester.pumpAndSettle();

        expect(
          find.text('Inventory Valuation & Reorder Point'),
          findsOneWidget,
        );

        // Switch to Billiards
        await tester.tap(find.text('Billiards'));
        await tester.pumpAndSettle();

        expect(
          find.text('Billiard Station Utilization & Hourly Rent'),
          findsOneWidget,
        );

        // Export CSV modal
        await tester.tap(find.text('Export CSV'));
        await tester.pumpAndSettle();

        expect(find.text('Report Exported Successfully'), findsOneWidget);
        expect(find.text('Done'), findsOneWidget);

        await tester.tap(find.text('Done'));
        await tester.pumpAndSettle();
        expect(find.text('Report Exported Successfully'), findsNothing);
      },
    );

    testWidgets('renders mobile reports card list', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: ReportsScreen()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ReportsListMobile), findsOneWidget);
    });
  });

  group('AuditLogScreen Widget Tests', () {
    testWidgets('renders desktop table, filters by action, and searches text', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: AuditLogScreen()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Audit Trail'), findsOneWidget);
      expect(find.byType(AuditLogTableDesktop), findsOneWidget);
      expect(find.text('Carlos Machado (Admin)'), findsWidgets);
      expect(find.text('Juan Pérez'), findsWidgets);

      // Filter by action
      await tester.tap(find.text('void item'));
      await tester.pumpAndSettle();

      expect(
        find.text('Voided 1x Cerveza Toña from Tab-0101 (Client returned)'),
        findsOneWidget,
      );

      // Filter by search text
      await tester.tap(find.text('All Events'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), 'Happy Hour');
      await tester.pumpAndSettle();

      expect(
        find.text('Updated Table 3 Hourly Rate for Happy Hour'),
        findsOneWidget,
      );
    });

    testWidgets('renders mobile audit log list', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: AuditLogScreen()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(AuditLogListMobile), findsOneWidget);
    });
  });
}
