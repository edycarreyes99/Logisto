import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/warehouse_view_mode_enum.dart';
import 'package:logisto/locator.dart';
import 'package:logisto/main.dart';
import 'package:logisto/presentation/customers/customer_catalog_screen.dart';
import 'package:logisto/presentation/customers/widgets/customer_list_mobile.dart';
import 'package:logisto/presentation/customers/widgets/customer_table_desktop.dart';
import 'package:logisto/presentation/inventory/inventory_warehouse_screen.dart';
import 'package:logisto/presentation/inventory/widgets/kardex_list_mobile.dart';
import 'package:logisto/presentation/inventory/widgets/kardex_table_desktop.dart';
import 'package:logisto/presentation/inventory/widgets/warehouse_stock_list_mobile.dart';
import 'package:logisto/presentation/inventory/widgets/warehouse_stock_table_desktop.dart';
import 'package:logisto/presentation/invoices/invoice_history_screen.dart';
import 'package:logisto/presentation/invoices/widgets/invoice_list_mobile.dart';
import 'package:logisto/presentation/invoices/widgets/invoice_table_desktop.dart';
import 'package:logisto/presentation/payables/accounts_payable_screen.dart';
import 'package:logisto/presentation/payables/widgets/payable_list_mobile.dart';
import 'package:logisto/presentation/payables/widgets/payable_table_desktop.dart';
import 'package:logisto/presentation/products/product_catalog_screen.dart';
import 'package:logisto/presentation/products/widgets/product_list_mobile.dart';
import 'package:logisto/presentation/products/widgets/product_table_desktop.dart';
import 'package:logisto/presentation/purchasing/purchase_order_screen.dart';
import 'package:logisto/presentation/purchasing/widgets/purchase_order_list_mobile.dart';
import 'package:logisto/presentation/purchasing/widgets/purchase_order_table_desktop.dart';
import 'package:logisto/presentation/receivables/accounts_receivable_screen.dart';
import 'package:logisto/presentation/receivables/widgets/receivable_list_mobile.dart';
import 'package:logisto/presentation/receivables/widgets/receivable_table_desktop.dart';
import 'package:logisto/presentation/suppliers/supplier_catalog_screen.dart';
import 'package:logisto/presentation/suppliers/widgets/supplier_list_mobile.dart';
import 'package:logisto/presentation/suppliers/widgets/supplier_table_desktop.dart';
import '../../test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await setupSeededLocator();
  });

  tearDown(() async {
    await resetLocator();
  });

  group('ProductCatalogScreen Widget Tests', () {
    testWidgets(
      'renders desktop table, filters items, and opens new product modal',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          const LogistoApp(locale: Locale('en'), home: ProductCatalogScreen()),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Products'), findsOneWidget);
        expect(find.byType(ProductTableDesktop), findsOneWidget);
        expect(find.text('Cerveza Toña 350ml Botella'), findsOneWidget);

        // Search filter
        await tester.enterText(find.byType(EditableText).first, 'Mojito');
        await tester.pumpAndSettle();

        expect(find.text('Mojito Cubano Artesanal'), findsOneWidget);
        expect(find.text('Cerveza Toña 350ml Botella'), findsNothing);

        // Open new product modal from navbar on desktop
        await tester.tap(find.text('New Product'));
        await tester.pumpAndSettle();

        expect(find.text('Create Product'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.text('Create Product'), findsNothing);
      },
    );

    testWidgets('renders mobile list and opens edit product modal', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: ProductCatalogScreen()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ProductListMobile), findsOneWidget);

      // Open edit product modal from mobile list item
      final editButtons = find.text('Edit');
      expect(editButtons, findsWidgets);
      await tester.tap(editButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Edit Product'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Product'), findsNothing);
    });
  });

  group('InventoryWarehouseScreen Widget Tests', () {
    testWidgets('renders warehouse stock and opens transfer modal', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('en'),
          home: InventoryWarehouseScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Warehouses'), findsOneWidget);
      expect(find.byType(WarehouseStockTableDesktop), findsOneWidget);

      // Tap transfer button on first item
      final transferButtons = find.text('Transfer');
      expect(transferButtons, findsWidgets);
      await tester.tap(transferButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Confirm Transfer Guide'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm Transfer Guide'), findsNothing);
    });

    testWidgets('renders mobile warehouse stock list', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('en'),
          home: InventoryWarehouseScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(WarehouseStockListMobile), findsOneWidget);
    });

    testWidgets(
      'toggles Kardex Movement Ledger and renders desktop kardex table',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          const LogistoApp(
            locale: Locale('en'),
            home: InventoryWarehouseScreen(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(WarehouseStockTableDesktop), findsOneWidget);

        // Switch to Kardex Ledger
        await tester.tap(find.text('Kardex Ledger'));
        await tester.pumpAndSettle();

        expect(find.byType(KardexTableDesktop), findsOneWidget);
        expect(
          find.text(
            'Permanent Kardex Movement Ledger (Entries, Exits, Transfers & Audits)',
          ),
          findsOneWidget,
        );
        expect(find.text('Inbound reception from Cervecera'), findsOneWidget);

        // Switch back to Stock Levels
        await tester.tap(find.text('Stock Levels'));
        await tester.pumpAndSettle();

        expect(find.byType(WarehouseStockTableDesktop), findsOneWidget);
      },
    );

    testWidgets('renders mobile kardex list when view mode is kardex', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('en'),
          home: InventoryWarehouseScreen(
            initialView: WarehouseViewModeEnum.kardex,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(KardexListMobile), findsOneWidget);
      expect(find.text('Inbound reception from Cervecera'), findsWidgets);
    });
  });

  group('CustomerCatalogScreen Widget Tests', () {
    testWidgets('renders customer desktop table and registers customer', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: CustomerCatalogScreen()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Customers'), findsOneWidget);
      expect(find.byType(CustomerTableDesktop), findsOneWidget);
      expect(find.text('Roberto Gómez'), findsOneWidget);

      // Register customer modal
      await tester.tap(find.text('Register Customer'));
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Save Customer'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Save Customer'), findsNothing);
    });

    testWidgets('renders mobile customer list', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: CustomerCatalogScreen()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(CustomerListMobile), findsOneWidget);
    });
  });

  group('InvoiceHistoryScreen Widget Tests', () {
    testWidgets('renders invoice desktop table and opens invoice details', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: InvoiceHistoryScreen()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Invoices'), findsOneWidget);
      expect(find.byType(InvoiceTableDesktop), findsOneWidget);
      expect(find.text('FAC-001-000194'), findsOneWidget);

      // Tap View details
      final viewButtons = find.text('View');
      expect(viewButtons, findsWidgets);
      await tester.tap(viewButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Invoice FAC-001-000194'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text('Invoice FAC-001-000194'), findsNothing);
    });

    testWidgets('renders mobile invoice list', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: InvoiceHistoryScreen()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(InvoiceListMobile), findsOneWidget);
    });
  });

  group('SupplierCatalogScreen Widget Tests', () {
    testWidgets('renders supplier table and opens registration modal', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: SupplierCatalogScreen()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Suppliers'), findsOneWidget);
      expect(find.byType(SupplierTableDesktop), findsOneWidget);
      expect(find.text('Compañía Cervecera Nacional'), findsOneWidget);

      // Open registration modal
      await tester.tap(find.text('Register Supplier'));
      await tester.pumpAndSettle();

      expect(find.text('Save Supplier'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Save Supplier'), findsNothing);
    });

    testWidgets('renders mobile supplier list', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: SupplierCatalogScreen()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(SupplierListMobile), findsOneWidget);
    });
  });

  group('PurchaseOrderScreen Widget Tests', () {
    testWidgets('renders purchase orders table and creates order', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: PurchaseOrderScreen()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Purchasing'), findsOneWidget);
      expect(find.byType(PurchaseOrderTableDesktop), findsOneWidget);

      // Open create order modal
      await tester.tap(find.text('Create Purchase Order'));
      await tester.pumpAndSettle();

      expect(find.text('Issue Order'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Issue Order'), findsNothing);
    });

    testWidgets('renders mobile purchase order list', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: PurchaseOrderScreen()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(PurchaseOrderListMobile), findsOneWidget);
    });
  });

  group('AccountsReceivableScreen Widget Tests', () {
    testWidgets('renders receivables desktop table and opens payment modal', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('en'),
          home: AccountsReceivableScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Receivables'), findsOneWidget);
      expect(find.byType(ReceivableTableDesktop), findsOneWidget);
      expect(find.text('Roberto Gómez'), findsOneWidget);

      // Open collect modal
      final collectButtons = find.text('Collect');
      expect(collectButtons, findsWidgets);
      await tester.tap(collectButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Emit Receipt & Apply'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Emit Receipt & Apply'), findsNothing);
    });

    testWidgets('renders mobile receivable list', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('en'),
          home: AccountsReceivableScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ReceivableListMobile), findsOneWidget);
    });
  });

  group('AccountsPayableScreen Widget Tests', () {
    testWidgets('renders payables desktop table and opens payment modal', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: AccountsPayableScreen()),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Payables'), findsOneWidget);
      expect(find.byType(PayableTableDesktop), findsOneWidget);
      expect(find.text('Compañía Cervecera Nacional'), findsOneWidget);

      // Open pay supplier modal
      final payButtons = find.text('Pay');
      expect(payButtons, findsWidgets);
      await tester.tap(payButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Disburse Payment'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Disburse Payment'), findsNothing);
    });

    testWidgets('renders mobile payable list', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: AccountsPayableScreen()),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(PayableListMobile), findsOneWidget);
    });
  });
}
