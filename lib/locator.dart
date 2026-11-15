import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/firestore/firestore_client.dart';
import 'data/preferences/app_preferences.dart';
import 'data/services/firebase_auth_service.dart';
import 'domain/services/auth_service.dart';
import 'domain/services/receipt_pdf_generator.dart';
import 'domain/services/printer_service.dart';
import 'data/services/printing_service_adapter.dart';
import 'data/repositories/account_payable_repository.dart';
import 'data/repositories/account_receivable_repository.dart';
import 'data/repositories/audit_log_repository.dart';
import 'data/repositories/billiard_table_repository.dart';
import 'data/repositories/business_unit_repository.dart';
import 'data/repositories/cash_shift_repository.dart';
import 'data/repositories/customer_repository.dart';
import 'data/repositories/invoice_repository.dart';
import 'data/repositories/kitchen_order_repository.dart';
import 'data/repositories/open_account_repository.dart';
import 'data/repositories/organization_repository.dart';
import 'data/repositories/product_repository.dart';
import 'data/repositories/purchase_order_repository.dart';
import 'data/repositories/stock_movement_repository.dart';
import 'data/repositories/supplier_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/warehouse_repository.dart';
import 'domain/services/billiard_rate_calculator.dart';
import 'domain/services/cash_shift_calculator.dart';
import 'domain/services/checkout_tender_engine.dart';
import 'presentation/auth/login_provider.dart';
import 'presentation/audit/audit_log_provider.dart';
import 'presentation/billiards/billiard_provider.dart';
import 'presentation/business_units/business_unit_selector_provider.dart';
import 'presentation/cash/cash_shift_provider.dart';
import 'presentation/context/business_context_provider.dart';
import 'presentation/customers/customer_catalog_provider.dart';
import 'presentation/dashboard/dashboard_provider.dart';
import 'presentation/inventory/inventory_warehouse_provider.dart';
import 'presentation/invoices/invoice_history_provider.dart';
import 'presentation/kitchen/kitchen_provider.dart';
import 'presentation/navigation/navigation_provider.dart';
import 'presentation/onboarding/onboarding_provider.dart';
import 'presentation/open_accounts/open_accounts_provider.dart';
import 'presentation/payables/accounts_payable_provider.dart';
import 'presentation/pos/pos_checkout_provider.dart';
import 'presentation/products/product_catalog_provider.dart';
import 'presentation/purchasing/purchase_order_provider.dart';
import 'presentation/receivables/accounts_receivable_provider.dart';
import 'presentation/reports/reports_provider.dart';
import 'presentation/settings/printer_management_provider.dart';
import 'presentation/settings/settings_provider.dart';
import 'presentation/suppliers/supplier_catalog_provider.dart';
import 'presentation/users/user_management_provider.dart';

/// Global service locator instance managed via GetIt.
final GetIt locator = GetIt.instance;

/// Resets the service locator instance for clean test teardown and re-registration.
Future<void> resetLocator() async {
  await locator.reset();
}

/// Configures and registers all foundational services, repositories, and preferences.
/// Conforms to RULE-ARCH-002 (Service Locator and Dependency Injection).
Future<void> setupLocator({
  SharedPreferences? preferences,
  FirestoreClient? firestoreClient,
  bool reset = false,
}) async {
  if (reset) {
    await resetLocator();
  }

  // If already registered, do not re-register in active environments
  if (locator.isRegistered<AppPreferences>()) {
    return;
  }

  // Local key-value preferences
  final appPrefs = await AppPreferences.getInstance(preferences: preferences);
  locator.registerSingleton<AppPreferences>(appPrefs);

  // Enterprise Authentication Service (Firebase Authentication)
  locator.registerLazySingleton<AuthService>(() => FirebaseAuthService());

  // Cloud Firestore infrastructure client
  final client = firestoreClient ?? FirestoreClient();
  locator.registerLazySingleton<FirestoreClient>(() => client);

  // Pure domain engines & calculators
  locator.registerLazySingleton<BilliardRateCalculator>(
    () => const BilliardRateCalculator(),
  );
  locator.registerLazySingleton<CheckoutTenderEngine>(
    () => const CheckoutTenderEngine(),
  );
  locator.registerLazySingleton<CashShiftCalculator>(
    () => const CashShiftCalculator(),
  );

  // Printing & Thermal Voucher Generation Engines
  locator.registerLazySingleton<IReceiptPdfGenerator>(
    () => ThermalReceiptPdfGenerator(),
  );
  locator.registerLazySingleton<IPrinterService>(
    () => PrintingServiceAdapter(
      receiptPdfGenerator: locator<IReceiptPdfGenerator>(),
      appPreferences: locator<AppPreferences>(),
    ),
  );

  // Enterprise data repositories
  locator.registerLazySingleton<OrganizationRepository>(
    () => FirestoreOrganizationRepository(client: locator<FirestoreClient>()),
  );
  locator.registerLazySingleton<BusinessUnitRepository>(
    () => FirestoreBusinessUnitRepository(client: locator<FirestoreClient>()),
  );
  locator.registerLazySingleton<BilliardTableRepository>(
    () => FirestoreBilliardTableRepository(client: locator<FirestoreClient>()),
  );
  locator.registerLazySingleton<CustomerRepository>(
    () => FirestoreCustomerRepository(client: locator<FirestoreClient>()),
  );
  locator.registerLazySingleton<OpenAccountRepository>(
    () => FirestoreOpenAccountRepository(client: locator<FirestoreClient>()),
  );
  locator.registerLazySingleton<InvoiceRepository>(
    () => FirestoreInvoiceRepository(client: locator<FirestoreClient>()),
  );
  locator.registerLazySingleton<ProductRepository>(
    () => FirestoreProductRepository(client: locator<FirestoreClient>()),
  );
  locator.registerLazySingleton<WarehouseRepository>(
    () => FirestoreWarehouseRepository(client: locator<FirestoreClient>()),
  );
  locator.registerLazySingleton<CashShiftRepository>(
    () => FirestoreCashShiftRepository(client: locator<FirestoreClient>()),
  );
  locator.registerLazySingleton<SupplierRepository>(
    () => FirestoreSupplierRepository(client: locator<FirestoreClient>()),
  );
  locator.registerLazySingleton<AccountReceivableRepository>(
    () => FirestoreAccountReceivableRepository(
      client: locator<FirestoreClient>(),
    ),
  );
  locator.registerLazySingleton<PurchaseOrderRepository>(
    () => FirestorePurchaseOrderRepository(client: locator<FirestoreClient>()),
  );
  locator.registerLazySingleton<AccountPayableRepository>(
    () => FirestoreAccountPayableRepository(client: locator<FirestoreClient>()),
  );
  locator.registerLazySingleton<StockMovementRepository>(
    () => FirestoreStockMovementRepository(client: locator<FirestoreClient>()),
  );
  locator.registerLazySingleton<KitchenOrderRepository>(
    () => FirestoreKitchenOrderRepository(client: locator<FirestoreClient>()),
  );
  locator.registerLazySingleton<AuditLogRepository>(
    () => FirestoreAuditLogRepository(client: locator<FirestoreClient>()),
  );
  locator.registerLazySingleton<UserRepository>(
    () => FirestoreUserRepository(client: locator<FirestoreClient>()),
  );

  // Application session and feature providers
  locator.registerLazySingleton<BusinessContextProvider>(
    () => BusinessContextProvider(preferences: locator<AppPreferences>()),
  );
  locator.registerLazySingleton<NavigationProvider>(() => NavigationProvider());
  locator.registerLazySingleton<LoginProvider>(
    () => LoginProvider(
      preferences: locator<AppPreferences>(),
      authService: locator.isRegistered<AuthService>()
          ? locator<AuthService>()
          : null,
    ),
  );
  locator.registerLazySingleton<OnboardingProvider>(
    () => OnboardingProvider(
      preferences: locator<AppPreferences>(),
      orgRepository: locator<OrganizationRepository>(),
      buRepository: locator<BusinessUnitRepository>(),
    ),
  );
  locator.registerLazySingleton<BusinessUnitSelectorProvider>(
    () => BusinessUnitSelectorProvider(
      repository: locator<BusinessUnitRepository>(),
      contextProvider: locator<BusinessContextProvider>(),
    ),
  );
  locator.registerLazySingleton<DashboardProvider>(
    () => DashboardProvider(
      client: locator<FirestoreClient>(),
      invoiceRepository: locator<InvoiceRepository>(),
      productRepository: locator<ProductRepository>(),
    ),
  );
  locator.registerLazySingleton<BilliardProvider>(
    () => BilliardProvider(
      repository: locator<BilliardTableRepository>(),
      rateCalculator: locator<BilliardRateCalculator>(),
      openAccountRepository: locator<OpenAccountRepository>(),
    ),
  );
  locator.registerLazySingleton<OpenAccountsProvider>(
    () => OpenAccountsProvider(
      repository: locator<OpenAccountRepository>(),
      productRepository: locator<ProductRepository>(),
    ),
  );
  locator.registerLazySingleton<PosCheckoutProvider>(
    () => PosCheckoutProvider(
      invoiceRepository: locator<InvoiceRepository>(),
      tenderEngine: locator<CheckoutTenderEngine>(),
      openAccountRepository: locator<OpenAccountRepository>(),
      stockMovementRepository: locator<StockMovementRepository>(),
      accountReceivableRepository: locator<AccountReceivableRepository>(),
      customerRepository: locator<CustomerRepository>(),
      cashShiftRepository: locator<CashShiftRepository>(),
    ),
  );
  locator.registerLazySingleton<KitchenProvider>(
    () => KitchenProvider(repository: locator<KitchenOrderRepository>()),
  );
  locator.registerLazySingleton<CashShiftProvider>(
    () => CashShiftProvider(
      repository: locator<CashShiftRepository>(),
      calculator: locator<CashShiftCalculator>(),
    ),
  );
  locator.registerLazySingleton<ProductCatalogProvider>(
    () => ProductCatalogProvider(repository: locator<ProductRepository>()),
  );
  locator.registerLazySingleton<InventoryWarehouseProvider>(
    () => InventoryWarehouseProvider(
      warehouseRepository: locator<WarehouseRepository>(),
      stockMovementRepository: locator<StockMovementRepository>(),
      productRepository: locator<ProductRepository>(),
      client: locator<FirestoreClient>(),
    ),
  );
  locator.registerLazySingleton<CustomerCatalogProvider>(
    () => CustomerCatalogProvider(repository: locator<CustomerRepository>()),
  );
  locator.registerLazySingleton<InvoiceHistoryProvider>(
    () => InvoiceHistoryProvider(repository: locator<InvoiceRepository>()),
  );
  locator.registerLazySingleton<SupplierCatalogProvider>(
    () => SupplierCatalogProvider(repository: locator<SupplierRepository>()),
  );
  locator.registerLazySingleton<PurchaseOrderProvider>(
    () => PurchaseOrderProvider(
      repository: locator<PurchaseOrderRepository>(),
      accountPayableRepository: locator<AccountPayableRepository>(),
      stockMovementRepository: locator<StockMovementRepository>(),
      supplierRepository: locator<SupplierRepository>(),
    ),
  );
  locator.registerLazySingleton<AccountsReceivableProvider>(
    () => AccountsReceivableProvider(
      repository: locator<AccountReceivableRepository>(),
      customerRepository: locator<CustomerRepository>(),
    ),
  );
  locator.registerLazySingleton<AccountsPayableProvider>(
    () => AccountsPayableProvider(
      repository: locator<AccountPayableRepository>(),
      supplierRepository: locator<SupplierRepository>(),
    ),
  );
  locator.registerLazySingleton<UserManagementProvider>(
    () => UserManagementProvider(repository: locator<UserRepository>()),
  );
  locator.registerLazySingleton<SettingsProvider>(
    () => SettingsProvider(preferences: locator<AppPreferences>()),
  );
  locator.registerLazySingleton<PrinterManagementProvider>(
    () => PrinterManagementProvider(
      printerService: locator<IPrinterService>(),
      appPreferences: locator<AppPreferences>(),
    ),
  );
  locator.registerLazySingleton<ReportsProvider>(
    () => ReportsProvider(
      invoiceRepository: locator<InvoiceRepository>(),
      productRepository: locator<ProductRepository>(),
      cashShiftRepository: locator<CashShiftRepository>(),
      accountReceivableRepository: locator<AccountReceivableRepository>(),
      billiardTableRepository: locator<BilliardTableRepository>(),
    ),
  );
  locator.registerLazySingleton<AuditLogProvider>(
    () => AuditLogProvider(repository: locator<AuditLogRepository>()),
  );
}
