import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/account_status_enum.dart';
import 'package:logisto/core/enums/audit_action_enum.dart';
import 'package:logisto/core/enums/business_type_enum.dart';
import 'package:logisto/core/enums/invoice_status_enum.dart';
import 'package:logisto/core/enums/kds_status_enum.dart';
import 'package:logisto/core/enums/movement_type_enum.dart';
import 'package:logisto/core/enums/payment_method_enum.dart';
import 'package:logisto/core/enums/product_type_enum.dart';
import 'package:logisto/core/enums/shift_status_enum.dart';
import 'package:logisto/core/enums/table_status_enum.dart';
import 'package:logisto/core/enums/table_type_enum.dart';
import 'package:logisto/core/enums/user_role_enum.dart';
import 'package:logisto/domain/models/account_payable_model.dart';
import 'package:logisto/domain/models/account_receivable_model.dart';
import 'package:logisto/domain/models/audit_log_model.dart';
import 'package:logisto/domain/models/billiard_table_model.dart';
import 'package:logisto/domain/models/business_unit_model.dart';
import 'package:logisto/domain/models/cash_shift_model.dart';
import 'package:logisto/domain/models/customer_model.dart';
import 'package:logisto/domain/models/dashboard_metrics_model.dart';
import 'package:logisto/domain/models/invoice_model.dart';
import 'package:logisto/domain/models/kitchen_order_model.dart';
import 'package:logisto/domain/models/open_account_model.dart';
import 'package:logisto/domain/models/organization_model.dart';
import 'package:logisto/domain/models/product_model.dart';
import 'package:logisto/domain/models/purchase_order_model.dart';
import 'package:logisto/domain/models/rbac_permission_model.dart';
import 'package:logisto/domain/models/stock_movement_model.dart';
import 'package:logisto/domain/models/supplier_model.dart';
import 'package:logisto/domain/models/user_profile_model.dart';
import 'package:logisto/domain/models/warehouse_model.dart';

void main() {
  final now = DateTime(2026, 11, 12, 12, 0, 0);

  group('Domain Models Serialization and Behavior Tests', () {
    test('OrganizationModel roundtrips toMap and fromMap', () {
      final org = OrganizationModel(
        id: 'org_castillo',
        legalName: 'Inversiones Castillo Machado S.A.',
        commercialName: 'Castillo Machado',
        taxId: 'J0310000123456',
        ownerUserId: 'uid_admin_carlos',
        createdAt: now,
      );

      final map = org.toMap();
      final restored = OrganizationModel.fromMap(map);

      expect(restored.id, org.id);
      expect(restored.legalName, org.legalName);
      expect(restored.commercialName, org.commercialName);
      expect(restored.taxId, org.taxId);
      expect(restored.baseCurrency, 'USD');
      expect(restored.exchangeRate, 36.65);
      expect(restored.hasCompletedOnboarding, isFalse);
    });

    test('BusinessUnitModel roundtrips and handles copyWith', () {
      final bu = BusinessUnitModel(
        id: 'bu_billar',
        orgId: 'org_castillo',
        name: 'Billares Central',
        taxId: 'J0310000123456-1',
        phone: '+505 8888 9999',
        address: 'Semáforos Dancing',
        businessType: BusinessTypeEnum.billiard,
        isBilliardHall: true,
        createdAt: now,
      );

      final map = bu.toMap();
      final restored = BusinessUnitModel.fromMap(map);

      expect(restored.businessType, BusinessTypeEnum.billiard);
      expect(restored.isBilliardHall, isTrue);

      final updated = restored.copyWith(name: 'Billares VIP');
      expect(updated.name, 'Billares VIP');
      expect(updated.id, 'bu_billar');
    });

    test(
      'UserProfileModel checks business unit roles and superadmin override',
      () {
        final user = UserProfileModel(
          uid: 'usr_juan',
          orgId: 'org_castillo',
          email: 'juan@castillo.com',
          displayName: 'Juan Perez',
          isSuperAdmin: false,
          businessUnitRoles: {
            'bu_tienda': UserRoleEnum.adminBusinessUnit,
            'bu_billar': UserRoleEnum.cashier,
          },
        );

        expect(
          user.roleInBusinessUnit('bu_tienda'),
          UserRoleEnum.adminBusinessUnit,
        );
        expect(user.roleInBusinessUnit('bu_billar'), UserRoleEnum.cashier);
        expect(user.roleInBusinessUnit('bu_farmacia'), UserRoleEnum.cashier);

        final superUser = user.copyWith(isSuperAdmin: true);
        expect(
          superUser.roleInBusinessUnit('bu_billar'),
          UserRoleEnum.superAdminOrg,
        );
      },
    );

    test('BilliardTableModel and BilliardSessionModel roundtrip', () {
      final session = BilliardSessionModel(
        sessionId: 'ses_1',
        customerName: 'Carlos Gómez',
        startTime: now,
        accumulatedSeconds: 1200,
        isPaused: true,
      );

      final table = BilliardTableModel(
        id: 'tbl_1',
        tableNumber: 1,
        name: 'Mesa 1',
        tableType: TableTypeEnum.pool,
        hourlyRate: 12.0,
        status: TableStatusEnum.paused,
        currentSession: session,
      );

      final map = table.toMap();
      final restored = BilliardTableModel.fromMap(map);

      expect(restored.tableNumber, 1);
      expect(restored.status, TableStatusEnum.paused);
      expect(restored.currentSession?.customerName, 'Carlos Gómez');
      expect(restored.currentSession?.accumulatedSeconds, 1200);
      expect(restored.currentSession?.isPaused, isTrue);
    });

    test('OpenAccountModel handles items and total calculation', () {
      final item1 = const AccountItemModel(
        productId: 'prod_beer',
        name: 'Toña 350ml',
        quantity: 2,
        unitPrice: 1.75,
        total: 3.50,
      );
      final item2 = const AccountItemModel(
        productId: 'srv_time',
        name: 'Tiempo Mesa 1',
        quantity: 1,
        unitPrice: 5.00,
        total: 5.00,
        isBilliardTime: true,
      );

      final account = OpenAccountModel(
        id: 'tab_1',
        code: 'TAB-001',
        originType: 'table',
        customerDisplayName: 'Roberto Gómez',
        status: AccountStatusEnum.open,
        items: [item1, item2],
        totalAmount: 8.50,
        openedAt: now,
      );

      final map = account.toMap();
      final restored = OpenAccountModel.fromMap(map);

      expect(restored.items.length, 2);
      expect(restored.totalAmount, 8.50);
      expect(restored.items.any((i) => i.isBilliardTime), isTrue);
    });

    test(
      'CustomerModel calculates available credit and evaluates charging headroom',
      () {
        final customer = CustomerModel(
          id: 'cust_1',
          orgId: 'org_castillo',
          taxId: '001-150490-0002U',
          firstName: 'Roberto',
          lastName: 'Gómez',
          phone: '+505 8765 4321',
          creditLimit: 300.0,
          currentDebtBalance: 100.0,
          createdAt: now,
        );

        expect(customer.fullName, 'Roberto Gómez');
        expect(customer.availableCredit, 200.0);
        expect(customer.canChargeCredit(150.0), isTrue);
        expect(customer.canChargeCredit(201.0), isFalse);

        // Binary float precision test: 45.10 + 54.90 produces 100.00000000000001 in IEEE 754
        final precisionCustomer = customer.copyWith(
          creditLimit: 100.0,
          currentDebtBalance: 45.10,
        );
        expect(precisionCustomer.canChargeCredit(54.90), isTrue);
        expect(precisionCustomer.canChargeCredit(54.91), isFalse);
        expect(precisionCustomer.canChargeCredit(-10.0), isFalse);

        final blocked = customer.copyWith(isCreditBlocked: true);
        expect(blocked.canChargeCredit(50.0), isFalse);
      },
    );

    test('Models safely parse raw dynamic nested maps without TypeError', () {
      // Simulating raw untyped Firestore responses: Map<dynamic, dynamic>
      final rawInvoiceMap = <String, dynamic>{
        'id': 'inv_dyn_1',
        'invoiceNumber': 'INV-001',
        'cashShiftId': 'shift_1',
        'cashierUserId': 'usr_1',
        'customerDisplayName': 'Guest',
        'items': <dynamic>[
          <dynamic, dynamic>{
            'productId': 'prod_1',
            'name': 'Beer',
            'quantity': 2,
            'unitPrice': 1.5,
            'total': 3.0,
          },
        ],
        'subtotal': 3.0,
        'taxAmount': 0.45,
        'totalAmount': 3.45,
        'payments': <dynamic>[
          <dynamic, dynamic>{'method': 'cash', 'amount': 3.45},
        ],
        'paymentStatus': 'paid',
        'createdAt': '2026-11-12T00:00:00.000Z',
      };

      final invoice = InvoiceModel.fromMap(rawInvoiceMap);
      expect(invoice.items.length, 1);
      expect(invoice.items.first.name, 'Beer');
      expect(invoice.payments.first.amount, 3.45);

      final rawProductMap = <String, dynamic>{
        'id': 'prod_pack',
        'orgId': 'org_1',
        'sku': 'PACK-1',
        'name': 'Pack 6',
        'categoryId': 'cat_1',
        'productType': 'pack',
        'costPrice': 5.0,
        'salePrice': 8.0,
        'recipe': <dynamic>[
          <dynamic, dynamic>{'productId': 'prod_beer', 'quantity': 6},
        ],
      };

      final product = ProductModel.fromMap(rawProductMap);
      expect(product.recipe.length, 1);
      expect(product.recipe.first.quantity, 6.0);
    });

    test('CashShiftModel computes expected balance and roundtrips', () {
      final expected = CashShiftModel.computeExpectedBalance(
        opening: 100.0,
        sales: 450.0,
        injections: 50.0,
        withdrawals: 100.0,
      );
      expect(expected, 500.0);

      final shift = CashShiftModel(
        id: 'shift_1',
        buId: 'bu_billar',
        cashRegisterNumber: 1,
        cashierUserId: 'usr_juan',
        openedAt: now,
        openingBalance: 100.0,
        cashSales: 450.0,
        cashWithdrawals: 100.0,
        expectedCashBalance: 450.0,
        status: ShiftStatusEnum.open,
      );

      final map = shift.toMap();
      final restored = CashShiftModel.fromMap(map);
      expect(restored.cashierUserId, 'usr_juan');
      expect(restored.expectedCashBalance, 450.0);
      expect(restored.status, ShiftStatusEnum.open);
    });

    test(
      'InvoiceModel, ProductModel, SupplierModel, WarehouseModel roundtrip',
      () {
        final invoice = InvoiceModel(
          id: 'inv_1',
          invoiceNumber: 'FAC-001',
          cashShiftId: 'shift_1',
          cashierUserId: 'usr_juan',
          customerDisplayName: 'Roberto',
          items: const [
            InvoiceItemModel(
              productId: 'p1',
              name: 'Item 1',
              quantity: 1,
              unitPrice: 10.0,
              total: 10.0,
            ),
          ],
          subtotal: 10.0,
          taxAmount: 1.5,
          totalAmount: 11.5,
          payments: const [
            PaymentTenderModel(method: PaymentMethodEnum.cash, amount: 11.5),
          ],
          paymentStatus: InvoiceStatusEnum.paid,
          createdAt: now,
        );

        expect(InvoiceModel.fromMap(invoice.toMap()).invoiceNumber, 'FAC-001');

        final product = ProductModel(
          id: 'prod_1',
          orgId: 'org_castillo',
          sku: 'SKU-01',
          name: 'Beer',
          categoryId: 'cat_beverages',
          productType: ProductTypeEnum.standard,
          costPrice: 1.0,
          salePrice: 2.0,
        );
        expect(ProductModel.fromMap(product.toMap()).name, 'Beer');

        final supplier = SupplierModel(
          id: 'sup_1',
          orgId: 'org_castillo',
          companyName: 'Cervecería',
          taxId: 'J001',
          contactPerson: 'Mario',
          phone: '123',
        );
        expect(
          SupplierModel.fromMap(supplier.toMap()).companyName,
          'Cervecería',
        );

        final warehouse = WarehouseModel(
          id: 'wh_1',
          buId: 'bu_billar',
          name: 'Central',
          code: 'WH-01',
          isSalesDefault: true,
        );
        expect(WarehouseModel.fromMap(warehouse.toMap()).name, 'Central');
      },
    );

    test('DashboardMetricsModel computes growth and parses maps', () {
      final metrics = DashboardMetricsModel(
        todaySales: 1500.0,
        yesterdaySales: 1000.0,
        weekSales: 5000.0,
        salesByCategory: {'Beverages': 800.0, 'Billiard': 700.0},
        salesByPaymentMethod: {
          PaymentMethodEnum.cash: 1000.0,
          PaymentMethodEnum.card: 500.0,
        },
      );

      expect(metrics.dailyGrowthPercentage, 50.0);
      final restored = DashboardMetricsModel.fromMap(metrics.toMap());
      expect(restored.todaySales, 1500.0);
      expect(restored.salesByCategory['Beverages'], 800.0);
      expect(restored.salesByPaymentMethod[PaymentMethodEnum.cash], 1000.0);
    });

    test(
      'AccountReceivableModel and AccountPayableModel verify remaining balance',
      () {
        final ar = AccountReceivableModel(
          id: 'ar_1',
          buId: 'bu_1',
          customerId: 'c1',
          customerName: 'Roberto',
          invoiceId: 'i1',
          invoiceNumber: 'FAC-001',
          originalAmount: 100.0,
          pendingAmount: 50.0,
          dueDate: now.add(const Duration(days: 15)),
          createdAt: now,
        );
        expect(ar.isOverdue, isFalse);

        final ap = AccountPayableModel(
          id: 'ap_1',
          buId: 'bu_1',
          supplierId: 's1',
          supplierName: 'Cervecería',
          invoiceNumber: 'FAC-PROV-1',
          amount: 200.0,
          paidAmount: 50.0,
          dueDate: now.add(const Duration(days: 30)),
          createdAt: now,
        );
        expect(ap.remainingBalance, 150.0);
        expect(ap.isSettled, isFalse);
      },
    );

    test(
      'PurchaseOrderModel, StockMovementModel, KitchenOrderModel, AuditLogModel roundtrip',
      () {
        final po = PurchaseOrderModel(
          id: 'po_1',
          buId: 'bu_1',
          supplierId: 's1',
          supplierName: 'Sup',
          orderDate: now,
          totalAmount: 500.0,
        );
        expect(PurchaseOrderModel.fromMap(po.toMap()).totalAmount, 500.0);

        final sm = StockMovementModel(
          id: 'sm_1',
          buId: 'bu_1',
          warehouseId: 'wh_1',
          productId: 'p1',
          productName: 'Beer',
          movementType: MovementTypeEnum.purchaseReceipt,
          quantity: 24.0,
          unitCost: 1.0,
          totalCost: 24.0,
          timestamp: now,
        );
        expect(StockMovementModel.fromMap(sm.toMap()).quantity, 24.0);

        final ko = KitchenOrderModel(
          id: 'ko_1',
          buId: 'bu_1',
          orderCode: 'K-01',
          tableOrTabName: 'Mesa 1',
          items: const [
            KitchenOrderItemModel(
              productId: 'p1',
              productName: 'Hamburguesa',
              quantity: 1,
              notes: 'sin cebolla',
            ),
          ],
          status: KdsStatusEnum.pending,
          createdAt: now,
        );
        expect(
          KitchenOrderModel.fromMap(ko.toMap()).items.first.notes,
          'sin cebolla',
        );

        final audit = AuditLogModel(
          id: 'aud_1',
          orgId: 'org_1',
          buId: 'bu_1',
          userId: 'u1',
          userDisplayName: 'Admin',
          action: AuditActionEnum.applyDiscount,
          description: 'Discount 10%',
          timestamp: now,
        );
        expect(
          AuditLogModel.fromMap(audit.toMap()).action,
          AuditActionEnum.applyDiscount,
        );
      },
    );

    test('RbacPermissionModel checks module access and atomic actions', () {
      const superAdmin = RbacPermissionModel.superAdmin;
      expect(superAdmin.hasModuleAccess('pos'), isTrue);
      expect(superAdmin.hasActionPermission('pos.apply_discount'), isTrue);

      const cashier = RbacPermissionModel.cashier;
      expect(cashier.hasModuleAccess('pos'), isTrue);
      expect(cashier.hasModuleAccess('settings'), isFalse);
      expect(cashier.hasActionPermission('pos.apply_discount'), isFalse);
      expect(cashier.hasActionPermission('cash.close_shift'), isTrue);
    });
  });
}
