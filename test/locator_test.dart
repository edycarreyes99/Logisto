import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/data/firestore/firestore_client.dart';
import 'package:logisto/data/preferences/app_preferences.dart';
import 'package:logisto/data/repositories/account_payable_repository.dart';
import 'package:logisto/data/repositories/account_receivable_repository.dart';
import 'package:logisto/data/repositories/audit_log_repository.dart';
import 'package:logisto/data/repositories/billiard_table_repository.dart';
import 'package:logisto/data/repositories/business_unit_repository.dart';
import 'package:logisto/data/repositories/cash_shift_repository.dart';
import 'package:logisto/data/repositories/customer_repository.dart';
import 'package:logisto/data/repositories/invoice_repository.dart';
import 'package:logisto/data/repositories/kitchen_order_repository.dart';
import 'package:logisto/data/repositories/open_account_repository.dart';
import 'package:logisto/data/repositories/organization_repository.dart';
import 'package:logisto/data/repositories/product_repository.dart';
import 'package:logisto/data/repositories/purchase_order_repository.dart';
import 'package:logisto/data/repositories/stock_movement_repository.dart';
import 'package:logisto/data/repositories/supplier_repository.dart';
import 'package:logisto/data/repositories/user_repository.dart';
import 'package:logisto/data/repositories/warehouse_repository.dart';
import 'package:logisto/domain/services/billiard_rate_calculator.dart';
import 'package:logisto/domain/services/cash_shift_calculator.dart';
import 'package:logisto/domain/services/checkout_tender_engine.dart';
import 'package:logisto/locator.dart';
import 'package:logisto/presentation/audit/audit_log_provider.dart';
import 'package:logisto/presentation/auth/login_provider.dart';
import 'package:logisto/presentation/billiards/billiard_provider.dart';
import 'package:logisto/presentation/business_units/business_unit_selector_provider.dart';
import 'package:logisto/presentation/cash/cash_shift_provider.dart';
import 'package:logisto/presentation/context/business_context_provider.dart';
import 'package:logisto/presentation/customers/customer_catalog_provider.dart';
import 'package:logisto/presentation/dashboard/dashboard_provider.dart';
import 'package:logisto/presentation/inventory/inventory_warehouse_provider.dart';
import 'package:logisto/presentation/invoices/invoice_history_provider.dart';
import 'package:logisto/presentation/kitchen/kitchen_provider.dart';
import 'package:logisto/presentation/navigation/navigation_provider.dart';
import 'package:logisto/presentation/onboarding/onboarding_provider.dart';
import 'package:logisto/presentation/open_accounts/open_accounts_provider.dart';
import 'package:logisto/presentation/payables/accounts_payable_provider.dart';
import 'package:logisto/presentation/pos/pos_checkout_provider.dart';
import 'package:logisto/presentation/products/product_catalog_provider.dart';
import 'package:logisto/presentation/purchasing/purchase_order_provider.dart';
import 'package:logisto/presentation/receivables/accounts_receivable_provider.dart';
import 'package:logisto/presentation/reports/reports_provider.dart';
import 'package:logisto/presentation/settings/settings_provider.dart';
import 'package:logisto/presentation/suppliers/supplier_catalog_provider.dart';
import 'package:logisto/presentation/users/user_management_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockFirestoreClient extends Mock implements FirestoreClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Service Locator DI Registrations', () {
    late MockFirestoreClient mockFirestoreClient;

    setUp(() async {
      await resetLocator();
      SharedPreferences.setMockInitialValues({});
      mockFirestoreClient = MockFirestoreClient();
    });

    test(
      'registers and resolves all foundational singletons and services',
      () async {
        await setupLocator(firestoreClient: mockFirestoreClient);

        expect(locator.isRegistered<AppPreferences>(), isTrue);
        expect(locator<AppPreferences>(), isNotNull);

        expect(locator.isRegistered<FirestoreClient>(), isTrue);
        expect(locator<FirestoreClient>(), same(mockFirestoreClient));

        expect(locator.isRegistered<BilliardRateCalculator>(), isTrue);
        expect(locator<BilliardRateCalculator>(), isNotNull);

        expect(locator.isRegistered<CheckoutTenderEngine>(), isTrue);
        expect(locator<CheckoutTenderEngine>(), isNotNull);

        expect(locator.isRegistered<CashShiftCalculator>(), isTrue);
        expect(locator<CashShiftCalculator>(), isNotNull);

        expect(locator.isRegistered<OrganizationRepository>(), isTrue);
        expect(locator<OrganizationRepository>(), isNotNull);

        expect(locator.isRegistered<BusinessUnitRepository>(), isTrue);
        expect(locator<BusinessUnitRepository>(), isNotNull);

        expect(locator.isRegistered<BilliardTableRepository>(), isTrue);
        expect(locator<BilliardTableRepository>(), isNotNull);

        expect(locator.isRegistered<CustomerRepository>(), isTrue);
        expect(locator<CustomerRepository>(), isNotNull);

        expect(locator.isRegistered<OpenAccountRepository>(), isTrue);
        expect(locator<OpenAccountRepository>(), isNotNull);

        expect(locator.isRegistered<InvoiceRepository>(), isTrue);
        expect(locator<InvoiceRepository>(), isNotNull);

        expect(locator.isRegistered<ProductRepository>(), isTrue);
        expect(locator<ProductRepository>(), isNotNull);

        expect(locator.isRegistered<WarehouseRepository>(), isTrue);
        expect(locator<WarehouseRepository>(), isNotNull);

        expect(locator.isRegistered<CashShiftRepository>(), isTrue);
        expect(locator<CashShiftRepository>(), isNotNull);

        expect(locator.isRegistered<SupplierRepository>(), isTrue);
        expect(locator<SupplierRepository>(), isNotNull);

        expect(locator.isRegistered<AccountReceivableRepository>(), isTrue);
        expect(locator<AccountReceivableRepository>(), isNotNull);

        expect(locator.isRegistered<PurchaseOrderRepository>(), isTrue);
        expect(locator<PurchaseOrderRepository>(), isNotNull);

        expect(locator.isRegistered<AccountPayableRepository>(), isTrue);
        expect(locator<AccountPayableRepository>(), isNotNull);

        expect(locator.isRegistered<StockMovementRepository>(), isTrue);
        expect(locator<StockMovementRepository>(), isNotNull);

        expect(locator.isRegistered<KitchenOrderRepository>(), isTrue);
        expect(locator<KitchenOrderRepository>(), isNotNull);

        expect(locator.isRegistered<AuditLogRepository>(), isTrue);
        expect(locator<AuditLogRepository>(), isNotNull);

        expect(locator.isRegistered<UserRepository>(), isTrue);
        expect(locator<UserRepository>(), isNotNull);

        expect(locator.isRegistered<BusinessContextProvider>(), isTrue);
        expect(locator<BusinessContextProvider>(), isNotNull);

        // Feature presentation providers
        expect(locator.isRegistered<NavigationProvider>(), isTrue);
        expect(locator<NavigationProvider>(), isNotNull);

        expect(locator.isRegistered<LoginProvider>(), isTrue);
        expect(locator<LoginProvider>(), isNotNull);

        expect(locator.isRegistered<OnboardingProvider>(), isTrue);
        expect(locator<OnboardingProvider>(), isNotNull);

        expect(locator.isRegistered<BusinessUnitSelectorProvider>(), isTrue);
        expect(locator<BusinessUnitSelectorProvider>(), isNotNull);

        expect(locator.isRegistered<DashboardProvider>(), isTrue);
        expect(locator<DashboardProvider>(), isNotNull);

        expect(locator.isRegistered<BilliardProvider>(), isTrue);
        expect(locator<BilliardProvider>(), isNotNull);

        expect(locator.isRegistered<OpenAccountsProvider>(), isTrue);
        expect(locator<OpenAccountsProvider>(), isNotNull);

        expect(locator.isRegistered<PosCheckoutProvider>(), isTrue);
        expect(locator<PosCheckoutProvider>(), isNotNull);

        expect(locator.isRegistered<KitchenProvider>(), isTrue);
        expect(locator<KitchenProvider>(), isNotNull);

        expect(locator.isRegistered<CashShiftProvider>(), isTrue);
        expect(locator<CashShiftProvider>(), isNotNull);

        expect(locator.isRegistered<ProductCatalogProvider>(), isTrue);
        expect(locator<ProductCatalogProvider>(), isNotNull);

        expect(locator.isRegistered<InventoryWarehouseProvider>(), isTrue);
        expect(locator<InventoryWarehouseProvider>(), isNotNull);

        expect(locator.isRegistered<CustomerCatalogProvider>(), isTrue);
        expect(locator<CustomerCatalogProvider>(), isNotNull);

        expect(locator.isRegistered<InvoiceHistoryProvider>(), isTrue);
        expect(locator<InvoiceHistoryProvider>(), isNotNull);

        expect(locator.isRegistered<SupplierCatalogProvider>(), isTrue);
        expect(locator<SupplierCatalogProvider>(), isNotNull);

        expect(locator.isRegistered<PurchaseOrderProvider>(), isTrue);
        expect(locator<PurchaseOrderProvider>(), isNotNull);

        expect(locator.isRegistered<AccountsReceivableProvider>(), isTrue);
        expect(locator<AccountsReceivableProvider>(), isNotNull);

        expect(locator.isRegistered<AccountsPayableProvider>(), isTrue);
        expect(locator<AccountsPayableProvider>(), isNotNull);

        expect(locator.isRegistered<UserManagementProvider>(), isTrue);
        expect(locator<UserManagementProvider>(), isNotNull);

        expect(locator.isRegistered<SettingsProvider>(), isTrue);
        expect(locator<SettingsProvider>(), isNotNull);

        expect(locator.isRegistered<ReportsProvider>(), isTrue);
        expect(locator<ReportsProvider>(), isNotNull);

        expect(locator.isRegistered<AuditLogProvider>(), isTrue);
        expect(locator<AuditLogProvider>(), isNotNull);
      },
    );

    test('resetLocator clears registry for clean test re-execution', () async {
      await setupLocator(firestoreClient: mockFirestoreClient);
      expect(locator.isRegistered<AppPreferences>(), isTrue);

      await resetLocator();
      expect(locator.isRegistered<AppPreferences>(), isFalse);
    });
  });
}
