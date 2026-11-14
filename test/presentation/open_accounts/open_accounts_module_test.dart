import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/account_status_enum.dart';
import 'package:logisto/core/enums/feature_status_enum.dart';
import 'package:logisto/core/enums/product_type_enum.dart';
import 'package:logisto/data/repositories/open_account_repository.dart';
import 'package:logisto/data/repositories/product_repository.dart';
import 'package:logisto/domain/models/open_account_model.dart';
import 'package:logisto/domain/models/product_model.dart';
import 'package:logisto/locator.dart';
import 'package:logisto/main.dart';
import 'package:logisto/presentation/navigation/app_routes.dart';
import 'package:logisto/presentation/navigation/navigation_provider.dart';
import 'package:logisto/presentation/open_accounts/open_accounts_provider.dart';
import 'package:logisto/presentation/open_accounts/open_accounts_screen.dart';
import 'package:mocktail/mocktail.dart';
import '../../test_helpers.dart';

class MockOpenAccountRepository extends Mock implements OpenAccountRepository {}

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final dummyProduct = ProductModel(
    id: 'prod_tona',
    orgId: 'org_1',
    sku: 'BEV-001',
    name: 'Cerveza Toña 350ml',
    categoryId: 'cat_bev',
    costPrice: 1.00,
    salePrice: 1.75,
    productType: ProductTypeEnum.standard,
    isActive: true,
  );

  final dummyAccount = OpenAccountModel(
    id: 'tab_test',
    code: 'TAB-99',
    originType: 'table',
    tableId: 'tbl_1',
    tableName: 'Mesa 1',
    customerDisplayName: 'Roberto Gomez',
    status: AccountStatusEnum.open,
    items: const [
      AccountItemModel(
        productId: 'prod_tona',
        name: 'Cerveza Toña',
        quantity: 2,
        unitPrice: 1.75,
        total: 3.50,
      ),
    ],
    totalAmount: 3.50,
    openedAt: DateTime(2026, 11, 12, 18, 0),
  );

  group('OpenAccountsProvider Unit Tests', () {
    late MockOpenAccountRepository mockRepo;
    late MockProductRepository mockProductRepo;
    late OpenAccountsProvider provider;

    setUp(() {
      mockRepo = MockOpenAccountRepository();
      mockProductRepo = MockProductRepository();
      provider = OpenAccountsProvider(
        repository: mockRepo,
        productRepository: mockProductRepo,
      );
    });

    test('loadAccounts retrieves tabs and auto-selects first tab', () async {
      when(
        () => mockRepo.getOpenAccounts(orgId: 'org_1', buId: 'bu_1'),
      ).thenAnswer((_) async => [dummyAccount]);
      when(
        () => mockProductRepo.getProducts('org_1'),
      ).thenAnswer((_) async => [dummyProduct]);

      await provider.loadAccounts(orgId: 'org_1', buId: 'bu_1');

      expect(provider.status, equals(FeatureStatusEnum.loaded));
      expect(provider.accounts.length, equals(1));
      expect(provider.selectedAccount?.id, equals('tab_test'));
    });

    test(
      'addProductToSelected increments item quantity or appends product',
      () async {
        when(
          () => mockRepo.getOpenAccounts(orgId: 'org_1', buId: 'bu_1'),
        ).thenAnswer((_) async => [dummyAccount]);
        when(
          () => mockProductRepo.getProducts('org_1'),
        ).thenAnswer((_) async => [dummyProduct]);

        await provider.loadAccounts(orgId: 'org_1', buId: 'bu_1');

        final product = provider.quickCatalog.first;
        provider.addProductToSelected(product);

        expect(provider.selectedAccount?.items.first.quantity, equals(3));
        expect(provider.selectedAccount?.totalAmount, equals(5.25));
      },
    );

    test(
      'adjustItemQuantity modifies or removes item when quantity reaches zero',
      () async {
        when(
          () => mockRepo.getOpenAccounts(orgId: 'org_1', buId: 'bu_1'),
        ).thenAnswer((_) async => [dummyAccount]);
        when(
          () => mockProductRepo.getProducts('org_1'),
        ).thenAnswer((_) async => [dummyProduct]);

        await provider.loadAccounts(orgId: 'org_1', buId: 'bu_1');

        // Reduce by 1 -> quantity becomes 1
        provider.adjustItemQuantity(0, -1);
        expect(provider.selectedAccount?.items.first.quantity, equals(1));

        // Reduce by 1 -> item removed
        provider.adjustItemQuantity(0, -1);
        expect(provider.selectedAccount?.items, isEmpty);
        expect(provider.selectedAccount?.totalAmount, equals(0.0));
      },
    );

    test('closeSelectedAccount removes tab and resets selection', () async {
      when(
        () => mockRepo.getOpenAccounts(orgId: 'org_1', buId: 'bu_1'),
      ).thenAnswer((_) async => [dummyAccount]);
      when(
        () => mockProductRepo.getProducts('org_1'),
      ).thenAnswer((_) async => [dummyProduct]);

      await provider.loadAccounts(orgId: 'org_1', buId: 'bu_1');
      provider.closeSelectedAccount();

      expect(provider.accounts, isEmpty);
      expect(provider.selectedAccount, isNull);
    });
  });

  group('OpenAccountsScreen Widget Tests', () {
    setUp(() async {
      await setupSeededLocator();
    });

    tearDown(() async {
      await resetLocator();
    });

    testWidgets('renders open accounts screen with catalog and items panel', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: OpenAccountsScreen()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Open Accounts & Tabs'), findsOneWidget);
      expect(find.text('Fast Bar / Kitchen Catalog'), findsOneWidget);

      // Verify checkout button navigates to POS
      expect(find.text('Proceed to Checkout'), findsOneWidget);
      await tester.tap(find.text('Proceed to Checkout'));
      await tester.pumpAndSettle();

      expect(locator<NavigationProvider>().currentRoute, equals(AppRoutes.pos));
    });
  });
}
