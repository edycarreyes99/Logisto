import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/account_origin_type_enum.dart';
import 'package:logisto/core/enums/account_status_enum.dart';
import 'package:logisto/core/enums/feature_status_enum.dart';
import 'package:logisto/core/enums/invoice_status_enum.dart';
import 'package:logisto/core/enums/movement_type_enum.dart';
import 'package:logisto/data/firestore/firestore_client.dart';
import 'package:logisto/data/repositories/account_receivable_repository.dart';
import 'package:logisto/data/repositories/customer_repository.dart';
import 'package:logisto/data/repositories/invoice_repository.dart';
import 'package:logisto/data/repositories/open_account_repository.dart';
import 'package:logisto/data/repositories/stock_movement_repository.dart';
import 'package:logisto/domain/models/account_receivable_model.dart';
import 'package:logisto/domain/models/customer_model.dart';
import 'package:logisto/domain/models/invoice_model.dart';
import 'package:logisto/domain/models/open_account_model.dart';
import 'package:logisto/domain/models/stock_movement_model.dart';
import 'package:logisto/domain/services/checkout_tender_engine.dart';
import 'package:logisto/locator.dart';
import 'package:logisto/main.dart';
import 'package:logisto/presentation/pos/pos_checkout_provider.dart';
import 'package:logisto/presentation/pos/pos_checkout_screen.dart';
import 'package:mocktail/mocktail.dart';
import '../../test_helpers.dart';

class MockFirestoreClient extends Mock implements FirestoreClient {}

class MockInvoiceRepository extends Mock implements InvoiceRepository {}

class MockOpenAccountRepository extends Mock implements OpenAccountRepository {}

class MockStockMovementRepository extends Mock
    implements StockMovementRepository {}

class MockAccountReceivableRepository extends Mock
    implements AccountReceivableRepository {}

class MockCustomerRepository extends Mock implements CustomerRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final dummyCustomer = CustomerModel(
    id: 'cust_01',
    orgId: 'org_test',
    taxId: '001-010190-0001A',
    firstName: 'Juan',
    lastName: 'Perez',
    phone: '8888-9999',
    creditLimit: 500.0,
    currentDebtBalance: 100.0,
    createdAt: DateTime(2026, 11, 12),
  );

  setUpAll(() {
    registerFallbackValue(
      InvoiceModel(
        id: 'inv_dummy',
        invoiceNumber: 'INV-001',
        cashShiftId: 'shift_1',
        cashierUserId: 'usr_1',
        customerDisplayName: 'Customer 1',
        items: const [],
        subtotal: 0.0,
        taxAmount: 0.0,
        totalAmount: 0.0,
        payments: const [],
        paymentStatus: InvoiceStatusEnum.paid,
        createdAt: DateTime.now(),
      ),
    );
    registerFallbackValue(
      StockMovementModel(
        id: 'mov_dummy',
        buId: 'bu_test',
        warehouseId: 'wh_main',
        productId: 'prod_1',
        productName: 'Product 1',
        movementType: MovementTypeEnum.salesDeduction,
        quantity: -1,
        unitCost: 1.0,
        totalCost: -1.0,
        referenceId: 'REF-1',
        timestamp: DateTime.now(),
      ),
    );
    registerFallbackValue(
      AccountReceivableModel(
        id: 'cxc_dummy',
        buId: 'bu_test',
        customerId: 'cust_01',
        customerName: 'Customer 1',
        invoiceId: 'inv_1',
        invoiceNumber: 'FAC-1',
        originalAmount: 10.0,
        pendingAmount: 10.0,
        dueDate: DateTime.now(),
        createdAt: DateTime.now(),
      ),
    );
  });

  group('PosCheckoutProvider Unit Tests', () {
    late MockInvoiceRepository mockRepo;
    late MockOpenAccountRepository mockOpenAccountRepo;
    late MockStockMovementRepository mockStockRepo;
    late MockAccountReceivableRepository mockArRepo;
    late MockCustomerRepository mockCustomerRepo;
    late CheckoutTenderEngine tenderEngine;
    late PosCheckoutProvider provider;

    final initialCartItems = <InvoiceItemModel>[
      const InvoiceItemModel(
        productId: 'prod_tona',
        name: 'Cerveza Toña',
        quantity: 4,
        unitPrice: 1.75,
        total: 7.00,
      ),
      const InvoiceItemModel(
        productId: 'prod_billar',
        name: 'Tiempo Mesa 1',
        quantity: 1,
        unitPrice: 7.00,
        total: 7.00,
      ),
    ];

    setUp(() {
      mockRepo = MockInvoiceRepository();
      mockOpenAccountRepo = MockOpenAccountRepository();
      mockStockRepo = MockStockMovementRepository();
      mockArRepo = MockAccountReceivableRepository();
      mockCustomerRepo = MockCustomerRepository();
      tenderEngine = const CheckoutTenderEngine();
      provider = PosCheckoutProvider(
        invoiceRepository: mockRepo,
        tenderEngine: tenderEngine,
        openAccountRepository: mockOpenAccountRepo,
        stockMovementRepository: mockStockRepo,
        accountReceivableRepository: mockArRepo,
        customerRepository: mockCustomerRepo,
        initialItems: initialCartItems,
      );
    });

    test('calculates subtotal, 15% tax, and total accurately', () {
      // 4 x 1.75 = 7.00 + 1 x 7.00 = 14.00 subtotal
      expect(provider.subtotal, equals(14.00));
      // 14.00 * 0.15 = 2.10
      expect(provider.taxAmount, equals(2.10));
      // 14.00 + 2.10 = 16.10
      expect(provider.totalAmount, equals(16.10));
    });

    test('recalculates tender and computes change due on cash overpayment', () {
      provider.updateTenderAmounts(cash: 20.0, card: 0.0, credit: 0.0);

      expect(provider.lastResult, isNotNull);
      expect(provider.lastResult?.status, equals(InvoiceStatusEnum.paid));
      expect(provider.lastResult?.change, equals(3.90));
    });

    test('prevents credit tender exceeding customer credit limit', () {
      provider.selectCustomer(dummyCustomer);
      // Available credit is 500 - 100 = 400.
      provider.updateTenderAmounts(cash: 0.0, card: 0.0, credit: 16.10);

      expect(
        provider.lastResult?.status,
        equals(InvoiceStatusEnum.partiallyPaidCredit),
      );
      expect(provider.errorMessage, isNull);

      // Now set credit tender way above limit (e.g. 500)
      provider.updateTenderAmounts(cash: 0.0, card: 0.0, credit: 500.0);
      expect(provider.errorMessage, isNotNull);
    });

    test(
      'finalizeInvoice creates invoice model and records via repository',
      () async {
        when(
          () => mockRepo.createInvoice(
            orgId: any(named: 'orgId'),
            buId: any(named: 'buId'),
            invoice: any(named: 'invoice'),
          ),
        ).thenAnswer((_) async {});

        provider.updateTenderAmounts(cash: 20.0, card: 0.0, credit: 0.0);

        final inv = await provider.finalizeInvoice(
          orgId: 'org_test',
          buId: 'bu_test',
          cashierId: 'usr_cashier',
          cashShiftId: 'shift_1',
        );

        expect(inv, isNotNull);
        expect(provider.status, equals(FeatureStatusEnum.loaded));
      },
    );

    test('loadFromOpenAccount populates items and originAccountId', () {
      final tab = OpenAccountModel(
        id: 'tab_99',
        code: 'TAB-99',
        originType: AccountOriginTypeEnum.table,
        tableId: 'tbl_1',
        tableName: 'Table 1',
        customerDisplayName: 'VIP Customer',
        status: AccountStatusEnum.open,
        items: const [
          AccountItemModel(
            productId: 'prod_tona',
            name: 'Cerveza Toña',
            quantity: 3,
            unitPrice: 2.0,
            total: 6.0,
          ),
        ],
        totalAmount: 6.0,
        openedAt: DateTime.now(),
      );

      provider.loadFromOpenAccount(tab);

      expect(provider.originAccountId, equals('tab_99'));
      expect(provider.cartItems.length, equals(1));
      expect(provider.cartItems.first.productId, equals('prod_tona'));
      expect(provider.subtotal, equals(6.0));
    });

    test(
      'finalizeInvoice closes open account and records stock movement',
      () async {
        when(
          () => mockRepo.createInvoice(
            orgId: any(named: 'orgId'),
            buId: any(named: 'buId'),
            invoice: any(named: 'invoice'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockOpenAccountRepo.closeAccount(
            orgId: any(named: 'orgId'),
            buId: any(named: 'buId'),
            accountId: any(named: 'accountId'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockStockRepo.recordMovement(
            orgId: any(named: 'orgId'),
            buId: any(named: 'buId'),
            movement: any(named: 'movement'),
          ),
        ).thenAnswer((_) async {});

        final tab = OpenAccountModel(
          id: 'tab_99',
          code: 'TAB-99',
          originType: AccountOriginTypeEnum.table,
          tableId: 'tbl_1',
          tableName: 'Table 1',
          customerDisplayName: 'Customer 1',
          status: AccountStatusEnum.open,
          items: const [
            AccountItemModel(
              productId: 'prod_beer',
              name: 'Heineken 330ml',
              quantity: 2,
              unitPrice: 3.0,
              total: 6.0,
            ),
          ],
          totalAmount: 6.0,
          openedAt: DateTime.now(),
        );

        provider.loadFromOpenAccount(tab);
        provider.updateTenderAmounts(cash: 10.0, card: 0.0, credit: 0.0);

        final inv = await provider.finalizeInvoice(
          orgId: 'org_test',
          buId: 'bu_test',
          cashierId: 'usr_cashier',
          cashShiftId: 'shift_1',
        );

        expect(inv, isNotNull);
        verify(
          () => mockOpenAccountRepo.closeAccount(
            orgId: 'org_test',
            buId: 'bu_test',
            accountId: 'tab_99',
          ),
        ).called(1);
        verify(
          () => mockStockRepo.recordMovement(
            orgId: 'org_test',
            buId: 'bu_test',
            movement: any(named: 'movement'),
          ),
        ).called(1);
      },
    );

    test('finalizeInvoice with credit updates debt and creates CxC', () async {
      when(
        () => mockRepo.createInvoice(
          orgId: any(named: 'orgId'),
          buId: any(named: 'buId'),
          invoice: any(named: 'invoice'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => mockArRepo.saveAccountReceivable(
          orgId: any(named: 'orgId'),
          buId: any(named: 'buId'),
          ar: any(named: 'ar'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => mockCustomerRepo.updateDebtBalance(
          orgId: any(named: 'orgId'),
          customerId: any(named: 'customerId'),
          newBalance: any(named: 'newBalance'),
        ),
      ).thenAnswer((_) async {});

      provider.selectCustomer(dummyCustomer);
      // Cart total is 16.10. Pay 6.10 cash, 10.00 credit
      provider.updateTenderAmounts(cash: 6.10, card: 0.0, credit: 10.00);

      final inv = await provider.finalizeInvoice(
        orgId: 'org_test',
        buId: 'bu_test',
        cashierId: 'usr_cashier',
        cashShiftId: 'shift_1',
      );

      expect(inv, isNotNull);
      expect(inv!.creditCarriedOver, equals(10.00));
      verify(
        () => mockArRepo.saveAccountReceivable(
          orgId: 'org_test',
          buId: 'bu_test',
          ar: any(named: 'ar'),
        ),
      ).called(1);
      verify(
        () => mockCustomerRepo.updateDebtBalance(
          orgId: 'org_test',
          customerId: dummyCustomer.id,
          newBalance: dummyCustomer.currentDebtBalance + 10.00,
        ),
      ).called(1);
    });

    test(
      'finalizeInvoice sets error status and returns null when repository fails',
      () async {
        when(
          () => mockRepo.createInvoice(
            orgId: any(named: 'orgId'),
            buId: any(named: 'buId'),
            invoice: any(named: 'invoice'),
          ),
        ).thenThrow(Exception('Firestore write failed'));

        provider.updateTenderAmounts(cash: 20.0, card: 0.0, credit: 0.0);

        final inv = await provider.finalizeInvoice(
          orgId: 'org_test',
          buId: 'bu_test',
          cashierId: 'usr_cashier',
          cashShiftId: 'shift_1',
        );

        expect(inv, isNull);
        expect(provider.status, equals(FeatureStatusEnum.error));
        expect(provider.errorMessage, contains('Firestore write failed'));
      },
    );
  });

  group('PosCheckoutScreen Widget Tests', () {
    setUp(() async {
      await setupSeededLocator();
    });

    tearDown(() async {
      await resetLocator();
    });

    testWidgets(
      'renders cart items, tender controls, and opens customer modal',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 720);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          const LogistoApp(locale: Locale('en'), home: PosCheckoutScreen()),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('POS Checkout'), findsOneWidget);
        expect(find.text('Sale Summary & Items'), findsOneWidget);
        expect(find.text('Multi-Tender Payment'), findsOneWidget);

        // Tap Customer
        expect(find.text('Customer'), findsOneWidget);
        await tester.tap(find.text('Customer'));
        await tester.pumpAndSettle();

        expect(find.text('Select or Register Customer'), findsOneWidget);
        expect(find.text('Consumidor Final (Walk-in)'), findsWidgets);

        // Tap Walk-in
        final selectBtns = find.text('Select');
        expect(selectBtns, findsWidgets);
        await tester.tap(selectBtns.first);
        await tester.pumpAndSettle();

        expect(find.text('Select or Register Customer'), findsNothing);
      },
    );
  });
}
