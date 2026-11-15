import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/audit_action_enum.dart';
import 'package:logisto/core/enums/movement_type_enum.dart';
import 'package:logisto/core/enums/payment_method_enum.dart';
import 'package:logisto/core/enums/purchase_order_status_enum.dart';
import 'package:logisto/data/repositories/account_payable_repository.dart';
import 'package:logisto/data/repositories/account_receivable_repository.dart';
import 'package:logisto/data/repositories/audit_log_repository.dart';
import 'package:logisto/data/repositories/customer_repository.dart';
import 'package:logisto/data/repositories/purchase_order_repository.dart';
import 'package:logisto/data/repositories/stock_movement_repository.dart';
import 'package:logisto/data/repositories/supplier_repository.dart';
import 'package:logisto/domain/models/account_payable_model.dart';
import 'package:logisto/domain/models/account_receivable_model.dart';
import 'package:logisto/domain/models/audit_log_model.dart';
import 'package:logisto/domain/models/customer_model.dart';
import 'package:logisto/domain/models/purchase_order_model.dart';
import 'package:logisto/domain/models/stock_movement_model.dart';
import 'package:logisto/domain/models/supplier_model.dart';
import 'package:logisto/presentation/audit/audit_log_provider.dart';
import 'package:logisto/presentation/payables/accounts_payable_provider.dart';
import 'package:logisto/presentation/purchasing/purchase_order_provider.dart';
import 'package:logisto/presentation/receivables/accounts_receivable_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountReceivableRepository extends Mock
    implements AccountReceivableRepository {}

class MockCustomerRepository extends Mock implements CustomerRepository {}

class MockPurchaseOrderRepository extends Mock
    implements PurchaseOrderRepository {}

class MockAccountPayableRepository extends Mock
    implements AccountPayableRepository {}

class MockStockMovementRepository extends Mock
    implements StockMovementRepository {}

class MockSupplierRepository extends Mock implements SupplierRepository {}

class MockAuditLogRepository extends Mock implements AuditLogRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(
      CreditPaymentModel(
        id: 'pay_fallback',
        receivableId: 'cxc_1',
        amount: 10.0,
        method: PaymentMethodEnum.cash,
        cashierUserId: 'usr_1',
        receivedAt: DateTime.now(),
      ),
    );
    registerFallbackValue(
      AccountReceivableModel(
        id: 'cxc_fallback',
        buId: 'bu_1',
        customerId: 'cust_1',
        customerName: 'Customer 1',
        invoiceId: 'inv_1',
        invoiceNumber: 'FAC-1',
        originalAmount: 50.0,
        pendingAmount: 50.0,
        dueDate: DateTime.now(),
        createdAt: DateTime.now(),
      ),
    );
    registerFallbackValue(
      AccountPayableModel(
        id: 'cxp_fallback',
        buId: 'bu_1',
        supplierId: 'sup_1',
        supplierName: 'Supplier 1',
        invoiceNumber: 'PROV-1',
        amount: 100.0,
        paidAmount: 0.0,
        dueDate: DateTime.now(),
        createdAt: DateTime.now(),
      ),
    );
    registerFallbackValue(
      SupplierModel(
        id: 'sup_fallback',
        orgId: 'org_1',
        companyName: 'Supplier 1',
        taxId: 'J000',
        contactPerson: 'Contact 1',
        phone: '555',
      ),
    );
    registerFallbackValue(
      StockMovementModel(
        id: 'mov_fallback',
        buId: 'bu_1',
        warehouseId: 'wh_main',
        productId: 'prod_1',
        productName: 'Product 1',
        movementType: MovementTypeEnum.purchaseReceipt,
        quantity: 10,
        unitCost: 1.0,
        totalCost: 10.0,
        referenceId: 'PO-1',
        timestamp: DateTime.now(),
      ),
    );
    registerFallbackValue(
      PurchaseOrderModel(
        id: 'po_fallback',
        buId: 'bu_1',
        supplierId: 'sup_1',
        supplierName: 'Supplier 1',
        orderDate: DateTime.now(),
        expectedDeliveryDate: DateTime.now(),
        items: const [],
        totalAmount: 100.0,
        status: PurchaseOrderStatusEnum.ordered,
      ),
    );
    registerFallbackValue(
      AuditLogModel(
        id: 'aud_fallback',
        orgId: 'org_1',
        buId: 'bu_1',
        userId: 'usr_1',
        userDisplayName: 'User 1',
        action: AuditActionEnum.applyDiscount,
        description: 'Discount applied',
        timestamp: DateTime.now(),
      ),
    );
  });

  group('AccountsReceivableProvider Financial Loop Tests', () {
    late MockAccountReceivableRepository mockArRepo;
    late MockCustomerRepository mockCustomerRepo;
    late AccountsReceivableProvider provider;

    final dummyReceivable = AccountReceivableModel(
      id: 'cxc_01',
      buId: 'bu_test',
      customerId: 'cust_01',
      customerName: 'Roberto Gómez',
      invoiceId: 'inv_01',
      invoiceNumber: 'FAC-001',
      originalAmount: 100.0,
      pendingAmount: 100.0,
      dueDate: DateTime.now().add(const Duration(days: 30)),
      createdAt: DateTime.now(),
    );

    final dummyCustomer = CustomerModel(
      id: 'cust_01',
      orgId: 'org_test',
      taxId: '001-J031',
      firstName: 'Roberto',
      lastName: 'Gómez',
      phone: '8888',
      creditLimit: 500.0,
      currentDebtBalance: 100.0,
      createdAt: DateTime.now(),
    );

    setUp(() {
      mockArRepo = MockAccountReceivableRepository();
      mockCustomerRepo = MockCustomerRepository();
      provider = AccountsReceivableProvider(
        repository: mockArRepo,
        customerRepository: mockCustomerRepo,
      );
    });

    test(
      'recordPayment decrements pendingAmount, calls arRepo and updates customer debt balance',
      () async {
        when(
          () => mockArRepo.getAccountsReceivable(
            orgId: 'org_test',
            buId: 'bu_test',
          ),
        ).thenAnswer((_) async => [dummyReceivable]);
        when(
          () => mockArRepo.recordPayment(
            orgId: any(named: 'orgId'),
            buId: any(named: 'buId'),
            arId: any(named: 'arId'),
            payment: any(named: 'payment'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockCustomerRepo.getCustomerById(
            orgId: any(named: 'orgId'),
            customerId: any(named: 'customerId'),
          ),
        ).thenAnswer((_) async => dummyCustomer);
        when(
          () => mockCustomerRepo.updateDebtBalance(
            orgId: any(named: 'orgId'),
            customerId: any(named: 'customerId'),
            newBalance: any(named: 'newBalance'),
          ),
        ).thenAnswer((_) async {});

        await provider.loadReceivables(orgId: 'org_test', buId: 'bu_test');
        expect(provider.receivables.first.pendingAmount, equals(100.0));

        // Make a partial payment of 40.0
        await provider.recordPayment(
          receivableId: 'cxc_01',
          amount: 40.0,
          method: PaymentMethodEnum.cash,
        );

        expect(provider.receivables.first.pendingAmount, equals(60.0));
        verify(
          () => mockArRepo.recordPayment(
            orgId: 'org_test',
            buId: 'bu_test',
            arId: 'cxc_01',
            payment: any(named: 'payment'),
          ),
        ).called(1);
        verify(
          () => mockCustomerRepo.updateDebtBalance(
            orgId: 'org_test',
            customerId: 'cust_01',
            newBalance: 60.0, // 100 - 40
          ),
        ).called(1);
      },
    );
  });

  group('PurchaseOrderProvider Procurement & Kardex Tests', () {
    late MockPurchaseOrderRepository mockPoRepo;
    late MockAccountPayableRepository mockApRepo;
    late MockStockMovementRepository mockStockRepo;
    late MockSupplierRepository mockSupplierRepo;
    late PurchaseOrderProvider provider;

    final dummyOrder = PurchaseOrderModel(
      id: 'po_01',
      buId: 'bu_test',
      supplierId: 'sup_01',
      supplierName: 'Cervecería Nacional',
      orderDate: DateTime.now().subtract(const Duration(days: 2)),
      expectedDeliveryDate: DateTime.now(),
      items: const [
        PurchaseOrderItemModel(
          productId: 'prod_beer',
          productName: 'Cerveza Toña',
          quantityOrdered: 100.0,
          quantityReceived: 0.0,
          unitCost: 1.20,
          totalCost: 120.0,
        ),
      ],
      totalAmount: 120.0,
      status: PurchaseOrderStatusEnum.ordered,
    );

    final dummySupplier = SupplierModel(
      id: 'sup_01',
      orgId: 'org_test',
      companyName: 'Cervecería Nacional',
      taxId: 'J0001',
      contactPerson: 'Mario',
      phone: '2222',
      currentPayableBalance: 500.0,
    );

    setUp(() {
      mockPoRepo = MockPurchaseOrderRepository();
      mockApRepo = MockAccountPayableRepository();
      mockStockRepo = MockStockMovementRepository();
      mockSupplierRepo = MockSupplierRepository();

      provider = PurchaseOrderProvider(
        repository: mockPoRepo,
        accountPayableRepository: mockApRepo,
        stockMovementRepository: mockStockRepo,
        supplierRepository: mockSupplierRepo,
      );
    });

    test(
      'receiveGoods marks PO received, creates CxP, updates supplier balance, and logs Kardex receipt',
      () async {
        when(
          () =>
              mockPoRepo.getPurchaseOrders(orgId: 'org_test', buId: 'bu_test'),
        ).thenAnswer((_) async => [dummyOrder]);
        when(
          () => mockPoRepo.savePurchaseOrder(
            orgId: any(named: 'orgId'),
            buId: any(named: 'buId'),
            order: any(named: 'order'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockApRepo.saveAccountPayable(
            orgId: any(named: 'orgId'),
            buId: any(named: 'buId'),
            ap: any(named: 'ap'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockSupplierRepo.getSupplierById(
            orgId: any(named: 'orgId'),
            supplierId: any(named: 'supplierId'),
          ),
        ).thenAnswer((_) async => dummySupplier);
        when(
          () => mockSupplierRepo.saveSupplier(
            orgId: any(named: 'orgId'),
            supplier: any(named: 'supplier'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockStockRepo.recordMovement(
            orgId: any(named: 'orgId'),
            buId: any(named: 'buId'),
            movement: any(named: 'movement'),
          ),
        ).thenAnswer((_) async {});

        await provider.loadOrders(orgId: 'org_test', buId: 'bu_test');
        expect(provider.orders.first.status, equals(PurchaseOrderStatusEnum.ordered));

        await provider.receiveGoods('po_01');

        expect(provider.orders.first.status, equals(PurchaseOrderStatusEnum.received));
        expect(
          provider.orders.first.items.first.quantityReceived,
          equals(100.0),
        );

        // Verify Accounts Payable created
        verify(
          () => mockApRepo.saveAccountPayable(
            orgId: 'org_test',
            buId: 'bu_test',
            ap: any(named: 'ap'),
          ),
        ).called(1);

        // Verify Supplier balance updated
        verify(
          () => mockSupplierRepo.saveSupplier(
            orgId: 'org_test',
            supplier: any(
              named: 'supplier',
              that: isA<SupplierModel>().having(
                (s) => s.currentPayableBalance,
                'currentPayableBalance',
                equals(620.0), // 500 + 120
              ),
            ),
          ),
        ).called(1);

        // Verify Kardex purchase receipt movement
        verify(
          () => mockStockRepo.recordMovement(
            orgId: 'org_test',
            buId: 'bu_test',
            movement: any(
              named: 'movement',
              that: isA<StockMovementModel>().having(
                (m) => m.movementType,
                'movementType',
                equals(MovementTypeEnum.purchaseReceipt),
              ),
            ),
          ),
        ).called(1);
      },
    );
  });

  group('AccountsPayableProvider Disbursement Tests', () {
    late MockAccountPayableRepository mockApRepo;
    late MockSupplierRepository mockSupplierRepo;
    late AccountsPayableProvider provider;

    final dummyPayable = AccountPayableModel(
      id: 'cxp_01',
      buId: 'bu_test',
      supplierId: 'sup_01',
      supplierName: 'Cervecería Nacional',
      invoiceNumber: 'PROV-999',
      amount: 500.0,
      paidAmount: 100.0,
      dueDate: DateTime.now().add(const Duration(days: 10)),
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    );

    final dummySupplier = SupplierModel(
      id: 'sup_01',
      orgId: 'org_test',
      companyName: 'Cervecería Nacional',
      taxId: 'J0001',
      contactPerson: 'Mario',
      phone: '2222',
      currentPayableBalance: 400.0,
    );

    setUp(() {
      mockApRepo = MockAccountPayableRepository();
      mockSupplierRepo = MockSupplierRepository();
      provider = AccountsPayableProvider(
        repository: mockApRepo,
        supplierRepository: mockSupplierRepo,
      );
    });

    test(
      'recordPayment increases paidAmount, saves AP, and decreases supplier liability',
      () async {
        when(
          () =>
              mockApRepo.getAccountsPayable(orgId: 'org_test', buId: 'bu_test'),
        ).thenAnswer((_) async => [dummyPayable]);
        when(
          () => mockApRepo.saveAccountPayable(
            orgId: any(named: 'orgId'),
            buId: any(named: 'buId'),
            ap: any(named: 'ap'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockSupplierRepo.getSupplierById(
            orgId: any(named: 'orgId'),
            supplierId: any(named: 'supplierId'),
          ),
        ).thenAnswer((_) async => dummySupplier);
        when(
          () => mockSupplierRepo.saveSupplier(
            orgId: any(named: 'orgId'),
            supplier: any(named: 'supplier'),
          ),
        ).thenAnswer((_) async {});

        await provider.loadPayables(orgId: 'org_test', buId: 'bu_test');
        expect(provider.payables.first.paidAmount, equals(100.0));

        await provider.recordPayment(payableId: 'cxp_01', amount: 200.0);

        expect(provider.payables.first.paidAmount, equals(300.0));
        verify(
          () => mockApRepo.saveAccountPayable(
            orgId: 'org_test',
            buId: 'bu_test',
            ap: any(named: 'ap'),
          ),
        ).called(1);
        verify(
          () => mockSupplierRepo.saveSupplier(
            orgId: 'org_test',
            supplier: any(
              named: 'supplier',
              that: isA<SupplierModel>().having(
                (s) => s.currentPayableBalance,
                'currentPayableBalance',
                equals(200.0), // 400 - 200
              ),
            ),
          ),
        ).called(1);
      },
    );
  });

  group('AuditLogProvider Tests', () {
    late MockAuditLogRepository mockAuditRepo;
    late AuditLogProvider provider;

    setUp(() {
      mockAuditRepo = MockAuditLogRepository();
      provider = AuditLogProvider(repository: mockAuditRepo);
    });

    test('recordLog logs action to repository and appends to state', () async {
      when(() => mockAuditRepo.logAction(any())).thenAnswer((_) async {});

      final log = AuditLogModel(
        id: 'aud_test',
        orgId: 'org_test',
        buId: 'bu_test',
        userId: 'usr_1',
        userDisplayName: 'Admin User',
        action: AuditActionEnum.voidItem,
        description: 'Voided item from cart',
        timestamp: DateTime.now(),
      );

      await provider.recordLog(log);

      expect(provider.logs.first.id, equals('aud_test'));
      expect(provider.logs.first.action, equals(AuditActionEnum.voidItem));
      verify(() => mockAuditRepo.logAction(log)).called(1);
    });
  });
}
