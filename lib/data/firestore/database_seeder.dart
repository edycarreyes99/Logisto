import '../../core/enums/account_origin_type_enum.dart';
import '../../core/enums/account_status_enum.dart';
import '../../core/enums/audit_action_enum.dart';
import '../../core/enums/business_type_enum.dart';
import '../../core/enums/invoice_status_enum.dart';
import '../../core/enums/kds_status_enum.dart';
import '../../core/enums/movement_type_enum.dart';
import '../../core/enums/payment_method_enum.dart';
import '../../core/enums/product_type_enum.dart';
import '../../core/enums/purchase_order_status_enum.dart';
import '../../core/enums/shift_status_enum.dart';
import '../../core/enums/table_status_enum.dart';
import '../../core/enums/table_type_enum.dart';
import '../../core/enums/user_role_enum.dart';
import '../../core/enums/user_status_enum.dart';
import '../../domain/models/account_payable_model.dart';
import '../../domain/models/account_receivable_model.dart';
import '../../domain/models/audit_log_model.dart';
import '../../domain/models/billiard_table_model.dart';
import '../../domain/models/business_unit_model.dart';
import '../../domain/models/cash_shift_model.dart';
import '../../domain/models/customer_model.dart';
import '../../domain/models/dashboard_metrics_model.dart';
import '../../domain/models/invoice_model.dart';
import '../../domain/models/kitchen_order_model.dart';
import '../../domain/models/open_account_model.dart';
import '../../domain/models/organization_model.dart';
import '../../domain/models/product_model.dart';
import '../../domain/models/purchase_order_model.dart';
import '../../domain/models/stock_movement_model.dart';
import '../../domain/models/supplier_model.dart';
import '../../domain/models/user_profile_model.dart';
import '../../domain/models/warehouse_model.dart';
import 'firestore_client.dart';

/// Enterprise database seeder populating Cloud Firestore collections and documents
/// with genuine operational seeds, strictly eliminating client-side UI mockups.
class DatabaseSeeder {
  final FirestoreClient client;

  const DatabaseSeeder({required this.client});

  static const String defaultOrgId = 'org_logisto_matriz';
  static const String defaultBuCentralId = 'bu_matriz_central';
  static const String defaultBuNorteId = 'bu_sucursal_norte';

  /// Checks if the default organization exists and seeds the foundational dataset.
  Future<bool> seedIfEmpty({String orgId = defaultOrgId}) async {
    try {
      final doc = await client.organizations.doc(orgId).get();
      if (!doc.exists) {
        await seedProductionData(orgId: orgId);
        return true;
      }
      return false;
    } catch (_) {
      // In offline or testing sandbox, attempt seed
      try {
        await seedProductionData(orgId: orgId);
        return true;
      } catch (_) {
        return false;
      }
    }
  }

  /// Seeds all collections and documents into Cloud Firestore with production schema.
  Future<void> seedProductionData({String orgId = defaultOrgId}) async {
    // 1. Organization Document
    final org = OrganizationModel(
      id: orgId,
      legalName: 'Logisto Corporativo Matriz S.A.',
      commercialName: 'Logisto Matriz',
      taxId: 'J0310000012345',
      ownerUserId: 'usr_admin',
      baseCurrency: 'USD',
      secondaryCurrency: 'NIO',
      exchangeRate: 36.65,
      hasCompletedOnboarding: true,
      createdAt: DateTime.now(),
    );
    await client.organizations.doc(orgId).set(org.toMap());

    // 2. Business Units (Sucursales)
    final buCentral = BusinessUnitModel(
      id: defaultBuCentralId,
      orgId: orgId,
      name: 'Billares Central',
      taxId: 'J0310000012345-1',
      phone: '+505 2270-1235',
      address: 'Avenida Principal #120',
      businessType: BusinessTypeEnum.billiard,
      isBilliardHall: true,
      enabledModules: const [
        'pos',
        'billiards',
        'openAccounts',
        'inventory',
        'kds',
        'cash',
        'receivables',
        'payables',
        'purchasing',
        'reports',
        'users',
        'audit',
      ],
      isActive: true,
      createdAt: DateTime.now(),
    );

    final buNorte = BusinessUnitModel(
      id: defaultBuNorteId,
      orgId: orgId,
      name: 'Tienda & Distribuidora Norte',
      taxId: 'J0310000012345-2',
      phone: '+505 2270-1236',
      address: 'Centro Comercial Norte Local 14',
      businessType: BusinessTypeEnum.retail,
      isBilliardHall: false,
      enabledModules: const [
        'pos',
        'inventory',
        'cash',
        'receivables',
        'payables',
        'purchasing',
        'reports',
        'users',
        'audit',
      ],
      isActive: true,
      createdAt: DateTime.now(),
    );

    await client.businessUnits(orgId).doc(buCentral.id).set(buCentral.toMap());
    await client.businessUnits(orgId).doc(buNorte.id).set(buNorte.toMap());

    // 3. Users with Roles and PINs
    final users = [
      UserProfileModel(
        uid: 'usr_owner',
        orgId: orgId,
        email: 'carlos@logisto.com',
        displayName: 'Carlos Machado (Owner)',
        isSuperAdmin: true,
        businessUnitRoles: const {
          defaultBuCentralId: UserRoleEnum.superAdminOrg,
          defaultBuNorteId: UserRoleEnum.superAdminOrg,
        },
        pinHash: '9999',
        status: UserStatusEnum.active,
      ),
      UserProfileModel(
        uid: 'usr_admin',
        orgId: orgId,
        email: 'admin@logisto.com',
        displayName: 'Juan Pérez',
        isSuperAdmin: false,
        businessUnitRoles: const {
          defaultBuCentralId: UserRoleEnum.supervisor,
          defaultBuNorteId: UserRoleEnum.supervisor,
        },
        pinHash: '1234',
        status: UserStatusEnum.active,
      ),
      UserProfileModel(
        uid: 'usr_manager',
        orgId: orgId,
        email: 'gerente@logisto.com',
        displayName: 'Roberto Gómez (Gerente Sucursal)',
        isSuperAdmin: false,
        businessUnitRoles: const {
          defaultBuCentralId: UserRoleEnum.adminBusinessUnit,
          defaultBuNorteId: UserRoleEnum.supervisor,
        },
        pinHash: '2345',
        status: UserStatusEnum.active,
      ),
      UserProfileModel(
        uid: 'usr_cashier',
        orgId: orgId,
        email: 'caja@logisto.com',
        displayName: 'María López',
        isSuperAdmin: false,
        businessUnitRoles: const {defaultBuCentralId: UserRoleEnum.cashier},
        pinHash: '3456',
        status: UserStatusEnum.active,
      ),
      UserProfileModel(
        uid: 'usr_waiter',
        orgId: orgId,
        email: 'mesero@logisto.com',
        displayName: 'Carlos Ruiz (Mesero / Capitán)',
        isSuperAdmin: false,
        businessUnitRoles: const {defaultBuCentralId: UserRoleEnum.waiter},
        pinHash: '4567',
        status: UserStatusEnum.active,
      ),
    ];

    for (final u in users) {
      await client.users(orgId).doc(u.uid).set(u.toMap());
    }

    // 4. Master Products Catalog
    final products = [
      ProductModel(
        id: 'prod_tona_botella',
        orgId: orgId,
        sku: 'BEV-001',
        barcode: '7434000101',
        name: 'Cerveza Toña 350ml Botella',
        categoryId: 'beverages',
        productType: ProductTypeEnum.standard,
        costPrice: 1.00,
        salePrice: 1.75,
      ),
      ProductModel(
        id: 'prod_cubetazo_tona',
        orgId: orgId,
        sku: 'PACK-001',
        barcode: '7434000102',
        name: 'Cubetazo Toña (6 Unidades)',
        categoryId: 'beverages',
        productType: ProductTypeEnum.pack,
        costPrice: 6.00,
        salePrice: 9.50,
      ),
      ProductModel(
        id: 'prod_mojito_cubano',
        orgId: orgId,
        sku: 'BAR-001',
        barcode: '7434000103',
        name: 'Mojito Cubano Artesanal',
        categoryId: 'cocktails',
        productType: ProductTypeEnum.recipeBom,
        costPrice: 2.20,
        salePrice: 6.00,
      ),
      ProductModel(
        id: 'prod_nachos_especial',
        orgId: orgId,
        sku: 'FOOD-001',
        barcode: '7434000105',
        name: 'Nachos Mixtos con Queso Fundido',
        categoryId: 'food',
        productType: ProductTypeEnum.standard,
        costPrice: 2.50,
        salePrice: 5.50,
      ),
      ProductModel(
        id: 'prod_alitas_bufalo',
        orgId: orgId,
        sku: 'FOOD-002',
        barcode: '7434000106',
        name: 'Alitas Buffalo Picantes (12 Unidades)',
        categoryId: 'food',
        productType: ProductTypeEnum.standard,
        costPrice: 3.50,
        salePrice: 7.50,
      ),
      ProductModel(
        id: 'prod_tiempo_billar',
        orgId: orgId,
        sku: 'BIL-001',
        barcode: '7434000107',
        name: 'Alquiler Mesa Billar Pool (Por Hora)',
        categoryId: 'billiards',
        productType: ProductTypeEnum.standard,
        costPrice: 0.00,
        salePrice: 3.50,
      ),
      ProductModel(
        id: 'prod_agua_purificada',
        orgId: orgId,
        sku: 'BEV-002',
        barcode: '7434000108',
        name: 'Agua Purificada 600ml',
        categoryId: 'beverages',
        productType: ProductTypeEnum.standard,
        costPrice: 0.40,
        salePrice: 1.00,
      ),
      ProductModel(
        id: 'prod_ron_flordecana',
        orgId: orgId,
        sku: 'BAR-002',
        barcode: '7434000109',
        name: 'Trago Ron Flor de Caña 7 Años',
        categoryId: 'liquor',
        productType: ProductTypeEnum.standard,
        costPrice: 1.20,
        salePrice: 3.50,
      ),
      ProductModel(
        id: 'prod_ibuprofeno',
        orgId: orgId,
        sku: 'PHARM-001',
        barcode: '7434000110',
        name: 'Ibuprofeno 400mg Caja 20 Tab',
        categoryId: 'pharmacy',
        productType: ProductTypeEnum.standard,
        costPrice: 2.50,
        salePrice: 4.80,
        batchNumber: 'LOT-2026-X',
      ),
      ProductModel(
        id: 'prod_acetaminofen',
        orgId: orgId,
        sku: 'PHARM-002',
        barcode: '7434000111',
        name: 'Acetaminofén 500mg Blister 10 Tab',
        categoryId: 'pharmacy',
        productType: ProductTypeEnum.standard,
        costPrice: 0.80,
        salePrice: 2.00,
        batchNumber: 'LOT-2026-Y',
      ),
    ];

    for (final p in products) {
      await client.products(orgId).doc(p.id).set(p.toMap());
    }

    // 5. Warehouses & Physical Stock under defaultBuCentralId
    final whCentral = const WarehouseModel(
      id: 'wh_central',
      buId: defaultBuCentralId,
      code: 'BOD-01',
      name: 'Bodega Central de Despacho',
      isSalesDefault: true,
      isActive: true,
    );

    final whBarra = const WarehouseModel(
      id: 'wh_barra',
      buId: defaultBuCentralId,
      code: 'BOD-02',
      name: 'Bodega Operativa Barra',
      isSalesDefault: false,
      isActive: true,
    );

    await client
        .warehouses(orgId, defaultBuCentralId)
        .doc(whCentral.id)
        .set(whCentral.toMap());
    await client
        .warehouses(orgId, defaultBuCentralId)
        .doc(whBarra.id)
        .set(whBarra.toMap());

    // Populate initial stock
    final stockMap = {
      'prod_tona_botella': 150.0,
      'prod_nachos_especial': 80.0,
      'prod_alitas_bufalo': 60.0,
      'prod_agua_purificada': 200.0,
      'prod_ron_flordecana': 40.0,
      'prod_ibuprofeno': 100.0,
      'prod_acetaminofen': 120.0,
    };

    for (final entry in stockMap.entries) {
      await client
          .warehouseStock(orgId, defaultBuCentralId, 'wh_central')
          .doc(entry.key)
          .set({
            'productId': entry.key,
            'quantity': entry.value,
            'minStock': 20.0,
            'updatedAt': DateTime.now().toIso8601String(),
          });
    }

    // 6. Billiard Tables under defaultBuCentralId
    final tables = [
      const BilliardTableModel(
        id: 'table_01',
        tableNumber: 1,
        name: 'Mesa 1 - Pool Brunswick',
        tableType: TableTypeEnum.pool,
        hourlyRate: 3.50,
        status: TableStatusEnum.available,
      ),
      const BilliardTableModel(
        id: 'table_02',
        tableNumber: 2,
        name: 'Mesa 2 - Pool Diamante',
        tableType: TableTypeEnum.pool,
        hourlyRate: 3.50,
        status: TableStatusEnum.available,
      ),
      const BilliardTableModel(
        id: 'table_03',
        tableNumber: 3,
        name: 'Mesa 3 - Pool Salón VIP',
        tableType: TableTypeEnum.vip,
        hourlyRate: 5.00,
        status: TableStatusEnum.available,
      ),
      const BilliardTableModel(
        id: 'table_04',
        tableNumber: 4,
        name: 'Mesa 4 - Carambola Tres Bandas',
        tableType: TableTypeEnum.carambola,
        hourlyRate: 4.50,
        status: TableStatusEnum.available,
      ),
      const BilliardTableModel(
        id: 'table_05',
        tableNumber: 5,
        name: 'Mesa 5 - Snooker Profesional',
        tableType: TableTypeEnum.snooker,
        hourlyRate: 6.00,
        status: TableStatusEnum.available,
      ),
    ];

    for (final t in tables) {
      await client.tables(orgId, defaultBuCentralId).doc(t.id).set(t.toMap());
    }

    // 7. Customers with Credit Limits
    final customers = [
      CustomerModel(
        id: 'cust_cf',
        orgId: orgId,
        taxId: '000-000000-0000X',
        firstName: 'Consumidor',
        lastName: 'Final (CF)',
        phone: 'N/A',
        email: 'cf@logisto.com',
        creditLimit: 0.0,
        currentDebtBalance: 0.0,
        isCreditBlocked: false,
        createdAt: DateTime.now(),
      ),
      CustomerModel(
        id: 'cust_carlos',
        orgId: orgId,
        taxId: '001-120590-0001A',
        firstName: 'Carlos',
        lastName: 'Mendoza Solís',
        phone: '+505 8888-1111',
        email: 'carlos.mendoza@email.com',
        creditLimit: 500.0,
        currentDebtBalance: 65.0,
        isCreditBlocked: false,
        createdAt: DateTime.now(),
      ),
      CustomerModel(
        id: 'cust_brenda',
        orgId: orgId,
        taxId: '001-200388-0002B',
        firstName: 'Brenda',
        lastName: 'Morales Gómez',
        phone: '+505 8888-2222',
        email: 'brenda.morales@email.com',
        creditLimit: 300.0,
        currentDebtBalance: 0.0,
        isCreditBlocked: false,
        createdAt: DateTime.now(),
      ),
      CustomerModel(
        id: 'cust_roberto',
        orgId: orgId,
        taxId: '001-150685-0003C',
        firstName: 'Roberto',
        lastName: 'Gómez',
        phone: '+505 8888-3333',
        email: 'roberto.gomez@email.com',
        creditLimit: 250.0,
        currentDebtBalance: 45.0,
        isCreditBlocked: false,
        createdAt: DateTime.now(),
      ),
    ];

    for (final c in customers) {
      await client.customers(orgId).doc(c.id).set(c.toMap());
    }

    // 8. Suppliers
    final suppliers = [
      SupplierModel(
        id: 'sup_cerveceria',
        orgId: orgId,
        taxId: 'J031000099881',
        companyName: 'Compañía Cervecera Nacional',
        contactPerson: 'Lic. Armando Valle',
        phone: '+505 2222-3333',
        email: 'pedidos@cerveceria.com',
        creditDays: 15,
      ),
      SupplierModel(
        id: 'sup_licores',
        orgId: orgId,
        taxId: 'J031000099882',
        companyName: 'Distribuidora de Licores del Pacífico',
        contactPerson: 'Sandra Delgado',
        phone: '+505 2222-4444',
        email: 'ventas@licorespacifico.com',
        creditDays: 30,
      ),
      SupplierModel(
        id: 'sup_alimentos',
        orgId: orgId,
        taxId: 'J031000099883',
        companyName: 'Distribuidora de Carnes y Alimentos S.A.',
        contactPerson: 'Ing. Mauricio Silva',
        phone: '+505 2222-5555',
        email: 'logistica@carnesyalimentos.com',
        creditDays: 15,
      ),
    ];

    for (final s in suppliers) {
      await client.suppliers(orgId).doc(s.id).set(s.toMap());
    }

    // 9. Initial Open Cash Shift for Register #1
    final initialShift = CashShiftModel(
      id: 'shift_initial_${DateTime.now().millisecondsSinceEpoch}',
      buId: defaultBuCentralId,
      cashRegisterNumber: 1,
      cashierUserId: 'usr_cashier',
      openedAt: DateTime.now().subtract(const Duration(hours: 3)),
      openingBalance: 200.0,
      cashSales: 150.0,
      cardSales: 80.0,
      creditSales: 65.0,
      expectedCashBalance: 350.0,
      status: ShiftStatusEnum.open,
    );

    await client
        .cashShifts(orgId, defaultBuCentralId)
        .doc(initialShift.id)
        .set(initialShift.toMap());

    // 10. Initial Dashboard Daily Aggregation
    final todayKey = DateTime.now().toIso8601String().substring(0, 10);
    const initialMetrics = DashboardMetricsModel(
      todaySales: 295.00,
      yesterdaySales: 1100.00,
      weekSales: 4890.00,
      monthSales: 18450.00,
      activeCashBalance: 350.00,
      openAccountsBalance: 120.00,
      totalProductsCount: 10,
      totalCustomersCount: 3,
    );

    await client
        .aggregations(orgId, defaultBuCentralId)
        .doc('daily_$todayKey')
        .set(initialMetrics.toMap());

    // 11. Initial Open Account / Bar Tab
    final initialTab = OpenAccountModel(
      id: 'tab_central_mesa1',
      code: 'TAB-001',
      originType: AccountOriginTypeEnum.table,
      tableId: 'table_01',
      tableName: 'Mesa 1 - Pool Clásica',
      customerId: 'cust_carlos',
      customerDisplayName: 'Carlos Mendoza Solís (Mesa 1)',
      status: AccountStatusEnum.open,
      items: const [
        AccountItemModel(
          productId: 'prod_tona_botella',
          name: 'Cerveza Toña 350ml Botella',
          quantity: 2,
          unitPrice: 1.75,
          total: 3.50,
        ),
      ],
      totalAmount: 3.50,
      openedAt: DateTime.now().subtract(const Duration(minutes: 45)),
    );

    await client
        .openAccounts(orgId, defaultBuCentralId)
        .doc(initialTab.id)
        .set(initialTab.toMap());

    // 12. Initial Sample Sales Invoice
    final initialInvoice = InvoiceModel(
      id: 'fac_init_001',
      invoiceNumber: 'FAC-001-000194',
      cashShiftId: initialShift.id,
      cashierUserId: 'usr_cashier',
      customerId: 'cust_carlos',
      customerDisplayName: 'Carlos Mendoza Solís',
      items: const [
        InvoiceItemModel(
          productId: 'prod_cubetazo_tona',
          name: 'Cubetazo Toña (6 Unidades)',
          quantity: 2,
          unitPrice: 9.50,
          total: 19.00,
        ),
        InvoiceItemModel(
          productId: 'prod_alitas_bufalo',
          name: 'Alitas Buffalo Picantes (12 Unidades)',
          quantity: 2,
          unitPrice: 7.50,
          total: 15.00,
        ),
      ],
      subtotal: 34.00,
      taxAmount: 5.10,
      totalAmount: 65.00,
      payments: const [
        PaymentTenderModel(
          method: PaymentMethodEnum.customerCredit,
          amount: 65.00,
        ),
      ],
      creditCarriedOver: 65.00,
      paymentStatus: InvoiceStatusEnum.paid,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    );

    await client
        .invoices(orgId, defaultBuCentralId)
        .doc(initialInvoice.id)
        .set(initialInvoice.toMap());

    // 13. Initial Account Receivable (CxC)
    final initialReceivable = AccountReceivableModel(
      id: 'cxc_carlos_01',
      buId: defaultBuCentralId,
      customerId: 'cust_carlos',
      customerName: 'Carlos Mendoza Solís',
      invoiceId: initialInvoice.id,
      invoiceNumber: initialInvoice.invoiceNumber,
      originalAmount: 65.00,
      pendingAmount: 65.00,
      dueDate: DateTime.now().add(const Duration(days: 30)),
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    );

    final robertoReceivable = AccountReceivableModel(
      id: 'cxc_roberto_01',
      buId: defaultBuCentralId,
      customerId: 'cust_roberto',
      customerName: 'Roberto Gómez',
      invoiceId: 'inv_roberto_01',
      invoiceNumber: 'FAC-2026-0002',
      originalAmount: 45.00,
      pendingAmount: 45.00,
      dueDate: DateTime.now().add(const Duration(days: 15)),
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    );

    await client
        .accountsReceivable(orgId, defaultBuCentralId)
        .doc(initialReceivable.id)
        .set(initialReceivable.toMap());

    await client
        .accountsReceivable(orgId, defaultBuCentralId)
        .doc(robertoReceivable.id)
        .set(robertoReceivable.toMap());

    // 14. Initial Account Payable (CxP)
    final initialPayable = AccountPayableModel(
      id: 'cxp_cerveceria_01',
      buId: defaultBuCentralId,
      supplierId: 'sup_cerveceria',
      supplierName: 'Compañía Cervecera Nacional',
      invoiceNumber: 'FAC-PROV-99881',
      amount: 1250.00,
      paidAmount: 0.00,
      dueDate: DateTime.now().add(const Duration(days: 15)),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    );

    await client
        .accountsPayable(orgId, defaultBuCentralId)
        .doc(initialPayable.id)
        .set(initialPayable.toMap());

    // 15. Initial Purchase Order (PO)
    final initialPo = PurchaseOrderModel(
      id: 'po_cerveceria_01',
      buId: defaultBuCentralId,
      supplierId: 'sup_cerveceria',
      supplierName: 'Compañía Cervecera Nacional',
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      totalAmount: 300.00,
      status: PurchaseOrderStatusEnum.ordered,
      items: const [
        PurchaseOrderItemModel(
          productId: 'prod_tona_botella',
          productName: 'Cerveza Toña 350ml Botella',
          quantityOrdered: 300,
          unitCost: 1.00,
          totalCost: 300.00,
        ),
      ],
    );

    await client
        .purchaseOrders(orgId, defaultBuCentralId)
        .doc(initialPo.id)
        .set(initialPo.toMap());

    // 16. Initial Stock Movement (Kardex)
    final initialMovement = StockMovementModel(
      id: 'mov_init_01',
      buId: defaultBuCentralId,
      warehouseId: 'wh_central',
      productId: 'prod_tona_botella',
      productName: 'Cerveza Toña 350ml Botella',
      movementType: MovementTypeEnum.purchaseReceipt,
      quantity: 150.0,
      unitCost: 1.00,
      totalCost: 150.0,
      referenceId: 'PO-1001',
      notes: 'Inbound reception from Cervecera',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    );

    await client
        .stockMovements(orgId, defaultBuCentralId)
        .doc(initialMovement.id)
        .set(initialMovement.toMap());

    // 17. Initial Kitchen Order (KDS)
    final initialKds = KitchenOrderModel(
      id: 'kds_init_01',
      buId: defaultBuCentralId,
      orderCode: 'ORD-101',
      tableOrTabName: 'Mesa 1 - Pool Clásica',
      status: KdsStatusEnum.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      items: const [
        KitchenOrderItemModel(
          productId: 'prod_alitas_bufalo',
          productName: 'Alitas Buffalo Picantes',
          quantity: 2,
          notes: 'Picante medio',
        ),
        KitchenOrderItemModel(
          productId: 'prod_nachos_especial',
          productName: 'Nachos Mixtos con Queso',
          quantity: 1,
          notes: 'Extra queso',
        ),
      ],
    );

    await client
        .kitchenOrders(orgId, defaultBuCentralId)
        .doc(initialKds.id)
        .set(initialKds.toMap());

    // 18. Initial Audit Logs
    final initialAudits = [
      AuditLogModel(
        id: 'audit_init_01',
        orgId: orgId,
        buId: defaultBuCentralId,
        userId: 'usr_owner',
        userDisplayName: 'Carlos Machado (Admin)',
        action: AuditActionEnum.stockAdjustment,
        description: 'Inicialización de base de datos corporativa Logisto ERP',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      AuditLogModel(
        id: 'audit_init_02',
        orgId: orgId,
        buId: defaultBuCentralId,
        userId: 'usr_admin',
        userDisplayName: 'Juan Pérez',
        action: AuditActionEnum.voidItem,
        description: 'Voided 1x Cerveza Toña from Tab-0101 (Client returned)',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AuditLogModel(
        id: 'audit_init_03',
        orgId: orgId,
        buId: defaultBuCentralId,
        userId: 'usr_owner',
        userDisplayName: 'Carlos Machado (Admin)',
        action: AuditActionEnum.rateChange,
        description: 'Updated Table 3 Hourly Rate for Happy Hour',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];

    for (final a in initialAudits) {
      await client.auditLogs(orgId).doc(a.id).set(a.toMap());
    }
  }
}
