import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/report_category_enum.dart';
import 'package:logisto/l10n/app_localizations.dart';
import 'package:logisto/locator.dart';
import 'package:logisto/main.dart';
import 'package:logisto/presentation/navigation/app_routes.dart';
import 'package:logisto/presentation/navigation/navigation_shell.dart';
import 'package:logisto/presentation/reports/reports_provider.dart';
import 'package:logisto/presentation/reports/widgets/reports_table_desktop.dart';
import '../../test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await setupSeededLocator();
  });

  tearDown(() async {
    await resetLocator();
  });

  group('ReportsProvider Localization & Logic', () {
    testWidgets(
      'generates localized rows for all categories in Spanish and English',
      (tester) async {
        late AppLocalizations l10nEs;
        late AppLocalizations l10nEn;

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('es'),
            home: Builder(
              builder: (ctx) {
                l10nEs = AppLocalizations.of(ctx)!;
                return const SizedBox();
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: Builder(
              builder: (ctx) {
                l10nEn = AppLocalizations.of(ctx)!;
                return const SizedBox();
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        final provider = locator<ReportsProvider>();

        // 1. Sales category
        provider.setCategory(ReportCategoryEnum.sales);
        final salesEs = provider.getLocalizedReportRows(l10nEs);
        final salesEn = provider.getLocalizedReportRows(l10nEn);
        expect(salesEs, isA<List<ReportRowItem>>());
        expect(salesEn, isA<List<ReportRowItem>>());

        // 2. Inventory category
        provider.setCategory(ReportCategoryEnum.inventory);
        final invEs = provider.getLocalizedReportRows(l10nEs);
        final invEn = provider.getLocalizedReportRows(l10nEn);
        expect(invEs, isA<List<ReportRowItem>>());
        expect(invEn, isA<List<ReportRowItem>>());

        // 3. Cash category
        provider.setCategory(ReportCategoryEnum.cash);
        final cashEs = provider.getLocalizedReportRows(l10nEs);
        final cashEn = provider.getLocalizedReportRows(l10nEn);
        expect(cashEs, isA<List<ReportRowItem>>());
        expect(cashEn, isA<List<ReportRowItem>>());

        // 4. Credit category
        provider.setCategory(ReportCategoryEnum.credit);
        final creditEs = provider.getLocalizedReportRows(l10nEs);
        final creditEn = provider.getLocalizedReportRows(l10nEn);
        expect(creditEs, isA<List<ReportRowItem>>());
        expect(creditEn, isA<List<ReportRowItem>>());

        // 5. Billiards category
        provider.setCategory(ReportCategoryEnum.billiards);
        final billEs = provider.getLocalizedReportRows(l10nEs);
        final billEn = provider.getLocalizedReportRows(l10nEn);
        expect(billEs, isA<List<ReportRowItem>>());
        expect(billEn, isA<List<ReportRowItem>>());

        // 6. CSV Export with localization
        final csvEs = provider.exportToCsv(l10nEs);
        expect(csvEs, contains('Ítem / Concepto'));
        final csvEn = provider.exportToCsv(l10nEn);
        expect(csvEn, contains('Item / Concept'));
      },
    );
  });

  group('ReportsScreen Widget Verification', () {
    testWidgets(
      'renders ReportsScreen in Spanish, switches categories and opens CSV modal',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          const LogistoApp(
            locale: Locale('es'),
            themeMode: ThemeMode.light,
            home: NavigationShell(initialRoute: AppRoutes.reports),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(ReportsTableDesktop), findsOneWidget);
        expect(find.text('Reportes y BI'), findsOneWidget);

        // Verify category buttons in Spanish
        expect(find.text('Ventas 80/20'), findsOneWidget);
        expect(find.text('Inventario'), findsOneWidget);
        expect(find.text('Turnos de Caja'), findsOneWidget);
        expect(find.text('Crédito y Cartera'), findsOneWidget);
        expect(find.widgetWithText(OutlinedButton, 'Billares'), findsOneWidget);

        // Tap 'Inventario' filter button
        await tester.tap(find.text('Inventario'));
        await tester.pumpAndSettle();

        expect(
          find.text('Valoración de Inventario y Punto de Reorden'),
          findsOneWidget,
        );

        // Tap 'Exportar CSV'
        final exportBtn = find.text('Exportar CSV');
        expect(exportBtn, findsOneWidget);
        await tester.tap(exportBtn);
        await tester.pumpAndSettle();

        // Modal appears
        expect(find.text('Reporte Exportado Exitosamente'), findsOneWidget);
        expect(find.text('Hecho'), findsOneWidget);

        // Dismiss modal
        await tester.tap(find.text('Hecho'));
        await tester.pumpAndSettle();

        expect(find.text('Reporte Exportado Exitosamente'), findsNothing);
      },
    );
  });
}
