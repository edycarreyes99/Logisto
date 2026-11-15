import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/dashboard_time_filter_enum.dart';
import 'package:logisto/core/enums/feature_status_enum.dart';
import 'package:logisto/locator.dart';
import 'package:logisto/main.dart';
import 'package:logisto/presentation/dashboard/dashboard_provider.dart';
import 'package:logisto/presentation/dashboard/dashboard_screen.dart';
import '../../test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DashboardProvider Unit Tests', () {
    late DashboardProvider provider;

    setUp(() {
      provider = DashboardProvider();
    });

    test('initial state has default timeFilter Today and idle status', () {
      expect(provider.timeFilter, equals(DashboardTimeFilterEnum.today));
      expect(provider.status, equals(FeatureStatusEnum.idle));
      expect(provider.metrics.todaySales, equals(0.0));
      expect(provider.topProducts, isEmpty);
    });

    test('setTimeFilter updates active filter and notifies listeners', () {
      bool notified = false;
      provider.addListener(() => notified = true);

      provider.setTimeFilter(DashboardTimeFilterEnum.week);
      expect(provider.timeFilter, equals(DashboardTimeFilterEnum.week));
      expect(notified, isTrue);
    });

    test('loadDashboard updates status to loaded', () async {
      await provider.loadDashboard(orgId: 'org_1', buId: 'bu_1');
      expect(provider.status, equals(FeatureStatusEnum.loaded));
    });
  });

  group('DashboardScreen Widget Tests', () {
    setUp(() async {
      await setupSeededLocator();
    });

    tearDown(() async {
      await resetLocator();
    });

    testWidgets(
      'renders KPI cards, revenue breakdown, and DataTable on desktop',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 720);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          const LogistoApp(locale: Locale('en'), home: DashboardScreen()),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Today Sales'), findsOneWidget);
        expect(find.text('Week Sales'), findsOneWidget);
        expect(find.text('Month Sales'), findsOneWidget);
        expect(find.text('Cash in Till'), findsOneWidget);
        expect(find.text('Open Tabs'), findsOneWidget);
        expect(find.text('Catalog SKUs'), findsOneWidget);

        expect(find.text('Revenue by Category'), findsOneWidget);
        expect(find.text('Revenue by Payment Tender'), findsOneWidget);
        expect(find.text('Top 10 Selling Products & Services'), findsOneWidget);

        // Desktop table
        expect(find.byType(DataTable), findsOneWidget);
        expect(find.byType(ListTile), findsNothing);
      },
    );

    testWidgets('renders ListTile on mobile viewport (< 992px)', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: DashboardScreen()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ListTile), findsWidgets);
      expect(find.byType(DataTable), findsNothing);
    });
  });
}
